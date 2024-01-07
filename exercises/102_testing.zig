//
// Una gran ventaja de Zig es la integración de su propio sistema de pruebas.
// Esto permite que la filosofía del Desarrollo Guiado por Pruebas (TDD) se pueda
// implementar perfectamente. Zig incluso va un paso más allá que otros
// lenguajes, las pruebas se pueden incluir directamente en el archivo fuente.
//
// Esto tiene varias ventajas. Por un lado, es mucho más claro tener
// todo en un solo archivo, tanto el código fuente como el código de prueba asociado.
// Por otro lado, es mucho más fácil para terceros entender qué se supone
// que debe hacer exactamente una función si pueden simplemente mirar la prueba
// dentro del código fuente y comparar ambos.
//
// Especialmente si quieres entender cómo funciona, por ejemplo, la biblioteca estándar
// de Zig, este enfoque es muy útil. Además, es muy práctico, si quieres
// reportar un error a la comunidad de Zig, ilustrarlo con un pequeño ejemplo
// que incluya una prueba.
//
// Por lo tanto, en este ejercicio nos ocuparemos de los fundamentos de las pruebas
// en Zig. Básicamente, las pruebas funcionan de la siguiente manera: pasas ciertos parámetros
// a una función, para la cual obtienes un retorno - el resultado. Esto se compara
// con el valor ESPERADO. Si ambos valores coinciden, la prueba se pasa,
// de lo contrario se muestra un mensaje de error.
//
//          testing.expect(foo(param1, param2) == expected);
//
// También son posibles otras comparaciones, se pueden provocar desviaciones o errores,
// los cuales deben llevar a un comportamiento apropiado de la función,
// para que la prueba se pase.
//
// Las pruebas se pueden ejecutar a través del sistema de construcción de Zig o aplicarse directamente a
// módulos individuales usando "zig test xyz.zig".
//
// Ambos se pueden usar de forma scriptada para ejecutar pruebas automáticamente, por ejemplo,
// después de hacer un commit en un repositorio Git. Algo que también usamos extensivamente
// aquí en Ziglings.
//
const std = @import("std");
const testing = std.testing;

// This is a simple function
// that builds a sum from the
// passed parameters and returns.
fn add(a: f16, b: f16) f16 {
    return a + b;
}

// The associated test.
// It always starts with the keyword "test",
// followed by a description of the tasks
// of the test. This is followed by the
// test cases in curly brackets.
test "add" {

    // The first test checks if the sum
    // of '41' and '1' gives '42', which
    // is correct.
    try testing.expect(add(41, 1) == 42);

    // Another way to perform this test
    // is as follows:
    try testing.expectEqual(add(41, 1), 42);

    // This time a test with the addition
    // of a negative number:
    try testing.expect(add(5, -4) == 1);

    // And a floating point operation:
    try testing.expect(add(1.5, 1.5) == 3);
}

// Another simple function
// that returns the result
// of subtracting the two
// parameters.
fn sub(a: f16, b: f16) f16 {
    return a - b;
}

// The corresponding test
// is not much different
// from the previous one.
// Except that it contains
// an error that you need
// to correct.
test "sub" {
    try testing.expect(sub(11, 5) == 6);

    try testing.expect(sub(3, 1.5) == 1.5);
}

// This function divides the
// numerator by the denominator.
// Here it is important that the
// denominator must not be zero.
// This is checked and if it
// occurs an error is returned.
fn divide(a: f16, b: f16) !f16 {
    if (b == 0) return error.DivisionByZero;
    return a / b;
}

test "divide" {
    try testing.expect(divide(2, 2) catch unreachable == 1);
    try testing.expect(divide(-1, -1) catch unreachable == 1);
    try testing.expect(divide(10, 2) catch unreachable == 5);
    try testing.expect(divide(1, 3) catch unreachable == 0.3333333333333333);
    try testing.expect(try divide(5, 5) == 1);

    // Now we test if the function returns an error
    // if we pass a zero as denominator.
    // But which error needs to be tested?
    try testing.expectError(error.DivisionByZero, divide(15, 0));
}
