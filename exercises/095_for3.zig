//
// El lenguaje Zig está en rápido desarrollo y mejora continuamente
// los constructos del lenguaje. Ziglings evoluciona con él.
//
// Hasta la versión 0.11, los bucles 'for' de Zig no replicaban directamente
// la funcionalidad del estilo C: "for(a;b;c)"
// que son tan adecuados para iterar sobre una secuencia numérica.
//
// En su lugar, los bucles 'while' con contadores se usaban de manera torpe:
//
//     var i: usize = 0;
//     while (i < 10) : (i += 1) {
//         // Aquí la variable 'i' tendrá cada valor de 0 a 9.
//     }
//
// Pero aquí estamos en el glorioso futuro y los bucles 'for' de Zig
// ahora pueden tomar esta forma:
//
//     for (0..10) |i| {
//         // Aquí la variable 'i' tendrá cada valor de 0 a 9.
//     }
//
// La clave para entender este ejemplo es saber que '0..9'
// utiliza la nueva sintaxis de rango:
//
//     0..10 es un rango de 0 a 9
//     1..4  es un rango de 1 a 3
//
// Por el momento, los rangos solo son compatibles con los bucles 'for'.
//
// ¿Quizás recuerdas el Ejercicio 13? Estábamos imprimiendo una secuencia numérica así:
//
//     var n: u32 = 1;
//
//     // Quiero imprimir cada número entre 1 y 20 que NO sea
//     // divisible por 3 o 5.
//     while (n <= 20) : (n += 1) {
//         // El símbolo '%' es el operador "módulo" y devuelve
//         // el resto después de la división.
//         if (n % 3 == 0) continue;
//         if (n % 5 == 0) continue;
//         std.debug.print("{} ", .{n});
//     }
//
//  Probemos la nueva forma de 'for' para reimplementar ese
//  ejercicio:
//
const std = @import("std");

pub fn main() void {

    // I want to print every number between 1 and 20 that is NOT
    // divisible by 3 or 5.
    const l = 21;
    for (1..l) |n| {

        // The '%' symbol is the "modulo" operator and it
        // returns the remainder after division.
        if (n % 3 == 0) continue;
        if (n % 5 == 0) continue;
        std.debug.print("{} ", .{n});
    }

    std.debug.print("\n", .{});
}
//
// Eso es un poco más agradable, ¿verdad?
//
// Por supuesto, tanto 'while' como 'for' tienen diferentes ventajas.
// Los ejercicios 11, 12 y 14 NO se simplificarían al cambiar
// un 'while' por un 'for'.
