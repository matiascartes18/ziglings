//
// Hemos absorbido mucha información sobre las variaciones de tipos que podemos usar en Zig. A grandes rasgos, en orden tenemos:
//
//                          u8  elemento único
//                         *u8  puntero a un solo elemento
//                        []u8  slice (tamaño conocido en tiempo de ejecución)
//                       [5]u8  arreglo de 5 elementos u8
//                       [*]u8  puntero a varios elementos (cero o más)
//                 enum {a, b}  conjunto de valores únicos a y b
//                error {e, f}  conjunto de valores de error únicos e y f
//      struct {y: u8, z: i32}  grupo de valores y y z
// union(enum) {a: u8, b: i32}  valor único que puede ser u8 o i32
//
// Valores de cualquiera de los tipos anteriores pueden ser asignados como "var" o "const"
// para permitir o no cambios (mutabilidad) a través del nombre asignado:
//
//     const a: u8 = 5; // inmutable
//       var b: u8 = 5; // mutable
//
// También podemos crear uniones de error o tipos opcionales a partir de cualquiera de los anteriores:
//
//     var a: E!u8 = 5; // puede ser u8 o error del conjunto E
//     var b: ?u8 = 5;  // puede ser u8 o null
//
// Sabiendo todo esto, tal vez podamos ayudar a un ermitaño local. Él hizo
// un pequeño programa en Zig para ayudarlo a planificar sus viajes por el bosque,
// pero tiene algunos errores.
//
// *************************************************************
// *                UNA NOTA SOBRE ESTE EJERCICIO               *
// *                                                           *
// * No es necesario leer y entender cada parte de este        *
// * programa. Es un ejemplo muy grande. Siéntete libre de      *
// * revisarlo rápidamente y luego enfócate en las pocas partes *
// * que están realmente rotas.                                *
// *                                                           *
// *************************************************************
//
const print = @import("std").debug.print;

// The grue is a nod to Zork.
const TripError = error{ Unreachable, EatenByAGrue };

// Comencemos con los Lugares en el mapa. Cada uno tiene un nombre y una
// distancia o dificultad de viaje (según lo juzgado por el ermitaño).
//
// Observa que declaramos los lugares como mutables (var) porque necesitamos
// asignar los caminos más tarde. ¿Y por qué es eso? Porque los caminos contienen
// punteros a lugares y asignarlos ahora crearía un bucle de dependencia.
const Place = struct {
    name: []const u8,
    paths: []const Path = undefined,
};

var a = Place{ .name = "Archer's Point" };
var b = Place{ .name = "Bridge" };
var c = Place{ .name = "Cottage" };
var d = Place{ .name = "Dogwood Grove" };
var e = Place{ .name = "East Pond" };
var f = Place{ .name = "Fox Pond" };

//           The hermit's hand-drawn ASCII map
//  +---------------------------------------------------+
//  |         * Archer's Point                ~~~~      |
//  | ~~~                              ~~~~~~~~         |
//  |   ~~~| |~~~~~~~~~~~~      ~~~~~~~                 |
//  |         Bridge     ~~~~~~~~                       |
//  |  ^             ^                           ^      |
//  |     ^ ^                      / \                  |
//  |    ^     ^  ^       ^        |_| Cottage          |
//  |   Dogwood Grove                                   |
//  |                  ^     <boat>                     |
//  |  ^  ^  ^  ^          ~~~~~~~~~~~~~    ^   ^       |
//  |      ^             ~~ East Pond ~~~               |
//  |    ^    ^   ^       ~~~~~~~~~~~~~~                |
//  |                           ~~          ^           |
//  |           ^            ~~~ <-- short waterfall    |
//  |   ^                 ~~~~~                         |
//  |            ~~~~~~~~~~~~~~~~~                      |
//  |          ~~~~ Fox Pond ~~~~~~~    ^         ^     |
//  |      ^     ~~~~~~~~~~~~~~~           ^ ^          |
//  |                ~~~~~                              |
//  +---------------------------------------------------+
//
// Reservaremos memoria en nuestro programa basado en la cantidad de
// lugares en el mapa. Ten en cuenta que no tenemos que especificar el tipo de
// este valor porque en realidad no lo usamos en nuestro programa una vez
// que se compila. (No te preocupes si esto no tiene sentido aún.)
const place_count = 6;

// Ahora creemos todos los caminos entre los lugares. Un camino va desde
// un lugar a otro y tiene una distancia.
const Path = struct {
    from: *const Place,
    to: *const Place,
    dist: u8,
};

