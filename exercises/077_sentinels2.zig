//
// ------------------------------------------------------------
//  TOP SECRET  TOP SECRET  TOP SECRET  TOP SECRET  TOP SECRET
// ------------------------------------------------------------
//
// ¿Estás listo para LA VERDAD sobre los literales de cadena en Zig?
//
// Aquí está:
//
//     @TypeOf("foo") == *const [3:0]u8
//
// Lo que significa que un literal de cadena es un "puntero constante a un
// array de tamaño fijo terminado en cero (null-terminated) de u8".
//
// Ahora lo sabes. Te lo has ganado. ¡Bienvenido al club secreto!
//
// ------------------------------------------------------------
//
// ¿Por qué nos molestamos en usar un centinela cero/null para terminar
// las cadenas en Zig cuando ya tenemos una longitud conocida?
//
// ¡Versatilidad! Las cadenas de Zig son compatibles con las cadenas de C (que
// terminan en null) Y pueden ser convertidas a una variedad de otros
// tipos de Zig:
//
//     const a: [5]u8 = "array".*;
//     const b: *const [16]u8 = "puntero a array";
//     const c: []const u8 = "slice";
//     const d: [:0]const u8 = "slice con centinela";
//     const e: [*:0]const u8 = "puntero de muchos elementos con centinela";
//     const f: [*]const u8 = "puntero de muchos elementos";
//
// Todos excepto 'f' pueden ser impresos. (Un puntero de muchos elementos sin un
// centinela no es seguro para imprimir porque no sabemos dónde
// termina!)
//
const print = @import("std").debug.print;

const WeirdContainer = struct {
    data: [*]const u8,
    length: usize,
};

pub fn main() void {
    // WeirdContainer es una forma incómoda de alojar una cadena.
    //
    // Al ser un puntero de muchos elementos (sin terminación de centinela),
    // el campo 'data' "pierde" la información de longitud Y la
    // terminación de centinela del literal de cadena "Weird Data!".
    //
    // Afortunadamente, el campo 'length' hace posible seguir
    // trabajando con este valor.
    const foo = WeirdContainer{
        .data = "Weird Data!",
        .length = 11,
    };

    // ¿Cómo obtenemos un valor imprimible de 'foo'? Una forma es
    // convertirlo en algo con una longitud conocida. Tenemos una
    // longitud... ¡De hecho, ya has resuelto este problema antes!
    //
    // Aquí tienes una gran pista: ¿recuerdas cómo tomar un slice?
    const printable = foo.data[0..11];

    print("{s}\n", .{printable});
}
