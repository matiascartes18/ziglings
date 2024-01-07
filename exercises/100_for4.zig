//
// Hemos visto que el bucle 'for' nos permite realizar alguna acción
// para cada elemento en un array o slice.
//
// Más recientemente, descubrimos que soporta rangos para
// iterar sobre secuencias de números.
//
// Esto es parte de una capacidad más general del bucle `for`:
// iterar sobre uno o más "objetos" donde un objeto es un
// array, slice, o rango.
//
// De hecho, *usamos* múltiples objetos hace mucho tiempo en el Ejercicio
// 016 donde iteramos sobre un array y también un índice numérico.
// No siempre funcionó exactamente de esta manera, por lo que el ejercicio tuvo que
// ser modificada retroactivamente un poco.
//
//     for (bits, 0..) |bit, i| { ... }
//
// La forma general de un bucle 'for' con dos listas es:
//
//     for (list_a, list_b) |a, b| {
//         // Aquí tenemos el primer elemento de list_a y list_b,
//         // luego el segundo elemento de cada uno, luego el tercero y
//         // así sucesivamente...
//     }
//
// Lo realmente hermoso de esto es que no tenemos que
// llevar la cuenta de un índice o avanzar un puntero de memoria para
// *ninguna* de estas listas. Ese trabajo propenso a errores es todo realizado
// por nosotros por el compilador.
//
// A continuación, tenemos un programa que se supone que compara dos
// arrays. ¡Por favor, haz que funcione!//
const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const hex_nums = [_]u8{ 0xb, 0x2a, 0x77 };
    const dec_nums = [_]u8{ 11, 42, 119 };

    for (hex_nums, dec_nums) |hn, dn| {
        if (hn != dn) {
            std.debug.print("Uh oh! Found a mismatch: {d} vs {d}\n", .{ hn, dn });
            break;
        }
    } else std.debug.print("Arrays match!\n", .{});
}
//
// Quizás te estés preguntando qué sucede si una de las dos listas
// es más larga que la otra. ¡Pruébalo!
//
// Por cierto, ¡felicidades por llegar al Ejercicio 100!
//
//    +-------------+
//    | Área de     |
//    | Celebración * * * |
//    +-------------+
//
// Por favor, mantén tu celebración dentro del área proporcionada.
