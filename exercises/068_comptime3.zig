//
// También puedes poner 'comptime' antes de un parámetro de función para
// exigir que el argumento pasado a la función debe ser conocido
// en tiempo de compilación. De hecho, hemos estado usando una función así
// todo el tiempo, std.debug.print():
//
//     fn print(comptime fmt: []const u8, args: anytype) void
//
// Observa que el parámetro de la cadena de formato 'fmt' está marcado como
// 'comptime'. Uno de los beneficios interesantes de esto es que la
// cadena de formato puede ser verificada en busca de errores en tiempo de compilación en lugar de
// fallar en tiempo de ejecución.
//
// (¡El formateo real es realizado por std.fmt.format() y contiene
// un analizador de cadenas de formato completo que se ejecuta completamente en
// tiempo de compilación!)
//
const print = @import("std").debug.print;

// This struct is the model of a model boat. We can transform it
// to any scale we would like: 1:2 is half-size, 1:32 is
// thirty-two times smaller than the real thing, and so forth.
const Schooner = struct {
    name: []const u8,
    scale: u32 = 1,
    hull_length: u32 = 143,
    bowsprit_length: u32 = 34,
    mainmast_height: u32 = 95,

    fn scaleMe(self: *Schooner, comptime scale: u32) void {
        comptime var my_scale = scale;

        // Hicimos algo ingenioso aquí: hemos anticipado la
        // posibilidad de intentar accidentalmente crear una
        // escala de 1:0. En lugar de tener esto resultando en un
        // error de división por cero en tiempo de ejecución, lo hemos convertido
        // en un error de compilación.
        //
        // Probablemente esta sea la solución correcta la mayoría de las
        // veces. Pero nuestro programa de modelado de barcos es muy informal
        // y solo queremos que "haga lo que quiero" y siga
        // funcionando.
        //
        // Por favor, cambia esto para que establezca una escala de 0 a 1
        // en su lugar.
        //if (my_scale == 0) @compileError("Scale 1:0 is not valid!");
        if (my_scale == 0) {
            my_scale = 1;
        }
        self.scale = my_scale;
        self.hull_length /= my_scale;
        self.bowsprit_length /= my_scale;
        self.mainmast_height /= my_scale;
    }

    fn printMe(self: Schooner) void {
        print("{s} (1:{}, {} x {})\n", .{
            self.name,
            self.scale,
            self.hull_length,
            self.mainmast_height,
        });
    }
};

pub fn main() void {
    var whale = Schooner{ .name = "Whale" };
    var shark = Schooner{ .name = "Shark" };
    var minnow = Schooner{ .name = "Minnow" };

    // Hey, we can't just pass this runtime variable as an
    // argument to the scaleMe() method. What would let us do
    // that?
    comptime var scale: u32 = undefined;

    scale = 32; // 1:32 scale

    minnow.scaleMe(scale);
    minnow.printMe();

    scale -= 16; // 1:16 scale

    shark.scaleMe(scale);
    shark.printMe();

    scale -= 16; // 1:0 scale (oops, but DON'T FIX THIS!)

    whale.scaleMe(scale);
    whale.printMe();
}
//
// Profundizando:
//
// ¿Qué sucedería si intentaras construir un modelo a escala 1:0?
//
//    A) ¡Ya has terminado!
//    B) Sufrirías un error mental de división por cero.
//    C) Construirías una singularidad y destruirías el
//       planeta.
//
// ¿Y qué tal un modelo a escala 0:1?
//
//    A) ¡Ya has terminado!
//    B) Organizarías cuidadosamente la nada en la forma del
//       nada original pero infinitamente más grande.
//    C) Construirías una singularidad y destruirías el
//       planeta.
//
// Las respuestas se pueden encontrar en la parte posterior del empaque de Ziglings.
