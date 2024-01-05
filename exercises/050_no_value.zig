//
//    "Vivimos en una isla plácida de ignorancia en medio
//     de mares negros de infinitud, y no estaba destinado
//     que viajáramos lejos."
//
//     de La Llamada de Cthulhu
//       por H. P. Lovecraft
//
// Zig tiene al menos cuatro formas de expresar "sin valor":
//
// * undefined (indefinido)
//
//       var foo: u8 = undefined;
//
//       "undefined" no debe considerarse como un valor, sino como una forma
//       de decirle al compilador que aún no estás asignando un valor.
//       Cualquier tipo puede ser definido como undefined, pero intentar
//       leer o usar ese valor siempre es un error.
//
// * null (nulo)
//
//       var foo: ?u8 = null;
//
//       El valor primitivo "null" es un valor que significa "sin valor".
//       Esto se utiliza típicamente con tipos opcionales como ?u8
//       mostrado arriba. Cuando foo es igual a null, no es un valor del tipo
//       u8. ¡Significa que no hay ningún valor del tipo u8 en foo en absoluto!
//
// * error (error)
//
//       var foo: MyError!u8 = BadError;
//
//       Los errores son muy similares a los nulos. Son un valor, pero
//       generalmente indican que el "valor real" que estabas buscando
//       no existe. En su lugar, tienes un error. El ejemplo de tipo de
//       unión de error MyError!u8 significa que foo contiene un valor
//       u8 o un error. ¡No hay ningún valor del tipo u8 en foo cuando
//       está configurado como un error!
//
// * void (vacío)
//
//       var foo: void = {};
//
//       "void" es un _tipo_, no un valor. Es el más popular de los
//       Tipos de Cero Bits (esos tipos que no ocupan espacio en absoluto
//       y solo tienen un valor semántico). Cuando se compila a código
//       ejecutable, los tipos de cero bits no generan ningún código en absoluto.
//       El ejemplo anterior muestra una variable foo de tipo void que se
//       le asigna el valor de una expresión vacía. Es mucho más común ver
//       void como el tipo de retorno de una función que no devuelve nada.
//
// Zig tiene todas estas formas de expresar diferentes tipos de "sin valor"
// porque cada una tiene un propósito. En resumen:
//
//   * undefined (indefinido) - no hay valor TODAVÍA, esto no se puede leer TODAVÍA
//   * null (nulo)            - hay un valor explícito de "sin valor"
//   * error (error)          - no hay valor porque algo salió mal
//   * void (vacío)           - NUNCA habrá un valor almacenado aquí
//
// Por favor, utiliza el "sin valor" correcto para cada ??? para que este programa
// imprima una cita maldita del Necronomicón. ...Si te atreves.
//
const std = @import("std");

const Err = error{Cthulhu};

pub fn main() void {
    var first_line1: *const [16]u8 = undefined;
    first_line1 = "That is not dead";

    var first_line2: Err!*const [21]u8 = Err.Cthulhu;
    first_line2 = "which can eternal lie";

    // Note we need the "{!s}" format for the error union string.
    std.debug.print("{s} {!s} / ", .{ first_line1, first_line2 });

    printSecondLine();
}

fn printSecondLine() void {
    var second_line2: ?*const [18]u8 = null;
    second_line2 = "even death may die";

    std.debug.print("And with strange aeons {s}.\n", .{second_line2.?});
}
