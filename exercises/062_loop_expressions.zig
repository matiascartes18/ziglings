//
// ¿Recuerdas cómo usar declaraciones if/else como expresiones de esta manera?
//
//     var foo: u8 = if (true) 5 else 0;
//
// Zig también te permite usar bucles for y while como expresiones.
//
// Al igual que 'return' para las funciones, puedes devolver un valor desde un
// bloque de bucle con break:
//
//     break true; // devuelve un valor booleano desde el bloque
//
// Pero, ¿qué valor se devuelve de un bucle si nunca se alcanza una declaración break?
// Necesitamos una expresión por defecto. Afortunadamente, los bucles en Zig también tienen cláusulas 'else'!
// Como podrás haber adivinado, la cláusula 'else' se evalúa cuando: 1) una condición 'while' se vuelve falsa o
// 2) un bucle 'for' se queda sin elementos.
//
//     const two: u8 = while (true) break 2 else 0;         // 2
//     const three: u8 = for ([1]u8{1}) |f| break 3 else 0; // 3
//
// Si no proporcionas una cláusula else, se proporcionará una vacía por defecto,
// que se evaluará como el tipo void, lo cual probablemente no es lo que quieres.
// Así que considera la cláusula else como esencial cuando uses bucles como expresiones.
//
//     const four: u8 = while (true) {
//         break 4;
//     };               // <-- ¡ERROR! ¡Aquí hay un 'else void' implícito!
//
// Teniendo eso en cuenta, intenta solucionar el problema con este programa.
//
const print = @import("std").debug.print;

pub fn main() void {
    const langs: [6][]const u8 = .{
        "Erlang",
        "Algol",
        "C",
        "OCaml",
        "Zig",
        "Prolog",
    };

    // Let's find the first language with a three-letter name and
    // return it from the for loop.
    const current_lang: ?[]const u8 = for (langs) |lang| {
        if (lang.len == 3) break lang;   
    } else null;

    if (current_lang) |cl| {
        print("Current language: {s}\n", .{cl});
    } else {
        print("Did not find a three-letter language name. :-(\n", .{});
    }
}
