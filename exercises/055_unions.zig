//
// Unión te permite almacenar diferentes tipos y tamaños de datos en la misma dirección de memoria. ¿Cómo es esto posible? El compilador reserva suficiente memoria para el objeto más grande que puedas querer almacenar.
//
// En este ejemplo, una instancia de Foo siempre ocupa 64 bits de espacio en memoria, incluso si actualmente estás almacenando un u8.
//
//     const Foo = union {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// La sintaxis se parece a la de una estructura, pero un Foo solo puede contener un valor small O medium O large. Una vez que un campo se vuelve activo, los otros campos inactivos no se pueden acceder. Para cambiar los campos activos, asigna una nueva instancia completa:
//
//     var f = Foo{ .small = 5 };
//     f.small += 5;                  // BIEN
//     f.medium = 5432;               // ¡ERROR!
//     f = Foo{ .medium = 5432 };     // BIEN
//
// Las uniones pueden ahorrar espacio en memoria porque te permiten "reutilizar" un espacio en memoria. También proporcionan una especie de polimorfismo primitivo. Aquí, fooBar() puede tomar un Foo sin importar el tamaño del entero sin signo que contenga:
//
//     fn fooBar(f: Foo) void { ... }
//
// Pero, ¿cómo sabe fooBar() qué campo está activo? Zig tiene una forma ingeniosa de llevar un seguimiento, pero por ahora, tendremos que hacerlo manualmente.
//
// ¡Veamos si podemos hacer que este programa funcione!
//
const std = @import("std");

// Acabamos de comenzar a escribir una simulación simple de un ecosistema.
// Los insectos serán representados por abejas o hormigas. Las abejas almacenan
// el número de flores que han visitado ese día y las hormigas solo almacenan
// si están vivas o no.
const Insect = union {
    flowers_visited: u16,
    still_alive: bool,
};

// Dado que necesitamos especificar el tipo de insecto, usaremos una
// enumeración (¿recuerdas eso?).
const AntOrBee = enum { a, b };

pub fn main() void {
    // We'll just make one bee and one ant to test them out:
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 15 };

    std.debug.print("Insect report! ", .{});

    // Oops! We've made a mistake here.
    printInsect(ant, AntOrBee.a);
    printInsect(bee, AntOrBee.b);

    std.debug.print("\n", .{});
}

// Eccentric Doctor Zoraptera says that we can only use one
// function to print our insects. Doctor Z is small and sometimes
// inscrutable but we do not question her.
fn printInsect(insect: Insect, what_it_is: AntOrBee) void {
    switch (what_it_is) {
        .a => std.debug.print("Ant alive is: {}. ", .{insect.still_alive}),
        .b => std.debug.print("Bee visited {} flowers. ", .{insect.flowers_visited}),
    }
}
