const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("mini_parser", .{
        .root_source_file = b.path("src/mini_parser.zig"),
    });
}
