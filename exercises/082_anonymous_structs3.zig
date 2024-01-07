//
// Incluso puedes crear literales de estructuras anónimas sin nombres de campo:
//
//     .{
//         false,
//         @as(u32, 15),
//         @as(f64, 67.12)
//     }
//
// A estos los llamamos "tuplas", que es un término utilizado por muchos
// lenguajes de programación para un tipo de datos con campos referenciados
// por orden de índice en lugar de por nombre. Para hacer esto posible, el compilador Zig
// asigna automáticamente nombres de campo numéricos 0, 1, 2,
// etc. a la estructura.
//
// Dado que los números desnudos no son identificadores legales (foo.0 es un
// error de sintaxis), tenemos que citarlos con la sintaxis @"".
// Ejemplo:
//
//     const foo = .{ true, false };
//
//     print("{} {}\n", .{foo.@"0", foo.@"1"});
//
// El ejemplo anterior imprime "true false".
//
// Espera, UN SEGUNDO...
//
// Si una cosa .{} es lo que la función print quiere, ¿necesitamos
// descomponer nuestra "tupla" y ponerla en otra? ¡No! ¡Es
// redundante! Esto imprimirá lo mismo:
//
//     print("{} {}\n", foo);
//
// ¡Aha! Así que ahora sabemos que print() toma una "tupla". Las cosas están
// realmente empezando a unirse ahora.
//
const print = @import("std").debug.print;
const std = @import("std");

pub fn main() void {
    // A "tuple":
    const foo = .{
        true,
        false,
        @as(i32, 42),
        @as(f32, 3.141592),
    };

    // We'll be implementing this:
    printTuple(foo);

    // This is just for fun, because we can:
    const nothing = .{};
    print("\n", nothing);
}

// Let's make our own generic "tuple" printer. This should take a
// "tuple" and print out each field in the following format:
//
//     "name"(type):value
//
// Example:
//
//     "0"(bool):true
//
// You'll be putting this together. But don't worry, everything
// you need is documented in the comments.
fn printTuple(tuple: anytype) void {
    // 1. Get a list of fields in the input 'tuple'
    // parameter. You'll need:
    //
    //     @TypeOf() - takes a value, returns its type.
    //
    //     @typeInfo() - takes a type, returns a TypeInfo union
    //                   with fields specific to that type.
    //
    //     The list of a struct type's fields can be found in
    //     TypeInfo's Struct.fields.
    //
    //     Example:
    //
    //         @typeInfo(Circle).Struct.fields
    //
    // This will be an array of StructFields.
    const fields = @typeInfo(@TypeOf(tuple)).Struct.fields;

    // 2. Loop through each field. This must be done at compile
    // time.
    //
    //     Hint: remember 'inline' loops?
    //
    inline for (fields) |field| {
        // 3. Print the field's name, type, and value.
        //
        //     Each 'field' in this loop is one of these:
        //
        //         pub const StructField = struct {
        //             name: []const u8,
        //             type: type,
        //             default_value: anytype,
        //             is_comptime: bool,
        //             alignment: comptime_int,
        //         };
        //
        //     You'll need this builtin:
        //
        //         @field(lhs: anytype, comptime field_name: []const u8)
        //
        //     The first parameter is the value to be accessed,
        //     the second parameter is a string with the name of
        //     the field you wish to access. The value of the
        //     field is returned.
        //
        //     Example:
        //
        //         @field(foo, "x"); // returns the value at foo.x
        //
        // The first field should print as: "0"(bool):true
        print("\"{s}\"({any}):{any} ", .{
            field.name,
            field.type,
            @field(tuple, field.name),
        });
    }
}
