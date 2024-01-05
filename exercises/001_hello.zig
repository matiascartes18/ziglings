//
// Oh no, this is supposed to print "Hello world!" but it needs
// your help.
//
// Por defecto, las funciones en Zig son privadas, pero la función main() debe ser pública.
//
// Una función se hace pública con la declaración "pub" de la siguiente manera:
//
//     pub fn foo() void {
//         ...
//     }
//
// Tal vez saber esto nos ayude a resolver los errores que estamos obteniendo
// con este pequeño programa?
//
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello world!\n", .{});
}
