//
// También existe un 'while inline'. Al igual que 'for inline', este
// realiza bucles en tiempo de compilación, permitiéndote hacer todo tipo de
// cosas interesantes que no serían posibles en tiempo de ejecución. Intenta
// averiguar qué imprime este ejemplo bastante loco:
//
//     const foo = [3]*const [5]u8{ "~{s}~", "<{s}>", "d{s}b" };
//     comptime var i = 0;
//
//     inline while ( i < foo.len ) : (i += 1) {
//         print(foo[i] ++ "\n", .{foo[i]});
//     }
//
// ¿Todavía no te has quitado ese sombrero de mago, verdad?
//
const print = @import("std").debug.print;

pub fn main() void {
    // Here is a string containing a series of arithmetic
    // operations and single-digit decimal values. Let's call
    // each operation and digit pair an "instruction".
    const instructions = "+3 *5 -2 *2";

    // Here is a u32 variable that will keep track of our current
    // value in the program at runtime. It starts at 0, and we
    // will get the final value by performing the sequence of
    // instructions above.
    var value: u32 = 0;

    // This "index" variable will only be used at compile time in
    // our loop.
    comptime var i = 0;

    // Here we wish to loop over each "instruction" in the string
    // at compile time.
    //
    // Please fix this to loop once per "instruction":
    inline while (i < instructions.len) : (i += 3) {

        // Esto obtiene el dígito de la "instrucción". ¿Puedes
        // averiguar por qué restamos '0' de él?
        const digit = instructions[i + 1] - '0';
        //print("Digit: {}", .{digit});

        // This 'switch' statement contains the actual work done
        // at runtime. At first, this doesn't seem exciting...
        switch (instructions[i]) {
            '+' => value += digit,
            '-' => value -= digit,
            '*' => value *= digit,
            else => unreachable,
        }
        // ...Pero es mucho más emocionante de lo que parece a primera vista.
        // El 'while inline' ya no existe en tiempo de ejecución y tampoco
        // existe nada más que no esté directamente tocado por el código en tiempo de ejecución.
        // La cadena 'instructions', por ejemplo, no aparece en ningún lugar del programa compilado
        // porque no es utilizada por él!
        //
        // Así que, en un sentido muy real, este bucle realmente convierte
        // las instrucciones contenidas en una cadena en código de tiempo de ejecución
        // en tiempo de compilación. Supongo que ahora somos escritores de compiladores.
        // ¿Ves? El sombrero de mago estaba justificado después de todo.
    }

    print("{}\n", .{value});
}
