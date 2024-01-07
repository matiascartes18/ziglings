//
// Pudimos obtener una cadena imprimible de un puntero de muchos elementos
// utilizando un slice para afirmar una longitud específica.
//
// Pero, ¿podemos alguna vez VOLVER a un puntero terminado en centinela
// después de que hemos "perdido" el centinela en una coerción?
//
// Sí, podemos. La función incorporada @ptrCast() de Zig puede hacer esto. Mira
// la firma:
//
//     @ptrCast(value: anytype) anytype
//
// ¡Ve si puedes usarla para resolver el mismo problema del puntero de muchos elementos,
// pero sin necesidad de una longitud!
//
const print = @import("std").debug.print;

pub fn main() void {
    // Again, we've coerced the sentinel-terminated string to a
    // many-item pointer, which has no length or sentinel.
    const data: [*]const u8 = "Weird Data!";

    // Please cast 'data' to 'printable':
    const printable: [*:0]const u8 = @ptrCast(data);

    print("{s}\n", .{printable});
}
