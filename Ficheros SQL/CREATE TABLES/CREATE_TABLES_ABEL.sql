CREATE TABLE pelicula (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR(100),
    fecha_de_estreno DATE
);

CREATE TABLE serie (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR(100),
    fecha_de_estreno DATE,
    fin_de_emision DATE
);

CREATE TABLE  genero_pelicula (
   pelicula INTEGER REFERENCES pelicula(id),
   genero  VARCHAR(100),
   PRIMARY KEY (pelicula,genero)
);

CREATE TABLE  genero_serie (
   serie INTEGER REFERENCES serie(id),
   genero  VARCHAR(100),
   PRIMARY KEY (serie,genero)
);

CREATE TABLE  capitulos_serie (
   serie INTEGER REFERENCES serie(id),
   nombre_capitulo  VARCHAR(100),
   PRIMARY KEY (serie,nombre_capitulo)
);

CREATE TABLE persona (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    nacionalidad VARCHAR(100)
);