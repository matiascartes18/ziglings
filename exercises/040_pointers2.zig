//
// Es importante tener en cuenta que los punteros a variables y los punteros a constantes
// son tipos diferentes.
//
// Dado:
//
//     var foo: u8 = 5;
//     const bar: u8 = 5;
//
// Entonces:
//
//     &foo es de tipo "*u8"
//     &bar es de tipo "*const u8"
//
// Siempre puedes hacer un puntero constante a un valor mutable (var), pero
// no puedes hacer un puntero variable a un valor inmutable (const).
// Esto suena como un acertijo lógico, pero simplemente significa que una vez que los datos
// se declaran inmutables, no puedes convertirlos a un tipo mutable.
// Piensa en los datos mutables como volátiles o incluso peligrosos. Zig
// siempre te permite ser "más seguro" y nunca "menos seguro".
//
const std = @import("std");

pub fn main() void {
    const a: u8 = 12;
    const b: *const u8 = &a; // fix this!

    std.debug.print("a: {}, b: {}\n", .{ a, b.* });
}
