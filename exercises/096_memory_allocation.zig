//
// En la mayoría de los ejemplos hasta ahora, las entradas se conocen en tiempo de compilación,
// por lo tanto, la cantidad de memoria utilizada por el programa es fija.
// Sin embargo, si se responde a una entrada cuyo tamaño no se conoce en tiempo de compilación,
// como:
//  - entrada del usuario a través de argumentos de línea de comandos
//  - entradas de otro programa
//
// Necesitarás solicitar memoria para que tu programa sea asignado por
// tu sistema operativo en tiempo de ejecución.
//
// Zig proporciona varios asignadores diferentes. En la documentación de Zig,
// se recomienda el asignador Arena para programas simples que asignan una vez y luego salen:
//
//     const std = @import("std");
//
//     // la asignación de memoria puede fallar, por lo que el tipo de retorno es !void
//     pub fn main() !void {
//
//         var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//         defer arena.deinit();
//
//         const allocator = arena.allocator();
//
//         const ptr = try allocator.create(i32);
//         std.debug.print("ptr={*}\n", .{ptr});
//
//         const slice_ptr = try allocator.alloc(f64, 5);
//         std.debug.print("slice_ptr={*}\n", .{slice_ptr});
//     }

// En lugar de un simple entero o una porción de tamaño constante, este
// programa requiere que se asigne una porción que tenga el mismo tamaño que
// una matriz de entrada.

// Dada una serie de números, toma el promedio acumulativo. En otras
// palabras, cada elemento N debe contener el promedio de los últimos N
// elementos.

const std = @import("std");

fn runningAverage(arr: []const f64, avg: []f64) void {
    var sum: f64 = 0;

    for (0.., arr) |index, val| {
        sum += val;
        const f_index: f64 = @floatFromInt(index + 1);
        avg[index] = sum / f_index;
    }
}

pub fn main() !void {
    // pretend this was defined by reading in user input
    const arr: []const f64 = &[_]f64{ 0.3, 0.2, 0.1, 0.1, 0.4 };

    // initialize the allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    // free the memory on exit
    defer arena.deinit();

    // initialize the allocator
    const allocator = arena.allocator();

    // allocate memory for this array
    const avg: []f64 = try allocator.alloc(f64, arr.len);

    runningAverage(arr, avg);
    std.debug.print("Running Average: ", .{});
    for (avg) |val| {
        std.debug.print("{d:.2} ", .{val});
    }
    std.debug.print("\n", .{});
}

// For more details on memory allocation and the different types of
// memory allocators, see https://www.youtube.com/watch?v=vHWiDx_l4V0
