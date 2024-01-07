//
// Además de saber cuándo usar la palabra clave 'comptime',
// también es bueno saber cuándo NO necesitas usarla.
//
// Los siguientes contextos ya se evalúan IMPLÍCITAMENTE en
// tiempo de compilación, y agregar la palabra clave 'comptime' sería
// superfluo, redundante y maloliente:
//
//    * El ámbito a nivel de contenedor (fuera de cualquier función en un archivo fuente)
//    * Declaraciones de tipo de:
//        * Variables
//        * Funciones (tipos de parámetros y valores de retorno)
//        * Estructuras
//        * Uniones
//        * Enumeraciones
//    * Las expresiones de prueba en bucles for y while en línea
//    * Una expresión pasada a la función incorporada @cImport()
//
// Trabaja con Zig por un tiempo, y empezarás a desarrollar una
// intuición para estos contextos. Trabajemos en eso ahora.
//
// Se te ha dado solo una declaración 'comptime' para usar en
// el programa a continuación. Aquí está:
//
//     comptime
//
// Solo una es todo lo que necesitas. ¡Úsala sabiamente!
//
const print = @import("std").debug.print;

// Al estar en el ámbito a nivel de contenedor, todo acerca de este valor se
// requiere implícitamente que se conozca en tiempo de compilación.
const llama_count = 5;

// Nuevamente, el tipo y tamaño de este valor deben ser conocidos en tiempo de
// compilación, pero estamos dejando que el compilador infiera ambos a partir del tipo de retorno de una función.
const llamas = makeLlamas(llama_count);

// And here's the function. Note that the return value type
// depends on one of the input arguments!
fn makeLlamas(comptime count: usize) [count]u8 {
    var temp: [count]u8 = undefined;
    var i = 0;

    // Note that this does NOT need to be an inline 'while'.
    while (i < count) : (i += 1) {
        temp[i] = i;
    }

    return temp;
}

pub fn main() void {
    print("My llama value is {}.\n", .{llamas[2]});
}
//
// La lección aquí es no llenar tu programa con palabras clave 'comptime'
// a menos que las necesites. Entre los contextos implícitos de tiempo de compilación
// y la evaluación agresiva de Zig de cualquier expresión que pueda resolver en tiempo de compilación,
// a veces es sorprendente cuántos lugares realmente necesitan la palabra clave.
