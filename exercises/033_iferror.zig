//
// Vamos a revisar el primer ejercicio de manejo de errores. Esta vez, vamos a
// ver una variación del enunciado "if" para manejar errores.
//
//     if (foo) |valor| {
//
//         // foo NO fue un error; valor es el valor no-error de foo
//
//     } else |err| {
//
//         // foo FUE un error; err es el valor de error de foo
//
//     }
//
// Vamos a llevarlo aún más lejos y usar una declaración switch para manejar
// los tipos de error.

//     if (foo) |valor| {
//         ...
//     } else |err| switch(err) {
//         ...
// }

const MyNumberError = error{
    TooBig,
    TooSmall,
};

const std = @import("std");

pub fn main() void {
    const nums = [_]u8{ 2, 3, 4, 5, 6 };

    for (nums) |num| {
        std.debug.print("{}", .{num});

        const n = numberMaybeFail(num);
        if (n) |value| {
            std.debug.print("={}. ", .{value});
        } else |err| switch (err) {
            MyNumberError.TooBig => std.debug.print(">4. ", .{}),
            MyNumberError.TooSmall => std.debug.print("<4. ", .{}),
            // Please add a match for TooSmall here and have it print: "<4. "
        }
    }

    std.debug.print("\n", .{});
}

// This time we'll have numberMaybeFail() return an error union rather
// than a straight error.
fn numberMaybeFail(n: u8) MyNumberError!u8 {
    if (n > 4) return MyNumberError.TooBig;
    if (n < 4) return MyNumberError.TooSmall;
    return n;
}
