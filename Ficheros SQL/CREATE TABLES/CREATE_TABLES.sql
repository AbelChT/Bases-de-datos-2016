CREATE TABLE pelicula (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR(100),
    fecha_de_estreno INTEGER NOT NULL
);

CREATE TABLE serie (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR(100),
    fecha_de_estreno INTEGER,
    fin_de_emision INTEGER
);

CREATE TABLE  genero_pelicula (
   pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE ,
   genero  VARCHAR(100),
   PRIMARY KEY (pelicula,genero)
);

CREATE TABLE  genero_serie (
   serie INTEGER REFERENCES serie(id) ON DELETE CASCADE ,
   genero  VARCHAR(100),
   PRIMARY KEY (serie,genero)
);

CREATE TABLE  capitulos_serie (
   serie INTEGER REFERENCES serie(id) ON DELETE CASCADE ,
   nombre_capitulo  VARCHAR(100),
   PRIMARY KEY (serie,nombre_capitulo)
);

CREATE TABLE persona (
    id INTEGER PRIMARY KEY ,
    nombre VARCHAR(100),
    nacionalidad VARCHAR(100)
);

CREATE TABLE es_precuela (
    original INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    precuela INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    PRIMARY KEY (original,precuela)
);

CREATE TABLE es_secuela (
    original INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    secuela	INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    PRIMARY KEY (original,secuela)
);

CREATE TABLE es_remake (
    original INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    remake	INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    PRIMARY KEY (original,remake)
);

CREATE TABLE actor_pelicula (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    descripcion_del_papel VARCHAR(300),
	PRIMARY KEY (persona,pelicula)
);

CREATE TABLE trabajador_pelicula (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
    descripcion_del_trabajo VARCHAR(300),
	PRIMARY KEY (persona,pelicula)
);

CREATE TABLE director_pelicula (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    pelicula INTEGER REFERENCES pelicula(id) ON DELETE CASCADE,
	PRIMARY KEY (persona,pelicula)
);

CREATE TABLE actor_serie (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    serie INTEGER REFERENCES serie(id) ON DELETE CASCADE,
    descripcion_del_papel VARCHAR(300),
	PRIMARY KEY (persona,serie)
);

CREATE TABLE trabajador_serie (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    serie INTEGER REFERENCES serie(id) ON DELETE CASCADE,
    descripcion_del_trabajo VARCHAR(300),
	PRIMARY KEY (persona,serie)
);

CREATE TABLE director_serie (
    persona INTEGER REFERENCES persona(id) ON DELETE CASCADE,
    serie INTEGER REFERENCES serie(id) ON DELETE CASCADE,
	PRIMARY KEY (persona,serie)
);