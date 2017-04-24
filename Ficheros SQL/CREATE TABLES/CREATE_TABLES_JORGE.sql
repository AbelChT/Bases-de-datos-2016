CREATE TABLE es_precuela (
    original INTEGER REFERENCES pelicula(id),
    precuela INTEGER REFERENCES pelicula(id),
    PRIMARY KEY (original,precuela)
);

CREATE TABLE es_secuela (
    original INTEGER REFERENCES pelicula(id),
    secuela	INTEGER REFERENCES pelicula(id),
    PRIMARY KEY (original,secuela)
);

CREATE TABLE es_remake (
    original INTEGER REFERENCES pelicula(id),
    remake	INTEGER REFERENCES pelicula(id),
    PRIMARY KEY (original,remake)
);

CREATE TABLE actor_pelicula (
    persona INTEGER REFERENCES persona(id),
    pelicula INTEGER REFERENCES pelicula(id),
    descripcion_del_papel VARCHAR(300),
	PRIMARY KEY (persona,pelicula)
);

CREATE TABLE trabajador_pelicula (
    persona INTEGER REFERENCES persona(id),
    pelicula INTEGER REFERENCES pelicula(id),
    descripcion_del_trabajo VARCHAR(300),
	PRIMARY KEY (persona,pelicula)
);

CREATE TABLE director_pelicula (
    persona INTEGER REFERENCES persona(id),
    pelicula INTEGER REFERENCES pelicula(id),
	PRIMARY KEY (persona,pelicula)
);

CREATE TABLE actor_serie (
    persona INTEGER REFERENCES persona(id),
    serie INTEGER REFERENCES serie(id),
    descripcion_del_papel VARCHAR(300),
	PRIMARY KEY (persona,serie)
);

CREATE TABLE trabajador_serie (
    persona INTEGER REFERENCES persona(id),
    serie INTEGER REFERENCES serie(id),
    descripcion_del_trabajo VARCHAR(300),
	PRIMARY KEY (persona,serie)
);

CREATE TABLE director_serie (
    persona INTEGER REFERENCES persona(id),
    serie INTEGER REFERENCES serie(id),
	PRIMARY KEY (persona,serie)
);



