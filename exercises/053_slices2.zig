//
// ¿Quizás te sientas tentado a probar slices en cadenas de texto? Después de todo, 
// son arrays de caracteres u8, ¿verdad? Los slices en cadenas de texto funcionan muy bien.
// Solo hay una trampa: no olvides que las literales de cadena en Zig son
// valores inmutables (const). Por lo tanto, necesitamos cambiar el tipo de slice
// de:
//
//     var foo: []u8 = "foobar"[0..3];
//
// a:
//
//     var foo: []const u8 = "foobar"[0..3];
//
// Ve si puedes arreglar este descodificador de frases inspirado en Zero Wing:
const std = @import("std");

pub fn main() void {
    const scrambled = "great base for all your justice are belong to us";

    const base1: []const u8 = scrambled[15..23];
    const base2: []const u8 = scrambled[6..10];
    const base3: []const u8 = scrambled[32..];
    printPhrase(base1, base2, base3);

    const justice1: []const u8 = scrambled[11..14];
    const justice2: []const u8 = scrambled[0..5];
    const justice3: []const u8 = scrambled[24..31];
    printPhrase(justice1, justice2, justice3);

    std.debug.print("\n", .{});
}

fn printPhrase(part1: []const u8, part2: []const u8, part3: []const u8) void {
    std.debug.print("'{s} {s} {s}.' ", .{ part1, part2, part3 });
}
