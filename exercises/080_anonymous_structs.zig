//
// Los tipos de estructura son siempre "anónimos" hasta que les damos un nombre:
//
//     struct {};
//
// Hasta ahora, hemos estado dando a los tipos de estructura un nombre de esta manera:
//
//     const Foo = struct {};
//
// * El valor de @typeName(Foo) es "<nombre_del_archivo>.Foo".
//
// A una estructura también se le da un nombre cuando la devuelves desde una
// función:
//
//     fn Bar() type {
//         return struct {};
//     }
//
//     const MyBar = Bar();  // almacenar el tipo de estructura
//     const bar = Bar() {}; // crear una instancia de la estructura
//
// * El valor de @typeName(Bar()) es "Bar()".
// * El valor de @typeName(MyBar) es "Bar()".
// * El valor de @typeName(@TypeOf(bar)) es "Bar()".
//
// También puedes tener estructuras completamente anónimas. El valor
// de @typeName(struct {}) es "struct:<posición en el código fuente>".
//
const print = @import("std").debug.print;

// This function creates a generic data structure by returning an
// anonymous struct type (which will no longer be anonymous AFTER
// it's returned from the function).
fn Circle(comptime T: type) type {
    return struct {
        center_x: T,
        center_y: T,
        radius: T,
    };
}

pub fn main() void {
    //
    // See if you can complete these two variable initialization
    // expressions to create instances of circle struct types
    // which can hold these values:
    //
    // * circle1 should hold i32 integers
    // * circle2 should hold f32 floats
    //
    const circle1 = Circle(i32) {
        .center_x = 25,
        .center_y = 70,
        .radius = 15,
    };

    const circle2 = Circle(f32) {
        .center_x = 25.234,
        .center_y = 70.999,
        .radius = 15.714,
    };

    print("[{s}: {},{},{}] ", .{
        stripFname(@typeName(@TypeOf(circle1))),
        circle1.center_x,
        circle1.center_y,
        circle1.radius,
    });

    print("[{s}: {d:.1},{d:.1},{d:.1}]\n", .{
        stripFname(@typeName(@TypeOf(circle2))),
        circle2.center_x,
        circle2.center_y,
        circle2.radius,
    });
}

// ¿Quizás recuerdas la "solución narcisista" para el nombre del tipo
// en el Ej. 065? Vamos a hacer lo mismo aquí: usar un slice codificado
// para devolver el nombre del tipo. Eso es solo para que nuestra salida
// se vea más bonita. Complace tu vanidad. Los programadores son hermosos.
fn stripFname(mytype: []const u8) []const u8 {
    return mytype[22..];
}
// The above would be an instant red flag in a "real" program.
