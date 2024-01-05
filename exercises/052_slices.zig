//
// Hemos visto que pasar matrices puede ser incómodo. ¿Quizás recuerdas una definición de función particularmente horrenda del quiz3?
// ¡Esta función solo puede tomar matrices que tengan exactamente 4 elementos!
//
//     fn printPowersOfTwo(numbers: [4]u16) void { ... }
//
// Ese es el problema con las matrices: su tamaño es parte del tipo de datos y debe codificarse en cada uso de ese tipo. Esta matriz de dígitos es [10]u8 para siempre y siempre:
//
//     var digits = [10]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
//
// Afortunadamente, Zig tiene slices, que te permiten apuntar dinámicamente a un elemento de inicio y proporcionar una longitud. Aquí tienes slices de nuestra matriz de dígitos:
//
//     const foo = digits[0..1];  // 0
//     const bar = digits[3..9];  // 3 4 5 6 7 8
//     const baz = digits[5..9];  // 5 6 7 8
//     const all = digits[0..];   // 0 1 2 3 4 5 6 7 8 9
//
// Como puedes ver, un slice [x..y] comienza con el índice del primer elemento en x y el último elemento en y-1. Puedes omitir el y para obtener "el resto de los elementos".
//
// The type of a slice on an array of u8 items is []u8.
//
const std = @import("std");

pub fn main() void {
    var cards = [8]u8{ 'A', '4', 'K', '8', '5', '2', 'Q', 'J' };

    // Please put the first 4 cards in hand1 and the rest in hand2.
    const hand1: []u8 = cards[0..4];
    const hand2: []u8 = cards[4..];

    std.debug.print("Hand1: ", .{});
    printHand(hand1);

    std.debug.print("Hand2: ", .{});
    printHand(hand2);
}

// Please lend this function a hand. A u8 slice hand, that is.
fn printHand(hand: []u8) void {
    for (hand) |h| {
        std.debug.print("{u} ", .{h});
    }
    std.debug.print("\n", .{});
}
//
// Fun fact: Under the hood, slices are stored as a pointer to
// the first item and a length.
