//
// La sintaxis de literal de estructura anónima también puede ser utilizada para componer una
// "lista anónima" con un destino de tipo array:
//
//     const foo: [3]u32 = .{10, 20, 30};
//
// De lo contrario, es una "tupla":
//
//     const bar = .{10, 20, 30};
//
// La única diferencia es el tipo de destino.
//
const print = @import("std").debug.print;

pub fn main() void {
    // Please make 'hello' a string-like array of u8 WITHOUT
    // changing the value literal.
    //
    // Don't change this part:
    //
    //     = .{ 'h', 'e', 'l', 'l', 'o' };
    //
    const hello: [5]u8 = .{ 'h', 'e', 'l', 'l', 'o' };
    print("I say {s}!\n", .{hello});
}
