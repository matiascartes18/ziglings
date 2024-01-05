//
// Ahora que tenemos tipos opcionales, podemos aplicarlos a las estructuras.
// La última vez que revisamos con nuestros elefantes, tuvimos que enlazar
// los tres juntos en un "círculo" para que la última cola
// estuviera enlazada al primer elefante. ¡Esto se debe a que NO TENÍAMOS
// ningún concepto de una cola que no apuntara a otro elefante!
//
// También introducimos el práctico atajo ".?":
//
//     const foo = bar.?;
//
// es lo mismo que
//
//     const foo = bar orelse unreachable;
//
// Veamos si puedes encontrar dónde usamos este atajo a continuación.
//
// ¡Ahora hagamos esas colas de elefante opcionales!
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null, // Hmm... tail needs something...
    visited: bool = false,
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // Link the elephants so that each tail "points" to the next.
    elephantA.tail = &elephantB;
    elephantB.tail = &elephantC;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// This function visits all elephants once, starting with the
// first elephant and following the tails to the next elephant.
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (!e.visited) {
        std.debug.print("Elephant {u}. ", .{e.letter});
        e.visited = true;

        // We should stop once we encounter a tail that
        // does NOT point to another element. What can
        // we put here to make that happen?
        if (e.tail == null) break;

        e = e.tail.?;
    }
}
