//
// Ahora vamos a usar punteros para hacer algo que no hemos podido hacer antes: pasar un valor por referencia a una función.
//
// ¿Por qué querríamos pasar un puntero a una variable entera en lugar del valor entero en sí? ¡Porque entonces podemos *cambiar* el valor de la variable!
//
//     +-----------------------------------------------+
//     | Pasa por referencia cuando quieras cambiar el  |
//     | valor apuntado. De lo contrario, pasa el valor.|
//     +-----------------------------------------------+
//
const std = @import("std");

pub fn main() void {
    var num: u8 = 1;
    var more_nums = [_]u8{ 1, 1, 1, 1 };

    // Let's pass the num reference to our function and print it:
    makeFive(&num);
    std.debug.print("num: {}, ", .{num});

    // Now something interesting. Let's pass a reference to a
    // specific array value:
    makeFive(&more_nums[2]);

    // And print the array:
    std.debug.print("more_nums: ", .{});
    for (more_nums) |n| {
        std.debug.print("{} ", .{n});
    }

    std.debug.print("\n", .{});
}

// This function should take a reference to a u8 value and set it
// to 5.
fn makeFive(x: *u8) void {
    x.* = 5; // fix me!
}
