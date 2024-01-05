//
// La parte complicada es que la mutabilidad del puntero (var vs const) se refiere
// a la capacidad de cambiar a qué apunta el puntero, ¡no la capacidad
// de cambiar el VALOR en esa ubicación!
//
//     const bloqueado: u8 = 5;
//     var desbloqueado: u8 = 10;
//
//     const p1: *const u8 = &bloqueado;
//     var   p2: *const u8 = &bloqueado;
//
// Tanto p1 como p2 apuntan a valores constantes que no pueden cambiar. Sin embargo,
// ¡p2 puede cambiarse para apuntar a algo más y p1 no!
//
//     const p3: *u8 = &desbloqueado;
//     var   p4: *u8 = &desbloqueado;
//     const p5: *const u8 = &desbloqueado;
//     var   p6: *const u8 = &desbloqueado;
//
// Aquí p3 y p4 pueden usarse para cambiar el valor al que apuntan, pero
// p3 no puede apuntar a nada más.
// Lo interesante es que p5 y p6 actúan como p1 y p2, pero apuntan a
// el valor en "desbloqueado". ¡Esto es lo que queremos decir cuando decimos que podemos
// hacer una referencia constante a cualquier valor!
//
const std = @import("std");

pub fn main() void {
    var foo: u8 = 5;
    var bar: u8 = 10;

    // Please define pointer "p" so that it can point to EITHER foo or
    // bar AND change the value it points to!
    var p: * u8 = undefined;

    p = &foo;
    p.* += 1;
    p = &bar;
    p.* += 1;
    std.debug.print("foo={}, bar={}\n", .{ foo, bar });
}
