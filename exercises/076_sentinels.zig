//
// Un valor centinela indica el final de los datos. Imaginemos una
// secuencia de letras minúsculas donde la 'S' mayúscula es el
// centinela, indicando el final de la secuencia:
//
//     abcdefS
//
// Si nuestra secuencia también permite letras mayúsculas, 'S' sería
// un terrible centinela ya que ya no podría ser un valor regular
// en la secuencia:
//
//     abcdQRST
//          ^-- ¡Vaya! ¡La última letra de la secuencia es R!
//
// Una elección popular para indicar el final de una cadena es el
// valor 0. ASCII y Unicode llaman a esto el "Carácter Nulo".
//
// Zig admite arrays, slices y punteros terminados en centinela:
//
//     const a: [4:0]u32       =  [4:0]u32{1, 2, 3, 4};
//     const b: [:0]const u32  = &[4:0]u32{1, 2, 3, 4};
//     const c: [*:0]const u32 = &[4:0]u32{1, 2, 3, 4};
//
// El array 'a' almacena 5 valores u32, el último de los cuales es 0.
// Sin embargo, el compilador se encarga de este detalle de mantenimiento
// por ti. Puedes tratar 'a' como un array normal con solo 4
// elementos.
//
// El slice 'b' solo puede apuntar a arrays terminados en cero
// pero por lo demás funciona igual que un slice normal.
//
// El puntero 'c' es exactamente como los punteros de muchos elementos que aprendimos
// en el ejercicio 054, pero está garantizado que termina en 0.
// Debido a esta garantía, podemos encontrar de manera segura el final de este
// puntero de muchos elementos sin conocer su longitud. (¡NO podemos hacer
// eso con punteros regulares de muchos elementos!).
//
// Importante: el valor centinela debe ser del mismo tipo que los
// datos que se están terminando!
//
const print = @import("std").debug.print;
const sentinel = @import("std").meta.sentinel;

pub fn main() void {
    // Here's a zero-terminated array of u32 values:
    var nums = [_:0]u32{ 1, 2, 3, 4, 5, 6 };

    // And here's a zero-terminated many-item pointer:
    const ptr: [*:0]u32 = &nums;

    // For fun, let's replace the value at position 3 with the
    // sentinel value 0. This seems kind of naughty.
    nums[3] = 0;

    // Así que ahora tenemos un array terminado en cero y un puntero de muchos elementos
    // que hacen referencia a los mismos datos: una secuencia de
    // números que termina en y CONTIENE el valor centinela.
    //
    // Intentar recorrer e imprimir ambos debería
    // demostrar cómo son similares y diferentes.
    //
    // (Resulta que el array se imprime completamente, incluyendo
    // el valor centinela 0 en medio. El puntero de muchos elementos se detiene
    // en el primer valor centinela.)
    printSequence(nums);
    printSequence(ptr);

    print("\n", .{});
}

// Aquí está nuestra función genérica de impresión de secuencias. Está casi
// completa, pero faltan un par de bits. ¡Por favor, arréglalos!
fn printSequence(my_seq: anytype) void {
    const my_typeinfo = @typeInfo(@TypeOf(my_seq));

    // El TypeInfo contenido en my_type es una unión. Usamos un
    // switch para manejar la impresión de los campos Array o Pointer,
    // dependiendo de qué tipo de my_seq se pasó:
    switch (my_typeinfo) {
        .Array => {
            print("Array:", .{});

            // Loop through the items in my_seq.
            for (my_seq) |s| {
                print("{}", .{s});
            }
        },
        .Pointer => {
            // Check this out - it's pretty cool:
            const my_sentinel = sentinel(@TypeOf(my_seq));
            print("Many-item pointer:", .{});

            // Loop through the items in my_seq until we hit the
            // sentinel value.
            var i: usize = 0;
            while (my_seq[i] != my_sentinel.?) {
                print("{}", .{my_seq[i]});
                i += 1;
            }
        },
        else => unreachable,
    }
    print(". ", .{});
}
