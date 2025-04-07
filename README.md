# mini-parser
mini-parser is a very-minimal parser for [Zig](https://ziglang.org) language.

## Example
```zig
const std = @import("std");
const mini_parser = @import("mini_parser.zig");
const debug = std.debug;

const usage =
    \\Usage: 001-example <opts>
    \\
    \\Options:
    \\  --help  -h      Display help list
    \\  --text  -t      Print text
    \\  --bool  -b      Print boolean
    \\
;

pub fn main() !void {
    const argv = std.os.argv[0..];

    var i: usize = 0;
    while (argv.len > i) : (i += 1) {
        const parser = try mini_parser.init(argv[i], &.{
            .{ .name = "help", .short_name = 'h', .type = .boolean }, // 1
            .{ .name = "text", .short_name = 't', .type = .argument }, // 2
            .{ .name = "bool", .short_name = 'b', .type = .boolean }, // 3
        });

        switch (parser.argument) {
            0 => debug.print("no argument was given.\n", .{}),
            1 => debug.print("{s}\n", .{usage}), // 1
            2 => debug.print("Text: {s}\n", .{parser.value}), // 2
            3 => debug.print("Enabled boolean!\n", .{}), // 3
            4 => debug.print("argument '{s}' does not exist.\n", .{argv[i]}),
            else => {},
        }
    }
}
```

After building, test it via:
```bash
./example --help -b --text foo
```

## License
This project is based on the BSD 3-Clause license.
