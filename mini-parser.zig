const std = @import("std");
const mem = std.mem;

pub const Table = struct {
    long: []const u8,
    short: u8,
    type: enum { argument, boolean },
};

const ArgData = struct {
    arg: usize,
    val: []const u8,
};

pub fn init(index: usize, comptime table: []const Table) !ArgData {
    const argv = std.os.argv;
    const args = mem.sliceTo(argv[0..][index], 0);

    if (argv.len == 1) {
        return .{ .arg = 0, .val = "" };
    }

    for (1..table.len) |_| {
        inline for (table, 1..table.len + 1) |flag, arg| {
            const argument = mem.eql(u8, "--" ++ flag.long, args);
            const short_argument = mem.eql(u8, &[2]u8{ '-', flag.short }, args);

            if (argument or short_argument) {
                return switch (flag.type) {
                    .boolean => .{ .arg = arg, .val = undefined },
                    .argument => .{ .arg = arg, .val = mem.span(argv[index + 1]) },
                };
            }
        }

        if (args[0] == '-' or mem.eql(u8, args[0..1], "--")) {
            return .{ .arg = table.len + 1, .val = mem.span(argv[index]) };
        }
    }

    return .{ .arg = table.len + 2, .val = undefined };
}
