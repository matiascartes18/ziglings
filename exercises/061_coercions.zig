//
// Solo nos llevará un momento aprender las reglas de coerción de tipos en Zig
// porque son bastante lógicas.
//
// 1. Los tipos siempre se pueden hacer más restrictivos.
//
//    var foo: u8 = 5;
//    var p1: *u8 = &foo;
//    var p2: *const u8 = p1; // de mutable a inmutable
//
// 2. Los tipos numéricos se pueden coercer a tipos _más grandes_.
//
//    var n1: u8 = 5;
//    var n2: u16 = n1; // "ampliación" de enteros
//
//    var n3: f16 = 42.0;
//    var n4: f32 = n3; // "ampliación" de flotantes
//
// 3. Los punteros de un solo elemento a arreglos se coercen a slices y
//    punteros de varios elementos.
//
//    const arr: [3]u8 = [3]u8{5, 6, 7};
//    const s: []const u8 = &arr;  // a slice
//    const p: [*]const u8 = &arr; // a puntero de varios elementos
//
// 4. Los punteros mutables de un solo elemento se coercen a punteros de un solo
//    elemento que apuntan a un arreglo de longitud 1. (¡Interesante!)
//
//    var five: u8 = 5;
//    var a_five: *[1]u8 = &five;
//
// 5. Los tipos de carga útil y null se coercen a opcionales.
//
//    var num: u8 = 5;
//    var maybe_num: ?u8 = num; // tipo de carga útil
//    maybe_num = null;         // null
//
// 6. Los tipos de carga útil y errores se coercen a uniones de errores.
//
//    const MyError = error{Argh};
//    var char: u8 = 'x';
//    var char_or_die: MyError!u8 = char; // tipo de carga útil
//    char_or_die = MyError.Argh;         // error
//
// 7. 'undefined' se coercen a cualquier tipo (¡o no funcionaría!)
//
// 8. Los números en tiempo de compilación se coercen a tipos compatibles.
//
//    Casi todos los programas de ejercicios han tenido un ejemplo de esto,
//    pero una explicación completa y adecuada está por venir en el
//    fascinante tema de comptime.
//
// 9. Las uniones etiquetadas se coercen al enum etiquetado actual.
//
// 10. Los enums se coercen a una unión etiquetada cuando ese campo etiquetado
//     es un tipo de longitud cero que solo tiene un valor (como void).
//
// 11. Los tipos de cero bits (como void) se pueden coercer en punteros de un solo
//     elemento.
//
// Las últimas tres son bastante esotéricas, pero estás más que
// bienvenido a leer más al respecto en la documentación oficial del lenguaje Zig
// y realizar tus propios experimentos.

const print = @import("std").debug.print;

pub fn main() void {
    var letter: u8 = 'A';

    const my_letter: ?*[1]u8 = &letter;
    //               ^^^^^^^
    //           Your type here.
    // Must coerce from &letter (which is a *u8).
    // Hint: Use coercion Rules 4 and 5.

    // When it's right, this will work:
    print("Letter: {u}\n", .{my_letter.?.*[0]});
}
