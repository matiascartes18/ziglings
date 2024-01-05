//
// Otro problema común es un bloque de código que podría salir en múltiples
// lugares debido a un error, pero que necesita hacer algo antes de salir
// (normalmente para limpiar después de sí mismo).
//
// Un "errdefer" es un defer que solo se ejecuta si el bloque sale con un error:
//
//     {
//         errdefer cleanup();
//         try canFail();
//     }
//
// La función cleanup() se llama SOLO si la declaración "try" devuelve un
// error producido por canFail().
//
const std = @import("std");

var counter: u32 = 0;

const MyErr = error{ GetFail, IncFail };

pub fn main() void {
    // We simply quit the entire program if we fail to get a number:
    const a: u32 = makeNumber() catch return;
    const b: u32 = makeNumber() catch return;

    std.debug.print("Numbers: {}, {}\n", .{ a, b });
}

fn makeNumber() MyErr!u32 {
    std.debug.print("Getting number...", .{});

    // Please make the "failed" message print ONLY if the makeNumber()
    // function exits with an error:
    errdefer std.debug.print("failed!\n", .{});

    var num = try getNumber(); // <-- This could fail!

    num = try increaseNumber(num); // <-- This could ALSO fail!

    std.debug.print("got {}. ", .{num});

    return num;
}

fn getNumber() MyErr!u32 {
    // I _could_ fail...but I don't!
    return 4;
}

fn increaseNumber(n: u32) MyErr!u32 {
    // I fail after the first time you run me!
    if (counter > 0) return MyErr.IncFail;

    // Sneaky, weird global stuff.
    counter += 1;

    return n + 1;
}
