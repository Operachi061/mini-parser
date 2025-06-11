# mini-parser
mini-parser is a very-minimal parser for the [Zig](https://ziglang.org) language.

## Example
```zig
const std = @import("std");
const mini_parser = @import("mini-parser");
const debug = std.debug;
const posix = std.posix;

const usage =
    \\Usage: example [OPTIONS]
    \\
    \\Options:
    \\  --help,       -h    Display help list
    \\  --text=TEXT,  -t    Print the text
    \\  --bool,       -b    Enable the boolean
    \\
;

pub fn main() !void {
    var i: usize = 0;
    while (std.os.argv.len > i) : (i += 1) {
        const parser = try mini_parser.init(i, &.{
            .{ .long = "help", .short = 'h', .type = .boolean },  // 1
            .{ .long = "text", .short = 't', .type = .argument }, // 2
            .{ .long = "bool", .short = 'b', .type = .boolean },  // 3
        });

        switch (parser.arg) {
            0 => {
                debug.print("no argument was given.\n", .{});
                posix.exit(0);
            },
            1 => { // 1
                debug.print("{s}\n", .{usage});
                posix.exit(0);
            },
            2 => { // 2
                debug.print("Text: {s}\n", .{parser.val});
            }, 
            3 => { // 3
                debug.print("Enabled boolean!\n", .{}); 
            },
            4 => {
                debug.print("argument '{s}' does not exist.\n", .{parser.val});
                posix.exit(0);
            },
            else => {},
        }
    }
}
```

## Installation

Fetch mini-parser package to `build.zig.zon`:
```sh
zig fetch --save git+https://github.com/Operachi061/mini-parser
```

Then add following to `build.zig`:
```zig
const mini_parser = b.dependency("mini_parser", .{});
exe.root_module.addImport("mini-parser", mini_parser.module("mini-parser"));
```

After building, test it via:
```sh
./example --bool --text foo -h
```

## Unlicense
This project is based on the [UNLICENSE](https://github.com/Operachi061/mini-parser/blob/main/UNLICENSE).
