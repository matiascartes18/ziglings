//
// Si pensaste que el ejercicio anterior fue un análisis profundo, agárrate fuerte porque estamos a punto de descender al núcleo fundido de la computadora.
//
// (Gritando) AQUÍ ABAJO, LOS BITS Y BYTES FLUYEN DESDE LA MEMORIA RAM HACIA LA CPU COMO UN FLUIDO CALIENTE Y DENSO. LAS FUERZAS SON INCREÍBLES. PERO ¿CÓMO SE RELACIONA TODO  ESTO CON LOS DATOS EN NUESTROS PROGRAMAS ZIG? VOLVAMOS AL EDITOR DE TEXTO Y DESCUBRAMOSLO.
//
// Ah, eso es mejor. Ahora podemos ver algo de código Zig familiar.
//
// @import() agrega el código importado a tu propio código. En este caso, se agrega código de la biblioteca estándar a tu programa y se compila con él. Todo esto se cargará en la memoria RAM cuando se ejecute. ¡Ah, y esa cosa que llamamos "const std"? ¡Eso es una estructura!
//
const std = @import("std");

/// Este archivo contiene la implementación de una estructura de personaje de RPG.
/// La estructura representa un personaje en un juego de rol y contiene
/// campos para oro, salud y experiencia. La estructura es una forma conveniente
/// de manejar la memoria, ya que los campos son todos valores de un tamaño particular.
/// Al sumarlos, obtenemos el tamaño de la estructura en su conjunto.
// ¿Recuerdas nuestra antigua estructura de personaje de RPG? Una estructura es realmente solo una forma muy conveniente de manejar la memoria. Estos campos (oro, salud, experiencia) son todos valores de un tamaño particular. Al sumarlos, obtienes el tamaño de la estructura en su conjunto.

const Character = struct {
    gold: u32 = 0,
    health: u8 = 100,
    experience: u32 = 0,
};

// Aquí creamos un personaje llamado "the_narrator" que es una instancia constante (inmutable) de una estructura Character. Se almacena en tu programa como datos y, al igual que el código de instrucciones, se carga en la RAM cuando se ejecuta tu programa. La ubicación relativa de estos datos en la memoria está codificada y ni la dirección ni el valor cambian.

const the_narrator = Character{
    .gold = 12,
    .health = 99,
    .experience = 9000,
};

// Este personaje "global_wizard" es muy similar. La dirección de
// estos datos no cambiará, pero los datos en sí pueden cambiar ya que esto es una variable
// y no una constante.

var global_wizard = Character{};

// Una función es código de instrucciones en una dirección específica. Los parámetros de función en Zig siempre son inmutables. Se almacenan en "la pila". Una pila es un tipo de estructura de datos y "la pila" es un trozo específico de RAM reservado para tu programa. La CPU tiene soporte especial para agregar y quitar cosas de "la pila", por lo que es un lugar extremadamente eficiente para el almacenamiento de memoria.
//
// Además, cuando una función se ejecuta, los argumentos de entrada a menudo se cargan en el corazón latiente de la CPU misma en registros.
//
// Nuestra función main() aquí no tiene parámetros de entrada, pero tendrá una entrada en la pila (llamada "frame").

