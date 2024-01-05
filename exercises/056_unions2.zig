//
// Es realmente bastante incómodo tener que realizar un seguimiento manual
// del campo activo en nuestra unión, ¿verdad?
//
// Afortunadamente, Zig también tiene "uniones etiquetadas", que nos permiten
// almacenar un valor de enum dentro de nuestra unión que representa qué campo
// está activo.
//
//     const FooTag = enum{ small, medium, large };
//
//     const Foo = union(FooTag) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// Ahora podemos usar un switch directamente en la unión para actuar sobre el
// campo activo:
//
//     var f = Foo{ .small = 10 };
//
//     switch (f) {
//         .small => |my_small| hacer_algo(my_small),
//         .medium => |my_medium| hacer_algo(my_medium),
//         .large => |my_large| hacer_algo(my_large),
//     }
//
// Hagamos que nuestros Insectos usen una unión etiquetada (Doctor Zoraptera
// lo aprueba).
//
const std = @import("std");

const InsectStat = enum { flowers_visited, still_alive };

const Insect = union(InsectStat) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn main() void {
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 16 };

    std.debug.print("Insect report! ", .{});

    // Could it really be as simple as just passing the union?
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

// Por cierto, ¿las uniones te recordaron a los valores opcionales y los errores?
// Los valores opcionales son básicamente "uniones nulas" y los errores utilizan "tipos de unión de errores".
// Ahora podemos agregar nuestras propias uniones para manejar cualquier situación que podamos encontrar:
//          union(Tag) { value: u32, toxic_ooze: void }
