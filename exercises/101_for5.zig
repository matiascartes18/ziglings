//
// El bucle 'for' no se limita solo a iterar sobre uno o dos
// elementos. ¡Probemos un ejemplo con un montón!
//
// Pero primero, hay una última cosa que hemos evitado mencionar
// hasta ahora: El rango especial que omite el último valor:
//
//     for ( cosas, 0.. ) |c, i| { ... }
//
// Así es como le decimos a Zig que queremos obtener un valor numérico para
// cada elemento en "cosas", comenzando con 0.
//
// Una característica agradable de estos rangos de índice es que puedes hacer que comiencen
// con cualquier número que elijas. El primer valor de "i" en
// este ejemplo será 500, luego 501, 502, etc.:
//
//     for ( cosas, 500.. ) |c, i| { ... }
//
// ¿Recuerdas nuestros personajes de RPG? Tenían las siguientes
// propiedades, que almacenamos en un tipo de estructura:
//
//     clase
//     oro
//     experiencia
//
// Lo que vamos a hacer ahora es almacenar los mismos datos de personajes de RPG,
// pero en un array separado para cada propiedad.
//
// Puede parecer un poco incómodo, pero aguantemos.
//
// Hemos comenzado a escribir un programa para imprimir una lista numerada de
// personajes con cada una de sus propiedades, pero necesita un
// poco de ayuda:
//
const std = @import("std");
const print = std.debug.print;

// This is the same character role enum we've seen before.
const Role = enum {
    wizard,
    thief,
    bard,
    warrior,
};

pub fn main() void {
    // Here are the three "property" arrays:
    const roles = [4]Role{ .wizard, .bard, .bard, .warrior };
    const gold = [4]u16{ 25, 11, 5, 7392 };
    const experience = [4]u8{ 40, 17, 55, 21 };

    // We would like to number our list starting with 1, not 0.
    // How do we do that?
    for (roles, gold, experience, 1..) |c, g, e, i| {
        const role_name = switch (c) {
            .wizard => "Wizard",
            .thief => "Thief",
            .bard => "Bard",
            .warrior => "Warrior",
        };

        std.debug.print("{d}. {s} (Gold: {d}, XP: {d})\n", .{
            i,
            role_name,
            g,
            e,
        });
    }
}
//
// Por cierto, almacenar nuestros datos de personajes en arrays de esta manera
// no es *solo* una forma tonta de demostrar los bucles 'for' con múltiples
// objetos.
//
// Es *también* una forma tonta de introducir un concepto llamado
// "diseño orientado a datos".
//
// Usemos una metáfora para desarrollar una intuición de qué se trata todo esto:
//
// Digamos que te han encargado agarrar tres canicas de vidrio, tres cucharas y tres plumas de una bolsa mágica.
// Pero no puedes usar tus manos para agarrarlos. En cambio, debes
// usar una cuchara para canicas, un imán para cucharas y unas pinzas para plumas para agarrar
// cada tipo de objeto.
//
// Ahora, ¿preferirías usar la bolsa mágica que:
//
// A. Agrupa los elementos en racimos, por lo que tienes que recoger una
//    canica, luego una cuchara, luego una pluma?
//
//    O
//
// B. Agrupa los elementos por tipo, por lo que puedes recoger todas las
//    canicas a la vez, luego todas las cucharas, luego todas las
//    plumas?
//
// Si esta metáfora está funcionando, esperamos que esté claro que la opción 'B'
// sería mucho más eficiente.
//
// Bueno, probablemente no sorprenda que almacenar y
// usar datos de manera secuencial y uniforme también es más
// eficiente para las CPUs modernas.
//
// Décadas de prácticas de OOP han orientado a las personas hacia la agrupación
// de diferentes tipos de datos juntos en "objetos" de tipo mixto con
// la intención de que estos sean más fáciles para la mente humana.
// El diseño orientado a datos agrupa datos por tipo de una manera que es
// más fácil para la computadora.
//
// Con un diseño de lenguaje inteligente, tal vez podamos tener ambos.
//
// En la comunidad de Zig, puedes ver la diferencia en agrupaciones
// presentada con los términos "Array de Structs" (AoS) versus
// "Struct de Arrays" (SoA).
//
// Para visualizar estos dos diseños en acción, imagina un array de
// structs de personajes de RPG, cada uno conteniendo tres tipos de datos diferentes (AoS) versus un solo struct de personaje de RPG que contiene
// tres arrays de un solo tipo de datos cada uno, como los del ejercicio
// anterior (SoA).
//
// Para una aplicación más práctica del "diseño orientado a datos"
// mira la siguiente charla de Andrew Kelley, el creador de Zig:
// https://vimeo.com/649009599//