pub fn main() void {

    // Aquí, el personaje "glorp" se asignará en la pila
    // porque cada instancia de glorp es mutable y, por lo tanto, única
    // para la invocación de esta función.

    var glorp = Character{
        .gold = 30,
    };

    // El valor "reward_xp" es interesante. Es un valor inmutable,
    // por lo que, aunque sea local, puede ser colocado en datos globales
    // y compartido entre todas las invocaciones. Pero al ser un valor tan pequeño,
    // también puede ser incrustado como un valor literal en tu código de instrucciones
    // donde se utiliza. Esto depende del compilador.

    const reward_xp: u32 = 200;

    // Ahora volvamos a esa estructura "std" que importamos
    // en la parte superior. Como es solo un valor Zig regular una vez que se importa,
    // también podemos asignar nuevos nombres para sus campos y declaraciones.
    // "debug" se refiere a otra estructura y "print" es una función pública
    // que está dentro de ESA estructura.
    //
    // ¡Asignemos la función std.debug.print a una constante llamada "print"
    // para que podamos usar este nuevo nombre más adelante!

    const print = std.debug.print;

    // Ahora veamos cómo asignar y apuntar a valores en Zig.
    //
    // Probaremos tres formas diferentes de crear un nuevo nombre para acceder
    // a nuestro personaje "glorp" y cambiar uno de sus valores.
    //
    // ¡"glorp_access1" está mal nombrado! Le pedimos a Zig que reserve
    // memoria para otra estructura Character. Entonces, cuando asignamos "glorp" a
    // "glorp_access1" aquí, ¡en realidad estamos asignando todos los campos
    // para hacer una copia! Ahora tenemos dos personajes separados.
    //
    // No es necesario corregir esto. Pero fíjate en lo que se imprime en
    // la salida de tu programa para este caso en comparación con las otras dos
    // asignaciones a continuación!

    var glorp_access1: Character = glorp;
    glorp_access1.gold = 111;
    print("1:{}!. ", .{glorp.gold == glorp_access1.gold});

    // NOTE:
    //
    //     Si intentáramos hacer esto con un const Character en lugar de un
    //     var, cambiar el campo gold nos daría un error de compilación
    //     porque los valores const son inmutables.
    //
    // "glorp_access2" hará lo que queremos. Apunta a la dirección original
    // de glorp. También recuerda que obtenemos una desreferencia implícita
    // con los campos de la estructura, por lo que acceder al campo "gold"
    // desde glorp_access2 se ve igual que accederlo desde glorp
    // en sí mismo.

    var glorp_access2: *Character = &glorp;
    glorp_access2.gold = 222;
    print("2:{}!. ", .{glorp.gold == glorp_access2.gold});

    // "glorp_access3" es interesante. También es un puntero, pero es constante.
    // ¿No debería eso impedir cambiar el valor de oro? ¡No! Como recordarás de nuestros experimentos anteriores con punteros,
    // un puntero constante no puede cambiar a lo que apunta, ¡pero el valor en la dirección a la que apunta sigue siendo mutable! Por lo tanto, podemos cambiarlo.

    const glorp_access3: *Character = &glorp;
    glorp_access3.gold = 333;
    print("3:{}!. ", .{glorp.gold == glorp_access3.gold});

    // NOTE:
    //
    //     Si intentáramos hacer esto con un puntero *const Character,
    //     eso NO funcionaría y obtendríamos un error de compilación
    //     ¡porque el VALOR se vuelve inmutable!
    //
    // Siguiendo adelante...
    //
    // Pasar argumentos a funciones es prácticamente igual que
    // hacer una asignación a un const (ya que Zig obliga a que TODOS
    // los parámetros de función sean const).
    //
    // Sabiendo esto, intenta hacer que levelUp() funcione como se espera:
    // debería agregar la cantidad especificada a los puntos de experiencia
    // del personaje suministrado.
    //
    print("XP before:{}, ", .{glorp.experience});

    // Fix 1 of 2 goes here:
    levelUp(&glorp, reward_xp);

    print("after:{}.\n", .{glorp.experience});
}

// Fix 2 of 2 goes here:
fn levelUp(character_access: *Character, xp: u32) void {
    character_access.experience += xp;
}

// ¡Y hay más!
//
// Los segmentos de datos (asignados en tiempo de compilación) y "la pila"
// (asignada en tiempo de ejecución) no son los únicos lugares donde los datos del programa
// pueden almacenarse en memoria. Son solo los más eficientes. A veces
// no sabemos cuánta memoria necesitará nuestro programa hasta que
// el programa se esté ejecutando. Además, hay un límite en el tamaño de la memoria de la pila
// asignada a los programas (a menudo establecido por su sistema operativo).
// Para estas ocasiones, tenemos "el montón" (heap).
//
// Puedes usar tanta memoria del montón como desees (dentro de las limitaciones físicas, por supuesto),
// pero es mucho menos eficiente de gestionar
// porque no hay soporte incorporado en la CPU para agregar y eliminar
// elementos como tenemos con la pila. Además, dependiendo del tipo de
// asignación, es posible que su programa TENGA que realizar un trabajo costoso para gestionar
// el uso de la memoria del montón. Aprenderemos sobre los asignadores del montón más adelante.
//
// ¡Uf! Ha sido mucha información. Te alegrará saber
// que el siguiente ejercicio nos permite volver a aprender características del lenguaje Zig
// que podemos usar de inmediato para hacer más cosas!
