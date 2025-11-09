const std = @import("std");
const json5 = @import("json5");

test "empty array" {
    const input = "[]";

    var scanner: json5.Scanner = .initCompleteInput(
        std.testing.allocator,
        input,
    );
    defer scanner.deinit();

    const begin = try scanner.next();
    try std.testing.expectEqual(json5.Token.array_begin, begin);
    const end = try scanner.next();
    try std.testing.expectEqual(json5.Token.array_end, end);

    try std.testing.expect(scanner.is_end_of_input);
}

test "trailing comma array" {
    const input =
        \\[
        \\    null,
        \\]
    ;
    var scanner: json5.Scanner = .initCompleteInput(
        std.testing.allocator,
        input,
    );
    defer scanner.deinit();

    const begin = try scanner.next();
    try std.testing.expectEqual(json5.Token.array_begin, begin);
    const null_val = try scanner.next();
    try std.testing.expectEqual(json5.Token.null, null_val);
    const end = try scanner.next();
    try std.testing.expectEqual(json5.Token.array_end, end);

    try std.testing.expect(scanner.is_end_of_input);
}
