const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("mini-parser", .{
        .root_source_file = b.path("mini-parser.zig"),
    });
}
