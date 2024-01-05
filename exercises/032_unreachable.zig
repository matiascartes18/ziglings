//
// Zig tiene una declaración "unreachable". Úsala cuando quieras decirle al
// compilador que una rama de código nunca debería ser ejecutada y que el
// simple hecho de llegar a ella es un error.
//
//     if (true) {
//         ...
//     } else {
//         unreachable;
//     }
//
// Aquí hemos hecho una pequeña máquina virtual que realiza operaciones matemáticas
// en un solo valor numérico. Parece genial pero hay un
// pequeño problema: la declaración switch no cubre todos los posibles
// valores de un número u8!
//
// NOSOTROS sabemos que solo hay tres operaciones pero Zig no. Usa la
// declaración "unreachable" para completar el switch. O de lo contrario. :-)
//
const std = @import("std");


pub fn main() void {
    const operations = [_]u8{ 1, 1, 1, 3, 2, 2 };

    var current_value: u32 = 0;

    for (operations) |op| {
        switch (op) {
            1 => {current_value += 1;},
            2 => current_value -= 1,    
            3 => current_value *= current_value,
            else => unreachable,
        }

        std.debug.print("{} ", .{current_value});
    }

    std.debug.print("\n", .{});
}
