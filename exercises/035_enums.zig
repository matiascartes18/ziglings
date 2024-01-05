//
// Recuerda esa pequeña máquina virtual matemática que hicimos usando la
// declaración "unreachable"? Bueno, había dos problemas con la forma en que
// estábamos usando los códigos de operación:
//
//   1. Tener que recordar los códigos de operación por número no es bueno.
//   2. Teníamos que usar "unreachable" porque Zig no tenía forma de saber
//      cuántos códigos de operación válidos había.
//
// Un "enum" es una construcción de Zig que te permite dar nombres a valores
// numéricos y almacenarlos en un conjunto. Se parecen mucho a los conjuntos
// de errores:
//
//     const Fruit = enum{ apple, pear, orange };
//
//     const my_fruit = Fruit.apple;
//
// ¡Vamos a usar un enum en lugar de los números que estábamos usando en la
// versión anterior!
//
const std = @import("std");

// Please complete the enum!
const Ops = enum { inc, dec, pow };

pub fn main() void {
    const operations = [_]Ops{
        Ops.inc,
        Ops.inc,
        Ops.inc,
        Ops.pow,
        Ops.dec,
        Ops.dec,
    };

    var current_value: u32 = 0;

    for (operations) |op| {
        switch (op) {
            Ops.inc => {
                current_value += 1;
            },
            Ops.dec => {
                current_value -= 1;
            },
            Ops.pow => {
                current_value *= current_value;
            },
            // No "else" needed! Why is that?
        }

        std.debug.print("{} ", .{current_value});
    }

    std.debug.print("\n", .{});
}
