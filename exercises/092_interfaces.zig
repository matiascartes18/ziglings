//
// ¿Recuerdas nuestro simulador de hormigas y abejas construido con uniones
// en los ejercicios 55 y 56? Allí, demostramos que
// las uniones nos permiten tratar diferentes tipos de datos de manera uniforme.
//
// Una característica interesante fue el uso de uniones etiquetadas para crear una única
// función para imprimir un estado para hormigas *o* abejas mediante un switch:
//
//   switch (insecto) {
//      .still_alive => ...      // (imprimir cosas de hormigas)
//      .flowers_visited => ...  // (imprimir cosas de abejas)
//   }
//
// Bueno, esa simulación estaba funcionando bien hasta que un nuevo insecto
// llegó al jardín virtual, ¡un saltamontes!
//
// La Doctora Zoraptera comenzó a añadir código de saltamontes al
// programa, pero luego se alejó de su teclado con un
// sonido de siseo enfadado. Se había dado cuenta de que tener código para
// cada insecto en un lugar y código para imprimir cada insecto en
// otro lugar iba a ser desagradable de mantener cuando
// la simulación se expandiera a cientos de diferentes insectos.
//
// Afortunadamente, Zig tiene otra característica de tiempo de compilación que podemos usar
// para salir de este dilema llamada 'inline else'.
//
// Podemos reemplazar este código redundante:
//
//   switch (cosa) {
//       .a => |a| especial(a),
//       .b => |b| normal(b),
//       .c => |c| normal(c),
//       .d => |d| normal(d),
//       .e => |e| normal(e),
//       ...
//   }
//
// Con:
//
//   switch (cosa) {
//       .a => |a| especial(a),
//       inline else => |t| normal(t),
//   }
//
// Podemos tener un manejo especial de algunos casos y luego Zig
// maneja el resto de las coincidencias por nosotros.
//
// Con esta característica, decides hacer una unión Insecto con una
// única función uniforme 'print()'. Todos los insectos pueden
// entonces ser responsables de imprimirse a sí mismos. Y la Doctora
// Zoraptera puede calmarse y dejar de roer los muebles.
//
const std = @import("std");

const Ant = struct {
    still_alive: bool,

    pub fn print(self: Ant) void {
        std.debug.print("Ant is {s}.\n", .{if (self.still_alive) "alive" else "dead"});
    }
};

const Bee = struct {
    flowers_visited: u16,

    pub fn print(self: Bee) void {
        std.debug.print("Bee visited {} flowers.\n", .{self.flowers_visited});
    }
};

// Here's the new grasshopper. Notice how we've also added print
// methods to each insect.
const Grasshopper = struct {
    distance_hopped: u16,

    pub fn print(self: Grasshopper) void {
        std.debug.print("Grasshopper hopped {} meters.\n", .{self.distance_hopped});
    }
};

const Insect = union(enum) {
    ant: Ant,
    bee: Bee,
    grasshopper: Grasshopper,

    // Thanks to 'inline else', we can think of this print() as
    // being an interface method. Any member of this union with
    // a print() method can be treated uniformly by outside
    // code without needing to know any other details. Cool!
    pub fn print(self: Insect) void {
        switch (self) {
            inline else => |case| return case.print(),
        }
    }
};

pub fn main() !void {
    const my_insects = [_]Insect{
        Insect{ .ant = Ant{ .still_alive = true } },
        Insect{ .bee = Bee{ .flowers_visited = 17 } },
        Insect{ .grasshopper = Grasshopper{ .distance_hopped = 32 } },
    };

    std.debug.print("Daily Insect Report:\n", .{});
    for (my_insects) |insect| {
        // Almost done! We want to print() each insect with a
        // single method call here.
        insect.print();
    }
}

// Our print() method in the Insect union above demonstrates
// something very similar to the object-oriented concept of an
// abstract data type. That is, the Insect type doesn't contain
// the underlying data, and the print() function doesn't
// actually do the printing.
//
// The point of an interface is to support generic programming:
// the ability to treat different things as if they were the
// same to cut down on clutter and conceptual complexity.
//
// The Daily Insect Report doesn't need to worry about *which*
// insects are in the report - they all print the same way via
// the interface!
//
// Doctor Zoraptera loves it.