// Por cierto, si el siguiente código parece mucho trabajo manual tedioso,
// ¡tienes razón! Una de las características destacadas de Zig es permitirnos
// escribir código que se ejecuta en tiempo de compilación para "automatizar"
// código repetitivo (similar a las macros en otros lenguajes), pero aún no hemos
// aprendido cómo hacerlo.
const a_paths = [_]Path{
    Path{
        .from = &a, // from: Archer's Point
        .to = &b, //   to: Bridge
        .dist = 2,
    },
};

const b_paths = [_]Path{
    Path{
        .from = &b, // from: Bridge
        .to = &a, //   to: Archer's Point
        .dist = 2,
    },
    Path{
        .from = &b, // from: Bridge
        .to = &d, //   to: Dogwood Grove
        .dist = 1,
    },
};

const c_paths = [_]Path{
    Path{
        .from = &c, // from: Cottage
        .to = &d, //   to: Dogwood Grove
        .dist = 3,
    },
    Path{
        .from = &c, // from: Cottage
        .to = &e, //   to: East Pond
        .dist = 2,
    },
};

const d_paths = [_]Path{
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &b, //   to: Bridge
        .dist = 1,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &c, //   to: Cottage
        .dist = 3,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &f, //   to: Fox Pond
        .dist = 7,
    },
};

const e_paths = [_]Path{
    Path{
        .from = &e, // from: East Pond
        .to = &c, //   to: Cottage
        .dist = 2,
    },
    Path{
        .from = &e, // from: East Pond
        .to = &f, //   to: Fox Pond
        .dist = 1, // (one-way down a short waterfall!)
    },
};

const f_paths = [_]Path{
    Path{
        .from = &f, // from: Fox Pond
        .to = &d, //   to: Dogwood Grove
        .dist = 7,
    },
};

// Una vez que hayamos trazado el mejor curso a través del bosque, haremos un
// "viaje" de ello. Un viaje es una serie de Lugares conectados por Caminos.
// Usamos una unión TripItem para permitir que tanto Lugares como Caminos estén en el
// mismo arreglo.
const TripItem = union(enum) {
    place: *const Place,
    path: *const Path,

    // This is a little helper function to print the two different
    // types of item correctly.
    fn printMe(self: TripItem) void {
        switch (self) {
            // ¡Ups! El ermitaño olvidó cómo capturar los valores de la unión
            // en una declaración switch. Por favor, captura ambos valores como
            // 'p' para que las declaraciones de impresión funcionen correctamente.
            .place  => |p| print("{s}", .{p.name}),
            .path  => |p| print("--{}->", .{p.dist}),
        }
    }
};

// El Cuaderno del Ermitaño es donde ocurre toda la magia. Una entrada del cuaderno
// es un Lugar descubierto en el mapa junto con el Camino tomado para llegar allí y
// la distancia para alcanzarlo desde el punto de inicio. Si encontramos un Camino mejor
// para llegar a un Lugar (distancia más corta), actualizamos la entrada. Las entradas también
// sirven como una lista de "pendientes" que es cómo llevamos un registro de qué caminos
// explorar a continuación.
const NotebookEntry = struct {
    place: *const Place,
    coming_from: ?*const Place,
    via_path: ?*const Path,
    dist_to_reach: u16,
};

