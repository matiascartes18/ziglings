//
// Hemos visto que Zig realiza implícitamente algunas evaluaciones en
// tiempo de compilación. Pero a veces querrás solicitar explícitamente
// la evaluación en tiempo de compilación. Para eso, tenemos una nueva palabra clave:
//
//  .     .   .      o       .          .       *  . .     .
//    .  *  |     .    .            .   .     .   .     * .    .
//        --o--            comptime        *    |      ..    .
//     *    |       *  .        .    .   .    --*--  .     *  .
//  .     .    .    .   . . .      .        .   |   .    .  .
//
// Cuando se coloca antes de una declaración de variable, 'comptime'
// garantiza que cada uso de esa variable se realizará
// en tiempo de compilación.
//
// Como un ejemplo simple, compara estas dos declaraciones:
//
//    var bar1 = 5;            // ¡ERROR!
//    comptime var bar2 = 5;   // ¡BIEN!
//
// La primera nos da un error porque Zig asume que los identificadores mutables
// (declarados con 'var') se utilizarán en tiempo de ejecución y
// no hemos asignado un tipo de tiempo de ejecución (como u8 o f32). Intentar
// usar un comptime_int de tamaño indeterminado en tiempo de ejecución es
// un CRIMEN DE MEMORIA y estás BAJO ARRESTO.
//
// La segunda está bien porque le hemos dicho a Zig que 'bar2' es
// una variable de tiempo de compilación. Zig nos ayudará a asegurar que esto sea cierto
// y nos informará si cometemos un error.//
const print = @import("std").debug.print;

pub fn main() void {
    //
    // In this contrived example, we've decided to allocate some
    // arrays using a variable count! But something's missing...
    //
    comptime var count = 0;

    count += 1;
    const a1: [count]u8 = .{'A'} ** count;

    count += 1;
    const a2: [count]u8 = .{'B'} ** count;

    count += 1;
    const a3: [count]u8 = .{'C'} ** count;

    count += 1;
    const a4: [count]u8 = .{'D'} ** count;

    print("{s} {s} {s} {s}\n", .{ a1, a2, a3, a4 });

    // ¡BONUS de funciones incorporadas!
    //
    // La función incorporada @compileLog() es como una instrucción print que
    // SOLO opera en tiempo de compilación. El compilador Zig trata
    // las llamadas a @compileLog() como errores, por lo que querrás usarlas
    // temporalmente para depurar la lógica en tiempo de compilación.
    //
    // Intenta descomentar esta línea y jugar con ella
    // (cópiala, muévela) para ver lo que hace:
    //@compileLog("Cuenta en tiempo de compilacion: ", count);
}
