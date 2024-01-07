//
// Un LITERAL de valor de estructura anónima (no confundir con un
// TIPO de estructura) usa la sintaxis '.{}':
//
//     .{
//          .center_x = 15,
//          .center_y = 12,
//          .radius = 6,
//     }
//
// Estos literales siempre se evalúan completamente en tiempo de compilación.
// El ejemplo anterior podría ser convertido en la variante i32 de la
// "estructura de círculo" del último ejercicio.
//
// O puedes dejarlos completamente anónimos como en este
// ejemplo:
//
//     fn bar(foo: anytype) void {
//         print("a:{} b:{}\n", .{foo.a, foo.b});
//     }
//
//     bar(.{
//         .a = true,
//         .b = false,
//     });
//
// El ejemplo anterior imprime "a:true b:false".
//
const print = @import("std").debug.print;

pub fn main() void {
    printCircle(.{
        .center_x = @as(u32, 205),
        .center_y = @as(u32, 187),
        .radius = @as(u32, 12),
    });
}

// Please complete this function which prints an anonymous struct
// representing a circle.
fn printCircle(circle: anytype) void {
    print("x:{} y:{} radius:{}\n", .{
        circle.center_x,
        circle.center_y,
        circle.radius,
    });
}
