//
// A veces necesitas crear un identificador que, por la razón que sea,
// no cumple con las reglas de nomenclatura:
//
//     const 55_cows: i32 = 55; // ILEGAL: comienza con un número
//     const isn't true: bool = false; // ILEGAL: ¿qué es esto?!
//
// Si intentas crear cualquiera de estos en circunstancias normales,
// un equipo especial de seguridad de sintaxis de identificadores de programas
// (PISST, por sus siglas en inglés) vendrá a tu casa y te llevará.
//
// Afortunadamente, Zig tiene una forma de pasar estos identificadores locos
// a las autoridades: la sintaxis de citación de identificadores @"".
//
//     @"foo"
//
// Por favor, ayúdanos a introducir de manera segura estos identificadores fugitivos en
// nuestro programa:
//
const print = @import("std").debug.print;

pub fn main() void {
    const @"55_cows": i32 = 55;
    const @"isn't true": bool = false;

    print("Sweet freedom: {}, {}.\n", .{
        @"55_cows",
        @"isn't true",
    });
}
