//
// A veces sabes que una variable puede contener un valor o no.
// Zig tiene una forma interesante de expresar esta idea llamada Optionals.
// Un tipo opcional simplemente tiene un '?' así:
//
//     var foo: ?u32 = 10;
//
// Ahora foo puede almacenar un entero u32 O null (un valor que representa
// el horror cósmico de que el valor NO EXISTA).
//
//     foo = null;
//
//     if (foo == null) comenzarAgritar();
//
// Antes de poder usar el valor opcional como el tipo no nulo
// (un entero u32 en este caso), necesitamos garantizar que no sea null.
// Una forma de hacer esto es AMENAZARLO con la declaración "orelse".
//
//     var bar = foo orelse 2;
//
// Aquí, bar será igual al valor entero u32 almacenado en foo,
// o será igual a 2 si foo era null.
//
const std = @import("std");

pub fn main() void {
    const result = deepThought();

    // Please threaten the result so that answer is either the
    // integer value from deepThought() OR the number 42:
    const answer: u8 = result orelse 42;

    std.debug.print("The Ultimate Answer: {}.\n", .{answer});
}

fn deepThought() ?u8 {
    // It seems Deep Thought's output has declined in quality.
    // But we'll leave this as-is. Sorry Deep Thought.
    return null;
}
// Blast from the past:
//
// Optionals are a lot like error union types which can either
// hold a value or an error. Likewise, the orelse statement is
// like the catch statement used to "unwrap" a value or supply
// a default value:
//
//    var maybe_bad: Error!u32 = Error.Evil;
//    var number: u32 = maybe_bad catch 0;
//
