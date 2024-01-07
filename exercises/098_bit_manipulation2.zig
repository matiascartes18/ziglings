//
// Otra práctica útil para la manipulación de bits es establecer bits como banderas.
// Esto es especialmente útil cuando se procesan listas de algo y se almacenan
// los estados de las entradas, por ejemplo, una lista de números y para cada número primo
// se establece una bandera.
//
// Como ejemplo, tomemos el ejercicio Pangram de Exercism:
// https://exercism.org/tracks/zig/exercises/pangram
//
// Un pangrama es una frase que usa cada letra del alfabeto al menos una vez.
// No distingue entre mayúsculas y minúsculas, por lo que no importa si una letra es minúscula
// o mayúscula. El pangrama en inglés más conocido es:
//
//           "The quick brown fox jumps over the lazy dog."
//
// Hay varias formas de seleccionar las letras que aparecen en el pangrama
// (y no importa si aparecen una o varias veces).
//
// Por ejemplo, podrías tomar un array de bool y establecer el valor a 'true'
// para cada letra en el orden del alfabeto (a=0; b=1; etc.) encontrada en
// la frase. Sin embargo, esto no es ni eficiente en memoria ni particularmente
// rápido. En su lugar, tomamos un camino más sencillo, muy similar en principio, definimos
// una variable con al menos 26 bits (por ejemplo, u32) y también establecemos el bit para cada
// letra encontrada en la posición correspondiente.
//
// Zig proporciona funciones para esto en la biblioteca estándar, pero preferimos
// resolverlo sin estos extras, después de todo queremos aprender algo.
//
const std = @import("std");
const ascii = std.ascii;
const print = std.debug.print;

pub fn main() !void {
    // let's check the pangram
    print("Is this a pangram? {?}!\n", .{isPangram("The quick brown fox jumps over the lazy dog.")});
}

fn isPangram(str: []const u8) bool {
    // first we check if the string has at least 26 characters
    if (str.len < 26) return false;

    // we uses a 32 bit variable of which we need 26 bits
    var bits: u32 = 0;

    // loop about all characters in the string
    for (str) |c| {
        // if the character is an alphabetical character
        if (ascii.isASCII(c) and ascii.isAlphabetic(c)) {
            // luego establecemos el bit en la posición
            //
            // para hacer esto, usamos un pequeño truco:
            // dado que las letras en la tabla ASCII comienzan en 65
            // y están numeradas secuencialmente, simplemente restamos la
            // primera letra (en este caso, la 'a') del carácter
            // encontrado, y así obtenemos la posición del bit deseado
            bits |= @as(u32, 1) << @truncate(ascii.toLower(c) - 'a');
        }
    }
    // last we return the comparison if all 26 bits are set,
    // and if so, we know the given string is a pangram
    //
    // but what do we have to compare?
    return bits == 0x3FFFFFF;
}
