//
// Los cuerpos de los bucles son bloques, que también son expresiones. Hemos visto
// cómo se pueden usar para evaluar y devolver valores. Para expandir aún más
// este concepto, resulta que también podemos dar nombres a los bloques mediante
// la aplicación de una 'etiqueta':
//
//     mi_etiqueta: { ... }
//
// Una vez que le das a un bloque una etiqueta, puedes usar 'break' para salir
// de ese bloque.
//
//     bloque_exterior: {           // bloque exterior
//         while (true) {       // bloque interior
//             break :bloque_exterior;
//         }
//         unreachable;
//     }
//
// Como acabamos de aprender, puedes devolver un valor usando una declaración de break.
// ¿Eso significa que puedes devolver un valor desde cualquier bloque etiquetado? ¡Sí lo hace!
//
//     const foo = hacer_cinco: {
//         const cinco = 1 + 1 + 1 + 1 + 1;
//         break :hacer_cinco cinco;
//     };
//
// Las etiquetas también se pueden usar con bucles. Poder salir de
// bucles anidados en un nivel específico es una de esas cosas que
// no usarás todos los días, pero cuando llegue el momento, es
// increíblemente conveniente. Poder devolver un valor desde un
// bucle interno a veces es tan útil que casi parece hacer trampa
// (y puede ayudarte a evitar crear muchas variables temporales).
//
//     const bar: u8 = dos_bucles: while (true) {
//         while (true) {
//             break :dos_bucles 2;
//         }
//     } else 0;
//
// En el ejemplo anterior, el break sale del bucle exterior
// etiquetado como "dos_bucles" y devuelve el valor 2. La cláusula else está
// adjunta al dos_bucles externo y se evaluaría si el bucle terminara de alguna manera
// sin haberse llamado al break.
//
// Finalmente, también puedes usar etiquetas de bloque con la declaración 'continue':
//
//     mi_mientras: while (true) {
//         continue :mi_mientras;
//     }
//
const print = @import("std").debug.print;

// As mentioned before, we'll soon understand why these two
// numbers don't need explicit types. Hang in there!
const ingredients = 4;
const foods = 4;

const Food = struct {
    name: []const u8,
    requires: [ingredients]bool,
};

//                 Chili  Macaroni  Tomato Sauce  Cheese
// ------------------------------------------------------
//  Mac & Cheese              x                     x
//  Chili Mac        x        x
//  Pasta                     x          x
//  Cheesy Chili     x                              x
// ------------------------------------------------------

const menu: [foods]Food = [_]Food{
    Food{
        .name = "Mac & Cheese",
        .requires = [ingredients]bool{ false, true, false, true },
    },
    Food{
        .name = "Chili Mac",
        .requires = [ingredients]bool{ true, true, false, false },
    },
    Food{
        .name = "Pasta",
        .requires = [ingredients]bool{ false, true, true, false },
    },
    Food{
        .name = "Cheesy Chili",
        .requires = [ingredients]bool{ true, false, false, true },
    },
};

pub fn main() void {
    // Welcome to Cafeteria USA! Choose your favorite ingredients
    // and we'll produce a delicious meal.
    //
    // Cafeteria Customer Note: Not all ingredient combinations
    // make a meal. The default meal is macaroni and cheese.
    //
    // Software Developer Note: Hard-coding the ingredient
    // numbers (based on array position) will be fine for our
    // tiny example, but it would be downright criminal in a real
    // application!
    const wanted_ingredients = [_]u8{ 0, 3 }; // Chili, Cheese

    // Look at each Food on the menu...
    const meal = food_loop: for (menu) |food| {

        // Now look at each required ingredient for the Food...
        ingredients_loop: for (food.requires, 0..) |required, required_ingredient| {

            // This ingredient isn't required, so skip it.
            if (!required) continue;

            // See if the customer wanted this ingredient.
            // (Remember that want_it will be the index number of
            // the ingredient based on its position in the
            // required ingredient list for each food.)
            // const found = for (wanted_ingredients) |want_it| {
            //     if (required_ingredient == want_it) break true;
            // } else false;
            if (required_ingredient == wanted_ingredients[0] or required_ingredient == wanted_ingredients[1])
             continue: ingredients_loop 
             else continue: food_loop;
            // We did not find this required ingredient, so we
            // can't make this Food. Continue the outer loop.
            //if (!found) continue :food_loop;
        }

        // Si llegamos hasta aquí, todos los ingredientes requeridos
        // fueron solicitados para esta comida.
        //
        // Por favor, devuelve esta comida desde el bucle.
        break :food_loop food;
    } else menu[0];
    // ^ ¡Ups! Olvidamos devolver Mac & Cheese como la comida predeterminada
    // cuando no se encuentran los ingredientes solicitados.

    print("Enjoy your {s}!\n", .{meal.name});
}

// Desafío: ¡También puedes prescindir de la variable 'found' en el
// bucle interno. ¡Veamos si puedes descubrir cómo hacerlo!