// +------------------------------------------------+
// |              ~ Hermit's Notebook ~             |
// +---+----------------+----------------+----------+
// |   |      Place     |      From      | Distance |
// +---+----------------+----------------+----------+
// | 0 | Archer's Point | null           |        0 |
// | 1 | Bridge         | Archer's Point |        2 | < next_entry
// | 2 | Dogwood Grove  | Bridge         |        1 |
// | 3 |                |                |          | < end_of_entries
// |                      ...                       |
// +---+----------------+----------------+----------+
//
const HermitsNotebook = struct {
    // ¿Recuerdas el operador de repetición de matrices `**`? No es solo una novedad,
    // también es una excelente manera de asignar múltiples elementos en una matriz
    // sin tener que enumerarlos uno por uno. Aquí lo usamos para inicializar una matriz
    // con valores nulos.
    entries: [place_count]?NotebookEntry = .{null} ** place_count,

    // La siguiente entrada lleva un registro de dónde estamos en nuestra lista de "pendientes".
    next_entry: u8 = 0,

    // Marca el inicio del espacio vacío en el cuaderno.
    end_of_entries: u8 = 0,

    // A menudo querremos encontrar una entrada por Lugar. Si no se encuentra una,
    // devolvemos null.
    fn getEntry(self: *HermitsNotebook, place: *const Place) ?*NotebookEntry {
        for (&self.entries, 0..) |*entry, i| {
            if (i >= self.end_of_entries) break;

            // Aquí es donde el ermitaño se quedó atascado. Necesitamos devolver
            // un puntero opcional a una entrada de Notebook (NotebookEntry).
            //
            // Lo que tenemos con "entry" es lo opuesto: ¡un puntero a
            // una entrada de Notebook opcional!
            //
            // Para obtener uno del otro, necesitamos desreferenciar
            // "entry" (con .*) y obtener el valor no nulo del
            // opcional (con .?) y devolver la dirección de eso. El
            // if proporciona algunas pistas sobre cómo se ven
            // juntos la desreferencia y el "desenvolvimiento" del valor opcional.
            // Recuerda que devuelves la dirección con el
            // operador "&".
            if (place == entry.*.?.place) return &entry.*.?;
            // Intenta que tu respuesta sea tan larga:__________;
        }
        return null;
    }

    // El método checkNote() es el corazón latiente del cuaderno mágico.
    // Dada una nueva nota en forma de una estructura NotebookEntry,
    // verificamos si ya tenemos una entrada para el Lugar de la nota.
    //
    // Si NO la tenemos, agregamos la entrada al final del cuaderno
    // junto con el Camino tomado y la distancia.
    //
    // Si SÍ la tenemos, verificamos si el camino es "mejor" (distancia más corta)
    // que el que habíamos anotado anteriormente. Si lo es, sobrescribimos
    // la antigua entrada con la nueva.
    fn checkNote(self: *HermitsNotebook, note: NotebookEntry) void {
        const existing_entry = self.getEntry(note.place);

        if (existing_entry == null) {
            self.entries[self.end_of_entries] = note;
            self.end_of_entries += 1;
        } else if (note.dist_to_reach < existing_entry.?.dist_to_reach) {
            existing_entry.?.* = note;
        }
    }

    // The next two methods allow us to use the notebook as a "todo"
    // list.
    fn hasNextEntry(self: *HermitsNotebook) bool {
        return self.next_entry < self.end_of_entries;
    }

    fn getNextEntry(self: *HermitsNotebook) *const NotebookEntry {
        defer self.next_entry += 1; // Increment after getting entry
        return &self.entries[self.next_entry].?;
    }

    // Después de completar nuestra búsqueda en el mapa, habremos
    // calculado el camino más corto hacia cada Lugar. Para recopilar
    // el viaje completo desde el inicio hasta el destino, necesitamos
    // caminar hacia atrás desde la entrada del cuaderno del destino,
    // siguiendo los punteros coming_from hasta el inicio. Lo que
    // obtenemos es una matriz de TripItems con nuestro viaje en orden
    // inverso.
    //
    // Necesitamos tomar la matriz de viaje como parámetro porque
    // queremos que la función main() sea la "dueña" de la memoria de
    // la matriz. ¿Qué crees que podría suceder si asignamos la matriz
    // en el marco de pila de esta función (el espacio asignado para
    // los datos "locales" de una función) y devolvemos un puntero o
    // una rebanada a ella?
    //
    // Parece que el ermitaño olvidó algo en el valor de retorno de
    // esta función. ¿Qué podría ser eso?
    fn getTripTo(self: *HermitsNotebook, trip: []?TripItem, dest: *Place) !void {
        // We start at the destination entry.
        const destination_entry = self.getEntry(dest);

        // This function needs to return an error if the requested
        // destination was never reached. (This can't actually happen
        // in our map since every Place is reachable by every other
        // Place.)
        if (destination_entry == null) {
            return TripError.Unreachable;
        }

        // Variables hold the entry we're currently examining and an
        // index to keep track of where we're appending trip items.
        var current_entry = destination_entry.?;
        var i: u8 = 0;

        // At the end of each looping, a continue expression increments
        // our index. Can you see why we need to increment by two?
        while (true) : (i += 2) {
            trip[i] = TripItem{ .place = current_entry.place };

            // An entry "coming from" nowhere means we've reached the
            // start, so we're done.
            if (current_entry.coming_from == null) break;

            // Otherwise, entries have a path.
            trip[i + 1] = TripItem{ .path = current_entry.via_path.? };

            // Now we follow the entry we're "coming from".  If we
            // aren't able to find the entry we're "coming from" by
            // Place, something has gone horribly wrong with our
            // program! (This really shouldn't ever happen. Have you
            // checked for grues?)
            // Note: you do not need to fix anything here.
            const previous_entry = self.getEntry(current_entry.coming_from.?);
            if (previous_entry == null) return TripError.EatenByAGrue;
            current_entry = previous_entry.?;
        }
    }
};

