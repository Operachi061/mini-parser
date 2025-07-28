const std = @import("std");
const mem = std.mem;

pub const Table = struct {
    long: []const u8,
    short: u8,
    type: enum { argument, boolean },
};

pub fn argument_value(argument: []const u8, argv_index: usize) []const u8 {
    const argv = std.os.argv;
    var index: usize = 0;

    while (index < argument.len) : (index += 1) {
        switch (argument[index]) {
            '=' => return @constCast(&mem.splitBackwardsAny(u8, argument, "=")).first(),
            else => {},
        }
    }

    return mem.span(argv[argv_index + 1]);
}

pub fn compare_argument(args: usize, argument: []const u8, comptime flag: Table) struct {
    args: usize,
    bool: bool,
} {
    if (argument[0] != '-') return .{ .args = args, .bool = false };

    const flag_argument = if (flag.type != .boolean)
        @constCast(&mem.splitAny(u8, argument, "=")).first()
    else
        argument;

    if (!mem.startsWith(u8, flag_argument, "--")) {
        for (args..flag_argument.len) |index| {
            if (flag_argument[index] == flag.short) {
                return .{
                    .args = if (index + 1 != flag_argument.len)
                        index + 1
                    else
                        index,
                    .bool = true,
                };
            }
        }
    }

    return .{ .args = args, .bool = mem.eql(u8, "--" ++ flag.long, flag_argument) };
}

pub fn init(index: usize, args: usize, comptime table: []const Table) !struct {
    arg: u8,
    val: []const u8,
    args: usize,
} {
    const argv = std.os.argv;
    const argument = mem.sliceTo(argv[0..][index], 0);

    if (argv.len <= 1) {
        return .{ .arg = 0, .val = undefined, .args = args };
    }

    var i: usize = 0;
    while (i < table.len) : (i += 1) {
        inline for (table) |flag| {
            const comparison = compare_argument(args, argument, flag);

            if (comparison.bool) {
                return .{
                    .arg = flag.short,
                    .val = switch (flag.type) {
                        .boolean => undefined,
                        .argument => argument_value(argument, index),
                    },
                    .args = comparison.args,
                };
            }
        }

        if (argument[0] == '-' or mem.startsWith(u8, argument, "--")) {
            return .{ .arg = 1, .val = mem.span(argv[index]), .args = args };
        }
    }

    return .{ .arg = 2, .val = mem.span(argv[index]), .args = args };
}
