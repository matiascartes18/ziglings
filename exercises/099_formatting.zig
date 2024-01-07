//
// Las terminales han recorrido un largo camino a lo largo de los años. Comenzando con
// líneas monocromáticas en monitores CRT parpadeantes y mejorando continuamente
// hasta los emuladores de terminal modernos de hoy con imágenes nítidas,
// colores verdaderos, fuentes, ligaduras y caracteres en todos los
// idiomas conocidos.
//
// Formatear nuestros resultados para que sean atractivos y permitan una rápida comprensión visual
// de la información es lo que desean los usuarios. <3
//
// C estableció los estándares de formateo de cadenas a lo largo de los años, y Zig está
// siguiendo su ejemplo y creciendo diariamente. Debido a este crecimiento, no hay
// documentación oficial para características de la biblioteca estándar como
// el formateo de cadenas.
//
// Por lo tanto, los comentarios para la función format() son la única
// forma de aprender definitivamente cómo formatear cadenas en Zig:
//
//     https://github.com/ziglang/zig/blob/master/lib/std/fmt.zig#L29
//
// Zig ya tiene una muy buena selección de opciones de formateo.
// Estas se pueden usar de diferentes maneras, pero típicamente para convertir
// valores numéricos en varias representaciones de texto. Los
// resultados se pueden usar para una salida directa a una terminal o almacenados
// para su uso posterior o escritos en un archivo. Este último es útil cuando
// grandes cantidades de datos deben ser procesados por otros programas.
//
// En Ziglings, nos preocupamos por la salida a la consola.
// Pero dado que las instrucciones de formateo para archivos son las mismas,
// lo que aprendes se aplica universalmente.
//
// Dado que escribimos en la salida "debug" en Ziglings, nuestras respuestas
// suelen verse algo así:
//
//      print("Texto {placeholder} otro texto \n", .{foo});
//
// Además de ser reemplazado con foo en este ejemplo, el
// {placeholder} en la cadena también puede tener formateo aplicado.
// ¿Cómo funciona eso?
//
// Esto sucede en varias etapas. En una etapa, se evalúan las secuencias de escape.
// La que hemos visto más (incluyendo el ejemplo anterior) es "\n" que significa "salto de línea".
// Siempre que se encuentra esta declaración, se inicia una nueva línea en la
// salida. Las secuencias de escape también se pueden escribir una tras otra, por ejemplo, "\n\n" provocará dos saltos de línea.
//
// Por cierto, el resultado de estas secuencias de escape se pasa
// directamente al programa de terminal. Aparte de traducirlas
// en códigos de control, las secuencias de escape no tienen nada que ver con
// Zig. Zig no sabe nada sobre "saltos de línea" o "tabs" o
// "campanas".
//
// El formateo que Zig *sí* realiza por sí mismo se encuentra en los
// corchetes rizados: "{placeholder}". Las instrucciones de formateo en
// el marcador de posición determinarán cómo se muestra el valor correspondiente,
// por ejemplo, foo.
//
// Y aquí es donde se pone emocionante, porque format() acepta una
// variedad de instrucciones de formateo. Es básicamente un pequeño
// lenguaje por sí mismo. Aquí tienes un ejemplo numérico:
//
//     print("Catch-{x:0>4}.", .{veintidos});
//
// Esta instrucción de formateo muestra un número hexadecimal con
// ceros a la izquierda:
//
//     Catch-0x0016.
//
// O puedes centrar una cadena de esta manera:
//
//     print("{s:*^20}\n", .{"¡Hola!"});
//
// Salida:
//
//     *******¡Hola!*******
//
// Intentemos hacer uso de algún formateo. Hemos decidido que
// lo único que falta en nuestras vidas es una tabla de multiplicar
// para todos los números del 1 al 15. Queremos que la tabla sea bonita y
// ordenada, con números en columnas rectas como así:
//
//      X |  1   2   3   4   5  ...
//     ---+---+---+---+---+---+
//      1 |  1   2   3   4   5
//
//      2 |  2   4   6   8  10
//
//      3 |  3   6   9  12  15
//
//      4 |  4   8  12  16  20
//
//      5 |  5  10  15  20  25
//
//      ...
//
// Sin el formateo de cadenas, esto sería una tarea más desafiante
// porque el número de dígitos en los números varía
// de 1 a 3. Pero el formateo puede ayudarnos con eso.
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // Max number to multiply
    const size = 15;

    // Print the header:
    //
    // We start with a single 'X' for the diagonal.
    print("\n X |", .{});

    // Header row with all numbers from 1 to size.
    for (0..size) |n| {
        print("{d:>3} ", .{n + 1});
    }
    print("\n", .{});

    // Header column rule line.
    var n: u8 = 0;
    while (n <= size) : (n += 1) {
        print("---+", .{});
    }
    print("\n", .{});

    // Now the actual table. (Is there anything more beautiful
    // than a well-formatted table?)
    for (0..size) |a| {
        print("{d:>2} |", .{a + 1});

        for (0..size) |b| {
            // What formatting is needed here to make our columns
            // nice and straight?
            print("{d:>3} ", .{(a + 1) * (b + 1)});
        }

        // After each row we use double line feed:
        print("\n\n", .{});
    }
}
