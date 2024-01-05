//
// Poder pasar tipos a funciones en tiempo de compilación nos permite
// generar código que funciona con múltiples tipos. Pero no nos
// ayuda a pasar VALORES de diferentes tipos a una función.
//
// Para eso, tenemos el marcador de posición 'anytype', que le dice a Zig
// que infiera el tipo real de un parámetro en tiempo de compilación.
//
//     fn foo(thing: anytype) void { ... }
//
// Luego podemos usar funciones incorporadas como @TypeOf(), @typeInfo(),
// @typeName(), @hasDecl() y @hasField() para determinar más
// acerca del tipo que se ha pasado. Toda esta lógica se
// realizará completamente en tiempo de compilación.
//
const print = @import("std").debug.print;

// Let's define three structs: Duck, RubberDuck, and Duct. Notice
// that Duck and RubberDuck both contain waddle() and quack()
// methods declared in their namespace (also known as "decls").

const Duck = struct {
    eggs: u8,
    loudness: u8,
    location_x: i32 = 0,
    location_y: i32 = 0,

    fn waddle(self: *Duck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    fn quack(self: Duck) void {
        if (self.loudness < 4) {
            print("\"Quack.\" ", .{});
        } else {
            print("\"QUACK!\" ", .{});
        }
    }
};

const RubberDuck = struct {
    in_bath: bool = false,
    location_x: i32 = 0,
    location_y: i32 = 0,

    fn waddle(self: *RubberDuck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    fn quack(self: RubberDuck) void {
        // Assigning an expression to '_' allows us to safely
        // "use" the value while also ignoring it.
        _ = self;
        print("\"Squeek!\" ", .{});
    }

    fn listen(self: RubberDuck, dev_talk: []const u8) void {
        // Listen to developer talk about programming problem.
        // Silently contemplate problem. Emit helpful sound.
        _ = dev_talk;
        self.quack();
    }
};

const Duct = struct {
    diameter: u32,
    length: u32,
    galvanized: bool,
    connection: ?*Duct = null,

    fn connect(self: *Duct, other: *Duct) !void {
        if (self.diameter == other.diameter) {
            self.connection = other;
        } else {
            return DuctError.UnmatchedDiameters;
        }
    }
};

const DuctError = error{UnmatchedDiameters};

pub fn main() void {
    // This is a real duck!
    const ducky1 = Duck{
        .eggs = 0,
        .loudness = 3,
    };

    // This is not a real duck, but it has quack() and waddle()
    // abilities, so it's still a "duck".
    const ducky2 = RubberDuck{
        .in_bath = false,
    };

    // This is not even remotely a duck.
    const ducky3 = Duct{
        .diameter = 17,
        .length = 165,
        .galvanized = true,
    };

    print("ducky1: {}, ", .{isADuck(ducky1)});
    print("ducky2: {}, ", .{isADuck(ducky2)});
    print("ducky3: {}\n", .{isADuck(ducky3)});
}

// Esta función tiene un solo parámetro que se infiere en
// tiempo de compilación. Utiliza las funciones incorporadas @TypeOf() y @hasDecl() para
// realizar tipado de pato ("si camina como un pato y grazna
// como un pato, entonces debe ser un pato") para determinar si el tipo
// es un "pato".
fn isADuck(possible_duck: anytype) bool {
    // Usaremos @hasDecl() para determinar si el tipo tiene
    // todo lo necesario para ser un "pato".
    //
    // En este ejemplo, 'has_increment' será verdadero si el tipo Foo
    // tiene un método increment():
    //
    //     const has_increment = @hasDecl(Foo, "increment");
    //
    // Por favor, asegúrate de que MyType tenga tanto los métodos waddle() como quack():
    const MyType = @TypeOf(possible_duck);
    const walks_like_duck = @hasDecl(MyType, "waddle");
    const quacks_like_duck = @hasDecl(MyType, "quack");

    const is_duck = walks_like_duck and quacks_like_duck;

    if (is_duck) {
        // También llamamos al método quack() aquí para demostrar que Zig
        // nos permite realizar acciones de pato en cualquier cosa
        // suficientemente parecida a un pato.
        //
        // Como todas las comprobaciones e inferencias se realizan
        // en tiempo de compilación, todavía tenemos seguridad de tipo completa:
        // intentar llamar al método quack() en una estructura que
        // no lo tiene (como Duct) resultaría en un error de compilación,
        // ¡no en un pánico o fallo en tiempo de ejecución!
        possible_duck.quack();
    }

    return is_duck;
}
