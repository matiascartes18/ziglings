//
// La manipulación de bits es una herramienta muy poderosa también en Zig.
// Desde el amanecer de la era de la computación, se han desarrollado numerosos algoritmos que
// resuelven tareas únicamente moviendo, estableciendo o combinando lógicamente bits.
//
// Zig también utiliza la manipulación directa de bits en su biblioteca estándar para
// funciones donde es posible. Y a menudo es posible con cálculos
// basados en enteros.
//
// A menudo no es fácil entender a primera vista qué es exactamente lo que estos
// algoritmos hacen cuando solo cambian "números" en áreas de memoria externas.
// Pero nunca se debe olvidar que los números solo representan la
// interpretación de las secuencias de bits.
//
// Quasi el caso inverso que tenemos de otra manera, es decir, que representamos
// números en secuencias de bits.
//
// Recordamos: 1 byte = 8 bits = 11111111 = 255 decimal = FF hex.
//
// Zig proporciona todas las funciones necesarias para cambiar los bits dentro
// de una variable. Se distingue si el cambio de bit conduce a un
// desbordamiento o no. Los detalles están en la documentación de Zig en la sección
// 10.1 "Tabla de Operadores".
//
// Aquí hay algunos ejemplos de cómo se pueden cambiar los bits de las variables:
//
//          const numOne: u8 = 15;        //   =  0000 1111
//          const numTwo: u8 = 245;       //   =  1111 0101
//
//          const res1 = numOne >> 4;     //   =  0000 0000 - desplazamiento a la derecha
//          const res2 = numOne << 4;     //   =  1111 0000 - desplazamiento a la izquierda
//          const res3 = numOne & numTwo; //   =  0000 0101 - y
//          const res4 = numOne | numTwo; //   =  1111 1111 - o
//          const res5 = numOne ^ numTwo; //   =  1111 1010 - xor
//
//
// Para familiarizarnos con la manipulación de bits, comenzamos con una simple
// pero a menudo subestimada función y luego agregamos otros ejercicios en
// orden suelto.
//
// El siguiente texto contiene extractos de Wikipedia.
//
// Intercambio
// En la programación de computadoras, el acto de intercambiar dos variables se refiere a
// intercambiar mutuamente los valores de las variables. Por lo general, esto se
// hace con los datos en memoria. Por ejemplo, en un programa, dos variables
// pueden ser definidas así (en pseudocódigo):
//
//                        data_item x := 1
//                        data_item y := 0
//
//                        swap (x, y);
//
// Después de que se realiza swap(), x contendrá el valor 0 y y
// contendrá 1; sus valores han sido intercambiados. El método más simple y probablemente
// más utilizado para intercambiar dos variables es usar una tercera variable temporal:
//
//                        define swap (x, y)
//                        temp := x
//                        x := y
//                        y := temp
//
// Sin embargo, con enteros también podemos lograr la función de intercambio simplemente por
// manipulación de bits. Para hacer esto, las variables se vinculan mutuamente con xor
// y el resultado es el mismo.
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {

    // As in the example above, we use 1 and 0 as values for x and y
    var x: u8 = 1;
    var y: u8 = 0;

    // Now we swap the values of the two variables by doing xor on them
    x ^= y;
    y ^= x;

    // What must be written here?
    x ^= y;
    y ^= x;

    print("x = {d}; y = {d}\n", .{ x, y });
}

// Esta variable de intercambio aprovecha el hecho de que el valor resultante
// del xor de dos valores contiene ambos valores.
// Esta circunstancia fue (y todavía es) a veces utilizada para el cifrado.
// Valor XOR Clave = Cripto. => Cripto XOR Clave = Valor.
// Dado que esto se puede intercambiar de manera arbitraria, puedes intercambiar dos variables de esta manera.
//
// Para Cripto es mejor no usar esto, pero en algoritmos de ordenación como
// Bubble Sort funciona muy bien.
