const std = @import("std");
const mem = std.mem;

pub const Table = struct {
    name: []const u8,
    short_name: u8,
    type: enum { argument, boolean },
};

const ArgumentData = struct {
    argument: usize,
    value: []const u8,
};

pub fn init(Arg: [*:0]u8, comptime table: []const Table) !ArgumentData {
    const args = mem.sliceTo(Arg, 0);
    const argv = std.os.argv;

    if (argv.len == 1) return .{ .argument = 0, .value = "" };

    var i: usize = 1;
    while (table.len > i) : (i += 1) {
        inline for (table, 1..table.len + 1) |flag, arg| {
            if (mem.eql(u8, "--" ++ flag.name, args) or mem.eql(u8, &[_]u8{ '-', flag.short_name }, args)) {
                return switch (flag.type) {
                    .boolean => .{ .argument = arg, .value = "" },
                    .argument => .{ .argument = arg, .value = mem.sliceTo(Arg[args.len + 1 ..], 0) },
                };
            }
        }
        if (mem.eql(u8, args[0..1], "--") or args[0] == '-') return .{ .argument = table.len + 1, .value = "" };
    }

    return .{ .argument = table.len + 3, .value = "" };
}
