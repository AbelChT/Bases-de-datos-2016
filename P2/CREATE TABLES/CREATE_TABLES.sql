-- Almacena las películas su nombre y su fecha de estreno
CREATE TABLE pelicula (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR(100),
    fecha_de_estreno INTEGER NOT NULL
);

-- Almacena las series su nombre y su fecha de estreno 
-- y el fin de su emision
CREATE TABLE serie (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR(100),
    fecha_de_estreno INTEGER,
    fin_de_emision INTEGER
);

-- Relaciona cada película con sus géneros
CREATE TABLE  genero_pelicula (
   pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE ,
   genero  VARCHAR(100),
   PRIMARY KEY (pelicula,genero)
);

-- Relaciona cada serie con sus géneros
CREATE TABLE  genero_serie (
   serie INTEGER REFERENCES serie(id) ON DELETE CASCADE ,
   genero  VARCHAR(100),
   PRIMARY KEY (serie,genero)
);

-- Relaciona cada capítulo con la serie a la que pertenece
CREATE TABLE  capitulos_serie (
   serie INTEGER REFERENCES serie(id) ON DELETE CASCADE ,
   nombre_capitulo  VARCHAR(100),
   PRIMARY KEY (serie,nombre_capitulo)
);

-- Tabla en la que se guardaran todas las personas físicas
CREATE TABLE persona (
    id INTEGER PRIMARY KEY ,
    nombre VARCHAR(100),
    nacionalidad VARCHAR(100)
);

-- En esta tabla se relaciona cada película con sus precuelas
CREATE TABLE es_precuela (
    original INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    precuela INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    PRIMARY KEY (original,precuela)
);

-- En esta tabla se relaciona cada película con sus secuelas
CREATE TABLE es_secuela (
    original INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    secuela	INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    PRIMARY KEY (original,secuela)
);

-- En esta tabla se relaciona cada película con los remakes hechos de la
-- película en cuestión
CREATE TABLE es_remake (
    original INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    remake	INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    PRIMARY KEY (original,remake)
);

-- En esta tabla se relaciona cada película con los actores que trabajan en ella
CREATE TABLE actor_pelicula (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    descripcion_del_papel VARCHAR(300),
	PRIMARY KEY (persona,pelicula)
);

-- En esta tabla se relaciona cada película con el personal que
-- trabaja en ella sin ser ni actor ni director
CREATE TABLE trabajador_pelicula (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    descripcion_del_trabajo VARCHAR(300),
	PRIMARY KEY (persona,pelicula)
);

-- En esta tabla se relaciona cada película con los directores que trabajan en ella
CREATE TABLE director_pelicula (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
	PRIMARY KEY (persona,pelicula)
);

-- En esta tabla se relaciona cada serie con los actores que trabajan en ella
CREATE TABLE actor_serie (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    serie INTEGER REFERENCES serie(id) ON DELETE CASCADE,
    descripcion_del_papel VARCHAR(300),
	PRIMARY KEY (persona,serie)
);

-- En esta tabla se relaciona cada serie con el personal que
-- trabaja en ella sin ser ni actor ni director
CREATE TABLE trabajador_serie (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    serie INTEGER REFERENCES serie(id) ON DELETE CASCADE,
    descripcion_del_trabajo VARCHAR(300),
	PRIMARY KEY (persona,serie)
);

-- En esta tabla se relaciona cada serie con los directores que trabajan en ella
CREATE TABLE director_serie (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    serie INTEGER REFERENCES serie(id) ON DELETE CASCADE,
	PRIMARY KEY (persona,serie)
);
