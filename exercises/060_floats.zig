//
// Zig tiene soporte para números de punto flotante IEEE-754 en estos tamaños específicos: f16, f32, f64, f80 y f128. Los literales de punto flotante se pueden escribir de la misma manera que los enteros, pero también en notación científica:
//
//     const a1: f32 = 1200;       //    1,200
//     const a2: f32 = 1.2e+3;     //    1,200
//     const b1: f32 = -500_000.0; // -500,000
//     const b2: f32 = -5.0e+5;    // -500,000
//
// Los flotantes hexadecimales no pueden usar la letra 'e' porque es un dígito hexadecimal, así que usamos una 'p' en su lugar:
//
//     const hex: f16 = 0x2A.F7p+3; // ¡Vaya, eso es arcano!
//
// Asegúrate de usar un tipo de flotante que sea lo suficientemente grande para almacenar tu valor (tanto en términos de dígitos significativos como de escala). El redondeo puede ser aceptable o no, ¡pero los números que son demasiado grandes o demasiado pequeños se convierten en inf o -inf (infinito positivo o negativo)!
//
//     const pi: f16 = 3.1415926535;   // se redondea a 3.140625
//     const av: f16 = 6.02214076e+23; // ¡El infinito de Avogadro!
//
// Al realizar operaciones matemáticas con literales numéricos, asegúrate de que los tipos coincidan. Zig no realiza coerciones de tipo inseguras a tus espaldas:
//
//    var foo: f16 = 5; // SIN ERROR
//
//    var foo: u16 = 5; // Un literal de un tipo diferente
//    var bar: f16 = foo; // ERROR
//
// Por favor, soluciona los dos problemas de punto flotante con este programa y muestra el resultado como un número entero.

const print = @import("std").debug.print;

pub fn main() void {
    // The approximate weight of the Space Shuttle upon liftoff
    // (including boosters and fuel tank) was 4,480,000 lb.
    //
    // We'll convert this weight from pound to kilograms at a
    // conversion of 0.453592kg to the pound.
    const shuttle_weight: f32 = 0.453592 * 4480e3;

    // By default, float values are formatted in scientific
    // notation. Try experimenting with '{d}' and '{d:.3}' to see
    // how decimal formatting works.
    print("Shuttle liftoff weight: {d:.0}kg\n", .{shuttle_weight});
}

// Flotando más lejos:
//
// Como ejemplo, el tipo f16 de Zig es un formato de punto flotante binario de precisión media IEEE 754 ("binary16"), que se almacena en memoria de la siguiente manera:
//
//         0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 0
//         | |-------| |-----------------|
//         |  exponente     significancia
//         |
//          signo
//
// Este ejemplo es el número decimal 3.140625, que es la representación más cercana de Pi que podemos hacer con un f16 debido a la forma en que los puntos flotantes IEEE-754 almacenan los dígitos:
//
//   * El bit de signo 0 hace que el número sea positivo.
//   * Los bits del exponente 10000 son una escala de 16.
//   * Los bits de la mantisa 1001001000 son el valor decimal 584.
//
// IEEE-754 ahorra espacio modificando estos valores: siempre se resta el valor 01111 de los bits del exponente (en nuestro caso, 10000 - 01111 = 1, por lo que nuestro exponente es 2^1) y nuestros dígitos de la mantisa se convierten en el valor decimal _después_ de un 1 implícito (por lo que 1.1001001000 o 1.5703125 en decimal). Esto nos da:
//
//     2^1 * 1.5703125 = 3.140625
//
// Siéntete libre de olvidar estos detalles de implementación de inmediato. Lo importante es saber que los números de punto flotante son excelentes para almacenar valores grandes y pequeños (f64 te permite trabajar con números en la escala del número de átomos en el universo), pero los dígitos pueden redondearse, lo que lleva a resultados menos precisos que los enteros.
//
// Dato curioso: a veces verás que la mantisa se etiqueta como "mantisa", pero Donald E. Knuth dice que no se debe hacer eso.
//
// Dato de compatibilidad con C: también hay un tipo de punto flotante en Zig específicamente para trabajar con ABI de C llamado c_longdouble.
