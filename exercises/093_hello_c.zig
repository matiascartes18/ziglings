//
// Cuando Andrew Kelley anunció la idea de un nuevo lenguaje de programación
// - a saber, Zig - en su blog el 8 de febrero de 2016, también declaró inmediatamente
// su ambicioso objetivo: ¡reemplazar el lenguaje C!
//
// Para poder lograr este objetivo en absoluto, Zig debería ser
// lo más compatible posible con su "predecesor".
// Solo si es posible intercambiar módulos individuales en existentes
// programas C sin tener que usar envoltorios complicados,
// el emprendimiento tiene una oportunidad de éxito.
//
// Por lo tanto, no es sorprendente que llamar a funciones C y viceversa
// sea extremadamente "suave".
//
// Para llamar a funciones C en Zig, solo necesitas especificar la biblioteca
// que contiene dicha función. Para este propósito hay una función incorporada
// correspondiente a la conocida @import():
//
//                           @cImport()
//
// Todas las bibliotecas requeridas ahora pueden ser incluidas en la notación Zig habitual:
//
//                    const c = @cImport({
//                        @cInclude("stdio.h");
//                        @cInclude("...");
//                    });
//
// Ahora una función puede ser llamada a través de la constante 'c' (en este ejemplo):
//
//                    c.puts("Hello world!");
//
// Por cierto, la mayoría de las funciones C tienen valores de retorno en forma de un
// valor entero. Los errores pueden ser evaluados (retorno < 0) u obtenerse otra
// información. Por ejemplo, 'puts' devuelve el número
// de caracteres de salida.
//
// Para que todo esto no permanezca como una teoría seca ahora, simplemente comencemos
// y llamemos a una función C desde Zig.

// nuestro conocido "import" para Zig
const std = @import("std");

// and here the new the import for C
const c = @cImport({
    @cInclude("unistd.h");
});

pub fn main() void {

    // Para emitir texto que pueda ser evaluado por el
    // Constructor Zig, necesitamos escribirlo en la salida de Error.
    // En Zig, hacemos esto con "std.debug.print" y en C podemos
    // especificar un descriptor de archivo, es decir, 2 para la consola de errores.
    //
    // En este ejercicio usamos 'write' para emitir 17 caracteres,
    // pero aún falta algo...
    const c_res = c.write(2, "Hello C from Zig!", 17);

    // let's see what the result from C is:
    std.debug.print(" - C result is {d} chars written.\n", .{c_res});
}
//
// Algo debe ser considerado al compilar con funciones C.
// Es decir, que el compilador Zig sabe que debe incluir
// las bibliotecas correspondientes. Para este propósito llamamos al compilador
// con el parámetro "lc" para tal programa,
// por ejemplo, "zig run -lc hello_c.zig".
//