pub fn main() void {
    // Here's where the hermit decides where he would like to go. Once
    // you get the program working, try some different Places on the
    // map!
    const start = &a; // Archer's Point
    const destination = &f; // Fox Pond

    // Almacenar cada arreglo de caminos como una rebanada en cada Lugar. Como se mencionó anteriormente, necesitamos retrasar estas referencias para evitar crear un bucle de dependencia cuando el compilador intenta determinar cómo asignar espacio para cada elemento.
    a.paths = a_paths[0..];
    b.paths = b_paths[0..];
    c.paths = c_paths[0..];
    d.paths = d_paths[0..];
    e.paths = e_paths[0..];
    f.paths = f_paths[0..];

    // Ahora creamos una instancia del cuaderno y agregamos la primera
    // entrada "start". Observa los valores nulos. Lee los comentarios
    // del método checkNote() anterior para ver cómo se agrega esta
    // entrada al cuaderno.
    var notebook = HermitsNotebook{};
    var working_note = NotebookEntry{
        .place = start,
        .coming_from = null,
        .via_path = null,
        .dist_to_reach = 0,
    };
    notebook.checkNote(working_note);

    // Obtén la siguiente entrada del cuaderno (siendo la primera la
    // entrada "start" que acabamos de agregar) hasta que no haya más,
    // momento en el que habremos revisado todos los Lugares alcanzables.
    while (notebook.hasNextEntry()) {
        const place_entry = notebook.getNextEntry();

        // Para cada Camino que lleva DESDE el Lugar actual, crea una
        // nueva nota (en forma de NotebookEntry) con el Lugar de destino y la distancia total desde el inicio para llegar a ese lugar. Nuevamente, lee los comentarios del método checkNote() para ver cómo funciona esto.
        for (place_entry.place.paths) |*path| {
            working_note = NotebookEntry{
                .place = path.to,
                .coming_from = place_entry.place,
                .via_path = path,
                .dist_to_reach = place_entry.dist_to_reach + path.dist,
            };
            notebook.checkNote(working_note);
        }
    }

    // Una vez que se completa el bucle anterior, ¡hemos calculado el camino más corto hacia cada Lugar alcanzable! Lo que necesitamos hacer ahora es reservar memoria para el viaje y hacer que el cuaderno del ermitaño complete el viaje desde el destino hasta el inicio. ¡Ten en cuenta que esta es la primera vez que realmente usamos el destino!
    var trip = [_]?TripItem{null} ** (place_count * 2);

    notebook.getTripTo(trip[0..], destination) catch |err| {
        print("Oh no! {}\n", .{err});
        return;
    };

    // Print the trip with a little helper function below.
    printTrip(trip[0..]);
}

// Recuerda que los viajes serán una serie de TripItems alternados
// que contienen un Lugar o un Camino desde el destino hasta el inicio.
// El espacio restante en el arreglo de viaje contendrá valores nulos, por lo que
// necesitamos recorrer los elementos en orden inverso, saltando los nulos, hasta
// llegar al destino al principio del arreglo.
//
fn printTrip(trip: []?TripItem) void {
    // We convert the usize length to a u8 with @intCast(), a
    // builtin function just like @import().  We'll learn about
    // these properly in a later exercise.
    var i: u8 = @intCast(trip.len);

    while (i > 0) {
        i -= 1;
        if (trip[i] == null) continue;
        trip[i].?.printMe();
    }

    print("\n", .{});
}

// Profundizando:
//
// En términos de ciencias de la computación, nuestros lugares en el mapa son "nodos" o "vértices" y los caminos son "aristas". Juntos, forman un "grafo ponderado y dirigido". Es "ponderado" porque cada camino tiene una distancia (también conocida como "costo"). Es "dirigido" porque cada camino va DESDE un lugar HACIA otro lugar (los grafos no dirigidos te permiten viajar en una arista en ambas direcciones).
//
// Dado que agregamos nuevas entradas en el cuaderno al final de la lista y luego exploramos cada una secuencialmente desde el principio (como una lista de "tareas pendientes"), tratamos el cuaderno como una cola "Primero en entrar, primero en salir" (FIFO).
//
// Dado que examinamos todos los caminos más cercanos primero antes de probar otros más lejanos (gracias a la cola de "tareas pendientes"), estamos realizando una "Búsqueda en Anchura" (BFS).
//
// Al rastrear los caminos de "menor costo", también podemos decir que estamos realizando una "búsqueda de menor costo".
//
// Aún más específicamente, el Cuaderno del Ermitaño se asemeja más al Algoritmo de Ruta Más Corta Más Rápida (SPFA), atribuido a Edward F. Moore. Al reemplazar nuestra simple cola FIFO con una "cola de prioridad", básicamente tendríamos el algoritmo de Dijkstra. Una cola de prioridad recupera elementos ordenados por "peso" (en nuestro caso, mantendría los caminos con la distancia más corta al frente de la cola). El algoritmo de Dijkstra es más eficiente porque los caminos más largos se pueden eliminar más rápidamente. (Hazlo en papel para ver por qué!)
