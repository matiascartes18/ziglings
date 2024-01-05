//
// Poder agrupar valores nos permite convertir esto:
//
//     point1_x = 3;
//     point1_y = 16;
//     point1_z = 27;
//     point2_x = 7;
//     point2_y = 13;
//     point2_z = 34;
//
// en esto:
//
//     point1 = Point{ .x=3, .y=16, .z=27 };
//     point2 = Point{ .x=7, .y=13, .z=34 };
//
// El Point de arriba es un ejemplo de una "struct" (abreviatura de "estructura").
// Así es como se podría haber definido ese tipo de struct:
//
//     const Point = struct{ x: u32, y: u32, z: u32 };
//
// ¡Guardemos algo divertido con una struct: un personaje de rol!
//
const std = @import("std");

// We'll use an enum to specify the character role.
const Role = enum {
    wizard,
    thief,
    bard,
    warrior,
};

// Please add a new property to this struct called "health" and make
// it a u8 integer type.
const Character = struct { role: Role, gold: u32, experience: u32, health: u8 };

pub fn main() void {
    // Please initialize Glorp with 100 health.
    var glorp_the_wise = Character{
        .role = Role.wizard,
        .gold = 20,
        .experience = 10,
        .health = 100,
    };

    // Glorp gains some gold.
    glorp_the_wise.gold += 5;

    // Ouch! Glorp takes a punch!
    glorp_the_wise.health -= 10;

    std.debug.print("Your wizard has {} health and {} gold.\n", .{
        glorp_the_wise.health,
        glorp_the_wise.gold,
    });
}
