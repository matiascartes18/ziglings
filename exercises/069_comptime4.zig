//
// Uno de los usos más comunes de los parámetros de función 'comptime' es
// pasar un tipo a una función:
//
//     fn foo(comptime MyType: type) void { ... }
//
// De hecho, los tipos solo están disponibles en tiempo de compilación, por lo que
// la palabra clave 'comptime' es necesaria aquí.
//
// Por favor, tómate un momento para ponerte el sombrero de mago que se te ha
// proporcionado. Estamos a punto de usar esta habilidad para implementar
// una función genérica.
//
const print = @import("std").debug.print;

pub fn main() void {
    // Here we declare arrays of three different types and sizes
    // at compile time from a function call. Neat!
    const s1 = makeSequence(u8, 3); // creates a [3]u8
    const s2 = makeSequence(u32, 5); // creates a [5]u32
    const s3 = makeSequence(i64, 7); // creates a [7]i64

    print("s1={any}, s2={any}, s3={any}\n", .{ s1, s2, s3 });
}

// Esta función es bastante salvaje porque se ejecuta en tiempo de ejecución
// y es parte del programa final compilado. La función se
// compila con tamaños y tipos de datos inmutables.
//
// Y sin embargo, TAMBIÉN permite diferentes tamaños y tipos. Esto
// parece paradójico. ¿Cómo podrían ambas cosas ser ciertas?
//
// Para lograr esto, el compilador Zig en realidad genera una
// copia separada de la función para cada combinación de tamaño/tipo!
// Así que en este caso, se generarán tres funciones diferentes
// para ti, cada una con código de máquina que maneja ese específico
// tamaño y tipo de datos.
//
// Por favor, corrige esta función para que el parámetro 'size':
//
//     1) Esté garantizado que se conozca en tiempo de compilación.
//     2) Establezca el tamaño del array de tipo T (que es la
//        secuencia que estamos creando y devolviendo).
//
fn makeSequence(comptime T: type, comptime size: usize) [size]T {
    var sequence: [size]T = undefined;
    var i: usize = 0;

    while (i < size) : (i += 1) {
        sequence[i] = @as(T, @intCast(i)) + 1;
    }

    return sequence;
}
