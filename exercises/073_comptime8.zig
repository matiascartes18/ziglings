//
// De hecho, puedes poner 'comptime' delante de cualquier
// expresión para forzar su ejecución en tiempo de compilación.
//
// Ejecutar una función:
//
//     comptime llama();
//
// Obtener un valor:
//
//     bar = comptime baz();
//
// Ejecutar un bloque completo:
//
//     comptime {
//         bar = baz + biff();
//         llama(bar);
//     }
//
// Obtener un valor de un bloque:
//
//     var llama = comptime bar: {
//         const baz = biff() + bonk();
//         break :bar baz;
//     }
//
const print = @import("std").debug.print;

const llama_count = 5;
const llamas = [llama_count]u32{ 5, 10, 15, 20, 25 };

pub fn main() void {
    // We meant to fetch the last llama. Please fix this simple
    // mistake so the assertion no longer fails.
    const my_llama = getLlama(4);

    print("My llama value is {}.\n", .{my_llama});
}

fn getLlama(comptime i: usize) u32 {
    // Hemos puesto un assert() de guardia al principio de esta función para
    // prevenir errores. La palabra clave 'comptime' aquí significa que
    // el error será detectado cuando compilamos!
    //
    // Sin 'comptime', esto todavía funcionaría, pero la
    // afirmación fallaría en tiempo de ejecución con un PANIC, y eso no es
    // tan agradable.
    //
    // Desafortunadamente, vamos a obtener un error ahora mismo
    // porque se necesita garantizar que el parámetro 'i' se conozca
    // en tiempo de compilación. ¿Qué puedes hacer con el parámetro 'i'
    // arriba para que esto sea así?
    comptime assert(i < llama_count);

    return llamas[i];
}

// Fun fact: this assert() function is identical to
// std.debug.assert() from the Zig Standard Library.
fn assert(ok: bool) void {
    if (!ok) unreachable;
}
//
// Bonus fun fact: I accidentally replaced all instances of 'foo'
// with 'llama' in this exercise and I have no regrets!
