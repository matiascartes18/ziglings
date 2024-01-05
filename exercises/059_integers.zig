//
// Zig te permite expresar literales enteros en varios formatos convenientes.
// Estos son todos el mismo valor:
//
//     const a1: u8 = 65;        // decimal
//     const a2: u8 = 0x41;      // hexadecimal
//     const a3: u8 = 0o101;     // octal
//     const a4: u8 = 0b1000001; // binario
//     const a5: u8 = 'A';       // literal de punto de código ASCII
//     const a6: u16 = 'Ȁ';      // los puntos de código Unicode pueden tener hasta 21 bits
//
// También puedes colocar guiones bajos en los números para facilitar la legibilidad:
//
//     const t1: u32 = 14_689_520 // ventas del Ford Model T 1909-1927
//     const t2: u32 = 0xE0_24_F0 // lo mismo, en pares hexadecimales
//
// Por favor, corrige el mensaje:

const print = @import("std").debug.print;

pub fn main() void {
    const zig = [_]u8{
        0o132, // octal
        0b1101001, // binary
        0x67, // hex
    };

    print("{s} is cool.\n", .{zig});
}
