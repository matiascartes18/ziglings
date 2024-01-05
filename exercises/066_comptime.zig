//
// "Tiempo de compilación" es el entorno de un programa mientras se está compilando. En contraste, "tiempo de ejecución" es el entorno mientras el programa compilado se está ejecutando (tradicionalmente como código de máquina en una CPU).
//
// Los errores son un ejemplo sencillo:
//
// 1. Error de tiempo de compilación: capturado por el compilador, generalmente resultando en un mensaje para el programador.
//
// 2. Error de tiempo de ejecución: capturado por el propio programa en ejecución o por el hardware o sistema operativo anfitrión. Puede ser capturado y manejado de manera adecuada o puede hacer que la computadora se bloquee (¡o se incendie!).
//
// Todos los lenguajes compilados deben realizar cierta cantidad de lógica en tiempo de compilación para analizar el código, mantener una tabla de símbolos (como nombres de variables y funciones), etc.
//
// Los compiladores optimizadores también pueden determinar cuánto de un programa se puede precomputar o "incluir" en tiempo de compilación para hacer que el programa resultante sea más eficiente. Los compiladores inteligentes incluso pueden "desenrollar" bucles, convirtiendo su lógica en una secuencia lineal rápida de declaraciones (a costa del aumento del tamaño del código repetido).
//
// ¡Zig lleva estos conceptos más allá al hacer que estas optimizaciones sean parte integral del propio lenguaje!
//
const print = @import("std").debug.print;

pub fn main() void {
    // TODOS los literales numéricos en Zig son de tipo comptime_int o
    // comptime_float. Son de tamaño arbitrario (tan grandes o
    // pequeños como necesites).
    //
    // Observa cómo no tenemos que especificar un tamaño como "u8",
    // "i32", o "f64" cuando asignamos identificadores de manera inmutable con
    // "const".
    //
    // Cuando usamos estos identificadores en nuestro programa, los VALORES
    // se insertan en tiempo de compilación en el código ejecutable. Los
    // IDENTIFICADORES "const_int" y "const_float" no existen en
    // nuestra aplicación compilada!
    const const_int = 12345;
    const const_float = 987.654;

    print("Immutable: {}, {d:.3}; ", .{ const_int, const_float });

    // Pero algo cambia cuando asignamos los mismos valores exactos
    // a identificadores de manera mutable con "var".
    //
    // Los literales SIGUEN siendo comptime_int y comptime_float,
    // pero deseamos asignarlos a identificadores que son
    // mutables en tiempo de ejecución.
    //
    // Para ser mutable en tiempo de ejecución, estos identificadores deben referirse a
    // áreas de memoria. Para referirse a áreas de memoria, Zig
    // debe saber exactamente cuánta memoria reservar para estos
    // valores. Por lo tanto, se deduce que debemos especificar tipos numéricos
    // con tamaños específicos. Los números comptime serán
    // forzados (¡si caben!) en tus tipos de tiempo de ejecución elegidos.
    // Para esto es necesario especificar un tamaño, por ejemplo, 32 bits.
    var var_int: u32 = 12345;
    var var_float: f32 = 987.654;

    // We can change what is stored at the areas set aside for
    // "var_int" and "var_float" in the running compiled program.
    var_int = 54321;
    var_float = 456.789;

    print("Mutable: {}, {d:.3}; ", .{ var_int, var_float });

    // Bonus: Ahora que estamos familiarizados con las funciones incorporadas de Zig, podemos
    // también inspeccionar los tipos para ver qué son, no es necesario adivinar!
    print("Types: {}, {}, {}, {}\n", .{
        @TypeOf(const_int),
        @TypeOf(const_float),
        @TypeOf(var_int),
        @TypeOf(var_float),
    });
}
