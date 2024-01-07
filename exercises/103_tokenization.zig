//
// La funcionalidad de la biblioteca estándar se está volviendo cada vez más
// importante en Zig. Por un lado, es útil observar cómo
// se implementan las funciones individuales. Porque esto es maravillosamente
// adecuado como una plantilla para tus propias funciones. Por otro lado,
// estas funciones estándar son parte del equipamiento básico de Zig.
//
// Esto significa que siempre están disponibles en cada sistema.
// Por lo tanto, vale la pena tratar con ellas también en Ziglings.
// Es una excelente manera de aprender habilidades importantes. Por ejemplo, es
// a menudo necesario procesar grandes cantidades de datos de archivos.
// Y para esta lectura y procesamiento secuencial, Zig proporciona algunas
// funciones útiles, que examinaremos más de cerca en los próximos
// ejercicios.
//
// Un buen ejemplo de esto ha sido publicado en la página de inicio de Zig,
// reemplazando el algo polvoriento '¡Hola mundo!
//
// Nada en contra de '¡Hola mundo!', pero simplemente no hace justicia
// a la elegancia de Zig y eso es una lástima, si alguien echa un vistazo corto,
// por primera vez en la página de inicio y no se queda 'encantado'. Y para eso
// el presente ejemplo es simplemente más adecuado y por lo tanto lo utilizaremos
// como una introducción a la tokenización, porque es maravillosamente
// adecuado para entender los principios básicos.
//
// En los siguientes ejercicios también leeremos y procesaremos datos de
// archivos grandes y a más tardar entonces será claro para todos cuán
// útil es todo esto.
//
// Comencemos con el análisis del ejemplo de la página de inicio de Zig
// y expliquemos las cosas más importantes.
//
//    const std = @import("std");
//
//    // Aquí se define una función de la biblioteca estándar,
//    // que transfiere números de una cadena a los respectivos
//    // valores enteros.
//    const parseInt = std.fmt.parseInt;
//
//    // Definiendo un caso de prueba
//    test "parse integers" {
//
//        // Se pasan cuatro números en una cadena.
//        // Por favor, ten en cuenta que los valores individuales están separados
//        // ya sea por un espacio o una coma.
//        const input = "123 67 89,99";
//
//        // Para poder procesar los valores de entrada,
//        // se requiere memoria. Aquí se define un asignador para
//        // este propósito.
//        const ally = std.testing.allocator;
//
//        // El asignador se utiliza para inicializar un array en el que
//        // se almacenan los números.
//        var list = std.ArrayList(u32).init(ally);
//
//        // De esta manera nunca puedes olvidar lo que es urgentemente necesario
//        // y el compilador tampoco se queja.
//        defer list.deinit();
//
//        // Ahora se pone emocionante:
//        // Se llama a un tokenizador estándar (Zig tiene varios) y
//        // se utiliza para localizar las posiciones de los respectivos separadores
//        // (recordamos, espacio y coma) y pasarlos a un iterador.
//        var it = std.mem.tokenizeAny(u8, input, " ,");
//
//        // El iterador ahora puede ser procesado en un bucle y los
//        // números individuales pueden ser transferidos.
//        while (it.next()) |num| {
//            // Pero ten cuidado: Los números todavía sólo están disponibles
//            // como cadenas. Aquí es donde entra en juego el analizador de enteros,
//            // convirtiéndolos en valores enteros reales.
//            const n = try parseInt(u32, num, 10);
//
//            // Finalmente los valores individuales se almacenan en el array.
//            try list.append(n);
//        }
//
//        // Para la prueba subsiguiente, se crea un segundo array estático,
//        // que se llena directamente con los valores esperados.
//        const expected = [_]u32{ 123, 67, 89, 99 };
//
//        // Ahora los números convertidos de la cadena pueden ser comparados
//        // con los esperados, de modo que la prueba se completa
//        // con éxito.
//        for (expected, list.items) |exp, actual| {
//            try std.testing.expectEqual(exp, actual);
//        }
//    }
//
// Hasta aquí el ejemplo de la página de inicio.
// Resumamos de nuevo los pasos básicos:
//
// - Tenemos un conjunto de datos en orden secuencial, separados entre sí
//   por medio de varios caracteres.
//
// - Para su posterior procesamiento, por ejemplo en un array, estos datos deben ser
//   leídos, separados y, si es necesario, convertidos al formato objetivo.
//
// - Necesitamos un buffer que sea lo suficientemente grande para contener los datos.
//
// - Este buffer puede ser creado ya sea estáticamente en tiempo de compilación, si la
//   cantidad de datos ya se conoce, o dinámicamente en tiempo de ejecución utilizando
//   un asignador de memoria.
//
// - Los datos se dividen mediante Tokenizer en los respectivos
//   separadores y se almacenan en la memoria reservada. Esto generalmente también
//   incluye la conversión al formato objetivo.
//
// - Ahora los datos pueden ser procesados convenientemente en el formato correcto.
//
// Estos pasos son básicamente siempre los mismos.
// Ya sea que los datos se lean de un archivo o se introduzcan por el usuario a través del
// teclado, por ejemplo, es irrelevante. Sólo se distinguen las sutilezas
// y por eso Zig tiene diferentes tokenizadores. Pero más sobre esto en
// ejercicios posteriores.
//
// Ahora también queremos escribir un pequeño programa para tokenizar algunos datos,
// después de todo necesitamos algo de práctica. Supongamos que queremos contar las palabras
// de este pequeño poema:
//
// 	Mi nombre es Ozymandias, Rey de Reyes;
// 	Mira mis Obras, oh Poderoso, y desespera!
// 	 por Percy Bysshe Shelley//
//
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {

    // our input
    const poem =
        \\My name is Ozymandias, King of Kings;
        \\Look on my Works, ye Mighty, and despair!
    ;

    // now the tokenizer, but what do we need here?
    var it = std.mem.tokenizeAny(u8, poem, " ,;!\n");

    // print all words and count them
    var cnt: usize = 0;
    while (it.next()) |word| {
        cnt += 1;
        print("{s}\n", .{word});
    }

    // print the result
    print("This little poem has {d} words!\n", .{cnt});
}
