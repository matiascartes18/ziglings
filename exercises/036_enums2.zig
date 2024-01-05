//
// Los enums son simplemente un conjunto de números. Puedes dejar que el compilador se encargue de asignarles números, o puedes asignarlos explícitamente. Incluso puedes especificar el tipo numérico utilizado.
//
//     const Stuff = enum(u8){ foo = 16 };
//
// Puedes obtener el entero con una función incorporada, @intFromEnum(). Aprenderemos sobre las funciones incorporadas correctamente en un ejercicio posterior.
//
//     const my_stuff: u8 = @intFromEnum(Stuff.foo);
//
// Observa cómo esa función incorporada comienza con "@" al igual que la función @import() que hemos estado utilizando.
//
const std = @import("std");

// Zig nos permite escribir enteros en formato hexadecimal:
//
//     0xf (es el valor 15 en hexadecimal)
//
// Los navegadores web nos permiten especificar colores usando un número hexadecimal donde cada byte representa el brillo de los componentes Rojo, Verde o Azul (RGB), donde dos dígitos hexadecimales son un byte con un rango de valores de 0 a 255:
//
//     #RRGGBB
//
// Por favor, define y utiliza un valor de color azul puro:
const Color = enum(u32) {
    red = 0xff0000,
    green = 0x00ff00,
    blue = 0x0000ff,
};

pub fn main() void {
    // Remember Zig's multi-line strings? Here they are again.
    // Also, check out this cool format string:
    //
    //     {x:0>6}
    //      ^
    //      x       type ('x' is lower-case hexadecimal)
    //       :      separator (needed for format syntax)
    //        0     padding character (default is ' ')
    //         >    alignment ('>' aligns right)
    //          6   width (use padding to force width)
    //
    // Please add this formatting to the blue value.
    // (Even better, experiment without it, or try parts of it
    // to see what prints!)
    std.debug.print(
        \\<p>
        \\  <span style="color: #{x:0>6}">Red</span>
        \\  <span style="color: #{x:0>6}">Green</span>
        \\  <span style="color: #{x:0>6}">Blue</span>
        \\</p>
        \\
    , .{
        @intFromEnum(Color.red),
        @intFromEnum(Color.green),
        @intFromEnum(Color.blue), // Oops! We're missing something!
    });
}
