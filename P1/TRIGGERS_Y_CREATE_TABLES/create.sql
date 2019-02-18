CREATE TABLE equipo (
    nombre_oficial VARCHAR(100) PRIMARY KEY,
    nombre_corto VARCHAR(50),
    nombre_historico VARCHAR(50),
    ciudad VARCHAR(50),
    fundacion INTEGER
);
CREATE TABLE otros_nombres (
    equipo VARCHAR(100) REFERENCES equipo(nombre_oficial),
    nombre VARCHAR(100),
    PRIMARY KEY (equipo,nombre)
);
CREATE TABLE estadio (
    nombre VARCHAR(50) PRIMARY KEY,
    capacidad INTEGER,
    inauguracion INTEGER
);
CREATE TABLE temporada (
    id INT PRIMARY KEY,
    anyo VARCHAR(9) NOT NULL,
    division VARCHAR(20) NOT NULL,
    finalizada INT,
    denominacion VARCHAR(30)
);
CREATE TABLE partido (
    idTemp INTEGER REFERENCES temporada(id),
    equipo_local VARCHAR(100) REFERENCES equipo(nombre_oficial),
    equipo_visitante VARCHAR(100) REFERENCES equipo(nombre_oficial),
    jornada INTEGER,
    goles_local INTEGER NOT NULL,
    goles_visitante INTEGER NOT NULL,
    PRIMARY KEY(idTemp, jornada,equipo_local,equipo_visitante)
);
CREATE TABLE residir (
	equipo VARCHAR(100),
	estadio VARCHAR(50),
	inicio INTEGER,
	fin INTEGER,
	FOREIGN KEY (equipo) REFERENCES equipo(nombre_oficial),
	FOREIGN KEY (estadio) REFERENCES estadio(nombre),
	PRIMARY KEY (equipo, estadio, inicio, fin)
);

CREATE TABLE jugar (
	equipo VARCHAR(100) REFERENCES equipo(nombre_oficial),
	temporada INTEGER REFERENCES temporada(id),
	PRIMARY KEY(equipo, temporada)
);

CREATE INDEX div_index ON temporada(division);
CREATE INDEX jorn_index ON partido(jornada);