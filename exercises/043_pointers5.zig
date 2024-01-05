//
// Al igual que con los enteros, puedes pasar un puntero a una estructura cuando desees modificar esa estructura. Los punteros también son útiles cuando necesitas almacenar una referencia a una estructura (un "enlace" a ella).

//     const Vertex = struct{ x: u32, y: u32, z: u32 };

//     var v1 = Vertex{ .x=3, .y=2, .z=5 };

//     var pv: *Vertex = &v1;   // <-- un puntero a nuestra estructura

// Ten en cuenta que no necesitas desreferenciar el puntero "pv" para acceder a los campos de la estructura:

//     SÍ: pv.x
//     NO:  pv.*.x

// Podemos escribir funciones que tomen punteros a estructuras como argumentos. Esta función foo() modifica la estructura v:

//     fn foo(v: *Vertex) void {
//         v.x += 2;
//         v.y += 3;
//         v.z += 7;
//     }

// Y llamarlas de la siguiente manera:

//     foo(&v1);

// Revisemos nuestro ejemplo de RPG y hagamos una función printCharacter() que tome un Character por referencia y lo imprima... *y* imprima un Character "mentor" vinculado, si lo hay.

const std = @import("std");

const Class = enum {
    wizard,
    thief,
    bard,
    warrior,
};

const Character = struct {
    class: Class,
    gold: u32,
    health: u8 = 100, // You can provide default values
    experience: u32,

    // I need to use the '?' here to allow for a null value. But
    // I don't explain it until later. Please don't tell anyone.
    mentor: ?*Character = null,
};

pub fn main() void {
    var mighty_krodor = Character{
        .class = Class.wizard,
        .gold = 10000,
        .experience = 2340,
    };

    var glorp = Character{ // Glorp!
        .class = Class.wizard,
        .gold = 10,
        .experience = 20,
        .mentor = &mighty_krodor, // Glorp's mentor is the Mighty Krodor
    };

    // FIX ME!
    // Please pass Glorp to printCharacter():
    printCharacter(&glorp);
}

// Note how this function's "c" parameter is a pointer to a Character struct.
fn printCharacter(c: *Character) void {
    // Here's something you haven't seen before: when switching an enum, you
    // don't have to write the full enum name. Zig understands that ".wizard"
    // means "Class.wizard" when we switch on a Class enum value:
    const class_name = switch (c.class) {
        .wizard => "Wizard",
        .thief => "Thief",
        .bard => "Bard",
        .warrior => "Warrior",
    };

    std.debug.print("{s} (G:{} H:{} XP:{})\n", .{
        class_name,
        c.gold,
        c.health,
        c.experience,
    });

    // Checking an "optional" value and capturing it will be
    // explained later (this pairs with the '?' mentioned above.)
    if (c.mentor) |mentor| {
        std.debug.print("  Mentor: ", .{});
        printCharacter(mentor);
    }
}
