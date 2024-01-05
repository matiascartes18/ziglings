//
// Zig tiene funciones integradas para operaciones matemáticas como...
//
//      @sqrt        @sin           @cos
//      @exp         @log           @floor
//
// ...y muchas operaciones de conversión de tipos como...
//
//      @as          @errorFromInt  @floatFromInt
//      @ptrFromInt  @intFromPtr    @intFromEnum
//
// Pasar parte de un día lluvioso revisando la lista completa de funciones integradas en la documentación oficial de Zig no sería una mala manera de pasar el tiempo. Hay algunas características realmente geniales allí. ¡Echa un vistazo a @call, @compileLog, @embedFile y @src!
//
//                            ...
//
// Por ahora, vamos a completar nuestra exploración de las funciones integradas explorando solo TRES de las MUCHAS capacidades de introspección de Zig:
//
// 1. @This() type
//
// Devuelve la estructura, enumeración o unión más interna en la que se encuentra una llamada a función.
//
// 2. @typeInfo(comptime T: type) @import("std").builtin.Type
//
// Devuelve información sobre cualquier tipo en una estructura de datos que contendrá información diferente dependiendo del tipo que estés examinando.
//
// 3. @TypeOf(...) type
//
// Devuelve el tipo común a todos los parámetros de entrada (cada uno de los cuales puede ser cualquier expresión). El tipo se resuelve utilizando el mismo proceso de "resolución de tipo entre pares" que el compilador mismo utiliza al inferir tipos.
//
// (¿Notaste cómo las dos funciones que devuelven tipos comienzan con letras mayúsculas? Esta es una práctica de nomenclatura estándar en Zig.)
//
const print = @import("std").debug.print;

const Narcissus = struct {
    me: *Narcissus = undefined,
    myself: *Narcissus = undefined,
    echo: void = undefined, // Alas, poor Echo!



    fn fetchTheMostBeautifulType() type {
        return @This();
    }
};

pub fn main() void {
    var narcissus: Narcissus = Narcissus{};

    // Oops! We cannot leave the 'me' and 'myself' fields
    // undefined. Please set them here:
    narcissus.me = &narcissus;
    narcissus.myself = &narcissus;

    // Esto determina un "tipo par" a partir de tres referencias separadas
    // (que casualmente son el mismo objeto).
    const Type1 = @TypeOf( narcissus, narcissus.me.*, narcissus.myself.* );

    // Oh vaya, parece que hemos hecho algo mal al llamar
    // a esta función. La llamamos como un método, lo cual funcionaría
    // si tuviera un parámetro self. Pero no lo tiene. (Ver arriba.)
    //
    // La solución para esto es muy sutil, ¡pero hace una gran
    // diferencia!
    const Type2 = Narcissus.fetchTheMostBeautifulType();

    // Now we print a pithy statement about Narcissus.
    print("A {s} loves all {s}es. ", .{
        maximumNarcissism(Type1),
        maximumNarcissism(Type2),
    });

    //   His final words as he was looking in
    //   those waters he habitually watched
    //   were these:
    //       "Alas, my beloved boy, in vain!"
    //   The place gave every word back in reply.
    //   He cried:
    //            "Farewell."
    //   And Echo called:
    //                   "Farewell!"
    //
    //     --Ovid, The Metamorphoses
    //       translated by Ian Johnston

    print("He has room in his heart for:", .{});

    // A StructFields array
    const fields = @typeInfo(Narcissus).Struct.fields;

    // 'fields' is a slice of StructFields. Here's the declaration:
    //
    //     pub const StructField = struct {
    //         name: []const u8,
    //         type: type,
    //         default_value: anytype,
    //         is_comptime: bool,
    //         alignment: comptime_int,
    //     };
    //
    // Please complete these 'if' statements so that the field
    // name will not be printed if the field is of type 'void'
    // (which is a zero-bit type that takes up no space at all!):
    if (fields[0].type != void) {
        print(" {s}", .{@typeInfo(Narcissus).Struct.fields[0].name});
    }

    if (fields[1].type != void) {
        print(" {s}", .{@typeInfo(Narcissus).Struct.fields[1].name});
    }

    if (fields[2].type != void) {
        print(" {s}", .{@typeInfo(Narcissus).Struct.fields[2].name});
    }

    // Yuck, look at all that repeated code above! I don't know
    // about you, but it makes me itchy.
    //
    // Alas, we can't use a regular 'for' loop here because
    // 'fields' can only be evaluated at compile time.  It seems
    // like we're overdue to learn about this "comptime" stuff,
    // doesn't it? Don't worry, we'll get there.

    print(".\n", .{});
}

// NOTE: Este ejercicio no incluyó originalmente la función de abajo.
// Pero un cambio después de Zig 0.10.0 añadió el nombre del archivo fuente al
// tipo. "Narcissus" se convirtió en "065_builtins2.Narcissus".
//
// Para solucionar esto, he añadido esta función para eliminar el nombre del archivo
// del principio del nombre del tipo de la manera más tonta posible. (Devuelve
// un slice del nombre del tipo comenzando en el carácter 14 (asumiendo
// caracteres de un solo byte).
//
// Veremos @typeName de nuevo en el Ejercicio 070. Por ahora, puedes
// ver que toma un Tipo y devuelve una "cadena" u8.
fn maximumNarcissism(myType: anytype) []const u8 {
    // Turn '065_builtins2.Narcissus' into 'Narcissus'
    return @typeName(myType)[14..];
}
