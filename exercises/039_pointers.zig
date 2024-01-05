//
// Mira esto:
//
//     var foo: u8 = 5;      // foo es 5
//     var bar: *u8 = &foo;  // bar es un puntero
//
// ¿Qué es un puntero? Es una referencia a un valor. En este ejemplo,
// bar es una referencia al espacio de memoria que actualmente contiene
// el valor 5.
//
// Una hoja de trucos dada las declaraciones anteriores:
//
//     u8         el tipo de un valor u8
//     foo        el valor 5
//     *u8        el tipo de un puntero a un valor u8
//     &foo       una referencia a foo
//     bar        un puntero al valor en foo
//     bar.*      el valor 5 (el valor desreferenciado "en" bar)
//
// Veremos por qué los punteros son útiles en un momento. ¡Por ahora,
// intenta hacer que este ejemplo funcione!
//
const std = @import("std");

pub fn main() void {
    var num1: u8 = 5;
    const num1_pointer: *u8 = &num1;

    var num2: u8 = undefined;

    // Please make num2 equal 5 using num1_pointer!
    // (See the "cheatsheet" above for ideas.)
    num2 = num1_pointer.*;

    std.debug.print("num1: {}, num2: {}\n", .{ num1, num2 });
}
