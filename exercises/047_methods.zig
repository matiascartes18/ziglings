
// ¡Ayuda! Criaturas alienígenas malvadas han escondido huevos por toda la Tierra
// ¡y están empezando a eclosionar!

// Antes de entrar en batalla, necesitarás saber tres cosas:

// 1. Puedes adjuntar funciones a estructuras (y otras "definiciones de tipo"):

//     const Foo = struct{
//         pub fn hello() void {
//             std.debug.print("¡Foo dice hola!\n", .{});
//         }
//     };

// 2. Una función que es miembro de una estructura está "espaciada de nombres" dentro
//    de esa estructura y se llama especificando el "espacio de nombres" y luego
//    usando la sintaxis de "punto":
//
//     Foo.hello();
//
// 3. La característica GENIAL de estas funciones es que si su primer argumento
//    es una instancia de la estructura (o un puntero a una) entonces podemos usar
//    la instancia como el espacio de nombres en lugar del tipo:
// 
//     const Bar = struct{
//         pub fn a(self: Bar) void {}
//         pub fn b(this: *Bar, other: u8) void {}
//         pub fn c(bar: *const Bar) void {}
//     };
//
//    var bar = Bar{};
//    bar.a() // es equivalente a Bar.a(bar)
//    bar.b(3) // es equivalente a Bar.b(&bar, 3)
//    bar.c() // es equivalente a Bar.c(&bar)
//
//    Observa que el nombre del parámetro no importa. Algunos usan
//    self, otros usan una versión en minúsculas del nombre del tipo, pero siéntete
//    libre de usar lo que sea más apropiado.
//
// Bien, estás armado.
//
// Ahora, por favor, zapea las estructuras alienígenas hasta que todas desaparezcan o
// ¡la Tierra estará condenada!
//
const std = @import("std");

// Look at this hideous Alien struct. Know your enemy!
const Alien = struct {
    health: u8,

    // We hate this method:
    pub fn hatch(strength: u8) Alien {
        return Alien{
            .health = strength * 5,
        };
    }
};

// Your trusty weapon. Zap those aliens!
const HeatRay = struct {
    damage: u8,

    // We love this method:
    pub fn zap(self: HeatRay, alien: *Alien) void {
        alien.health -= if (self.damage >= alien.health) alien.health else self.damage;
    }
};

pub fn main() void {
    // Look at all of these aliens of various strengths!
    var aliens = [_]Alien{
        Alien.hatch(2),
        Alien.hatch(1),
        Alien.hatch(3),
        Alien.hatch(3),
        Alien.hatch(5),
        Alien.hatch(3),
    };

    var aliens_alive = aliens.len;
    const heat_ray = HeatRay{ .damage = 7 }; // We've been given a heat ray weapon.

    // We'll keep checking to see if we've killed all the aliens yet.
    while (aliens_alive > 0) {
        aliens_alive = 0;

        // Loop through every alien by reference (* makes a pointer capture value)
        for (&aliens) |*alien| {

            // *** Zap the alien with the heat ray here! ***
            heat_ray.zap(alien);

            // If the alien's health is still above 0, it's still alive.
            if (alien.health > 0) aliens_alive += 1;
        }

        std.debug.print("{} aliens. ", .{aliens_alive});
    }       

    std.debug.print("Earth is saved!\n", .{});
}
