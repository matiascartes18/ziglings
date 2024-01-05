//
// Ha habido varias instancias en las que hubiera sido
// agradable usar bucles en nuestros programas, pero no pudimos porque las
// cosas que estábamos intentando hacer solo podían hacerse en tiempo de
// compilación. Terminamos teniendo que hacer esas cosas MANUALMENTE, como
// personas NORMALES. ¡Bah! ¡Somos PROGRAMADORES! El ordenador debería estar
// haciendo este trabajo.
//
// Un 'for inline' se realiza en tiempo de compilación, permitiéndote
// programar bucles a través de una serie de elementos en situaciones
// como las mencionadas anteriormente donde un bucle 'for' de tiempo de ejecución
// regular no estaría permitido:
//
//     inline for (.{ u8, u16, u32, u64 }) |T| {
//         print("{} ", .{@typeInfo(T).Int.bits});
//     }
//
// En el ejemplo anterior, estamos recorriendo una lista de tipos,
// que solo están disponibles en tiempo de compilación.
//
const print = @import("std").debug.print;

// Remember Narcissus from exercise 065 where we used builtins
// for reflection? He's back and loving it.
const Narcissus = struct {
    me: *Narcissus = undefined,
    myself: *Narcissus = undefined,
    echo: void = undefined,
};

pub fn main() void {
    print("Narcissus has room in his heart for:", .{});

    // La última vez que examinamos la estructura Narcissus, tuvimos que
    // acceder manualmente a cada uno de los tres campos. Nuestra sentencia 'if'
    // se repitió tres veces casi textualmente. ¡Qué asco!
    //
    // ¡Por favor, utiliza un 'for inline' para implementar el bloque de abajo
    // para cada campo en la lista 'fields'!

    const fields = @typeInfo(Narcissus).Struct.fields;
    inline for (fields) |field| {
        if (field.type != void) {
            print(" {s}", .{field.name});
        }
    }

    // Once you've got that, go back and take a look at exercise
    // 065 and compare what you've written to the abomination we
    // had there!

    print(".\n", .{});
}
