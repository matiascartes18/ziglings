//
// A menudo, se utilizan funciones C donde aún no existe una función Zig equivalente.
// Dado que la integración de una función C es muy simple, como ya se vio en el último ejercicio,
// naturalmente se ofrece a sí misma para usar la muy amplia variedad de funciones C para nuestros propios programas.
// Como un ejemplo:
//
// Digamos que tenemos un ángulo dado de 765.2 grados. Si queremos
// normalizar eso, significa que tenemos que restar X * 360 grados
// para obtener el ángulo correcto. ¿Cómo podríamos hacer eso? Un buen método es
// usar la función módulo. Pero si escribimos "765.2 % 360", no funcionará,
// porque la función módulo estándar solo funciona con valores enteros. En la biblioteca C "math",
// hay una función llamada "fmod"; la "f" significa flotante y significa que podemos resolver módulo para
// números reales. Con esta función, debería ser posible normalizar
// nuestro ángulo. Vamos a ello.

const std = @import("std");

const c = @cImport({
    // What do we need here?
    @cInclude("math.h");
});

pub fn main() !void {
    const angle = 765.2;
    const circle = 360;

    // Here we call the C function 'fmod' to get our normalized angle.
    const result = c.fmod(angle, circle);

    // We use formatters for the desired precision and to truncate the decimal places
    std.debug.print("The normalized angle of {d: >3.1} degrees is {d: >3.1} degrees.\n", .{ angle, result });
}
