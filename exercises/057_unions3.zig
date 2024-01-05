//
// ¡Con las uniones etiquetadas, se vuelve AÚN MEJOR! Si no necesitas un
// enum separado, puedes definir un enum inferido con tu unión en un solo lugar.
// Simplemente usa la palabra clave 'enum' en lugar del tipo de etiqueta:
//
//     const Foo = union(enum) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// Vamos a convertir Insecto. ¡El Doctor Zoraptera ya ha eliminado
// el enum explícito InsectStat por ti!
//
const std = @import("std");

const Insect = union(enum) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn main() void {
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 17 };

    std.debug.print("Insect report! ", .{});

    printInsect(ant);
    printInsect(bee);

    std.debug.print("\n", .{});
}

fn printInsect(insect: Insect) void {
    switch (insect) {
        .still_alive => |a| std.debug.print("Ant alive is: {}. ", .{a}),
        .flowers_visited => |f| std.debug.print("Bee visited {} flowers. ", .{f}),
    }
}

// Los enums inferidos son geniales, representando la punta del iceberg
// en la relación entre los enums y las uniones. En realidad, puedes
// forzar una unión A un enum (lo que te da el campo activo
// de la unión como un enum). ¡Lo que es aún más sorprendente es que puedes
// forzar un enum a una unión! Pero no te emociones demasiado, eso
// solo funciona cuando el tipo de unión es uno de esos tipos extraños de cero bits
// como void!
//
// Las uniones etiquetadas, al igual que la mayoría de las ideas en ciencias de la computación,
// tienen una larga historia que se remonta a la década de 1960. Sin embargo, solo
// recientemente se están volviendo populares, especialmente en lenguajes de programación
// a nivel de sistema. Es posible que también las hayas visto llamadas
// "variantes", "tipos suma" o incluso "enums"!
