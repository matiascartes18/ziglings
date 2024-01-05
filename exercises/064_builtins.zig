//
// El compilador Zig proporciona funciones "builtin". Ya te has acostumbrado a ver una instrucción @import() en la parte superior de cada ejercicio de Ziglings.
//
// También hemos visto @intCast() en "016_for2.zig", "058_quiz7.zig"; y @intFromEnum() en "036_enums2.zig".
//
// Los builtins son especiales porque son intrínsecos al propio lenguaje Zig (en contraposición a ser proporcionados en la biblioteca estándar). También son especiales porque pueden proporcionar funcionalidades que solo son posibles con la ayuda del compilador, como la introspección de tipos (la capacidad de examinar las propiedades de un tipo desde dentro de un programa).
//
// Zig contiene más de 100 funciones builtin. Ciertamente no vamos a cubrir todas, pero podemos ver algunas interesantes.
//
// Antes de comenzar, debes saber que muchas funciones builtin tienen parámetros marcados como "comptime". Probablemente esté bastante claro lo que queremos decir cuando decimos que estos parámetros deben ser "conocidos en tiempo de compilación". Pero no te preocupes, pronto abordaremos el tema de "comptime" de manera adecuada.
//
const print = @import("std").debug.print;

pub fn main() void {
    // El segundo builtin, en orden alfabético, es:
    //   @addWithOverflow(a: anytype, b: anytype) struct { @TypeOf(a, b), u1 }
    //     * 'a' y 'b' son números de cualquier tipo.
    //     * El valor de retorno es una tupla con el resultado y un posible bit de desbordamiento.
    //
    // Vamos a probarlo con un tamaño de entero de 4 bits para que quede claro:
    const a: u4 = 0b1101;
    const b: u4 = 0b0101;
    const my_result = @addWithOverflow(a, b);

    // ¡Mira nuestro formato elegante! b:0>4 significa "imprimir
    // como un número binario, rellenar con ceros a la derecha y alinear a la derecha en cuatro dígitos".
    // La llamada a print() a continuación producirá: "1101 + 0101 = 0010 (true)".
    print("{b:0>4} + {b:0>4} = {b:0>4} ({s})", .{ a, b, my_result[0], if (my_result[1] == 1) "true" else "false" });

    // Let's make sense of this answer. The value of 'b' in decimal is 5.
    // Let's add 5 to 'a' but go one by one and see where it overflows:
    //
    //   a  |  b   | result | overflowed?
    // ----------------------------------
    // 1101 + 0001 =  1110  | false
    // 1110 + 0001 =  1111  | false
    // 1111 + 0001 =  0000  | true  (the real answer is 10000)
    // 0000 + 0001 =  0001  | false
    // 0001 + 0001 =  0010  | false
    //
    // In the last two lines the value of 'a' is corrupted because there was
    // an overflow in line 3, but the operations of lines 4 and 5 themselves
    // do not overflow.
    // There is a difference between
    //  - a value, that overflowed at some point and is now corrupted
    //  - a single operation that overflows and maybe causes subsequent errors
    // In practice we usually notice the overflowed value first and have to work
    // our way backwards to the operation that caused the overflow.
    //
    // If there was no overflow at all while adding 5 to a, what value would
    // 'my_result' hold? Write the answer in into 'expected_result'.
    const expected_result: u8 = 0b10010;
    print(". Without overflow: {b:0>8}. ", .{expected_result});

    print("Furthermore, ", .{});

    // Here's a fun one:
    //
    //   @bitReverse(integer: anytype) T
    //     * 'integer' is the value to reverse.
    //     * The return value will be the same type with the
    //       value's bits reversed!
    //
    // Now it's your turn. See if you can fix this attempt to use
    // this builtin to reverse the bits of a u8 integer.
    const input: u8 = 0b11110000;
    const tupni: u8 = @bitReverse(input);
    print("{b:0>8} backwards is {b:0>8}.\n", .{ input, tupni });
}
