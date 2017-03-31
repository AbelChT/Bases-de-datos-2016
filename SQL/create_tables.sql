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
    inauguracion DATE
);
CREATE TABLE temporada (
    id INT PRIMARY KEY,
    anyo VARCHAR(9),
    division VARCHAR(20),
    finalizada INT,
    denominacion VARCHAR(30)
);
CREATE TABLE partido (
    idTemp INTEGER REFERENCES temporada(id),
    equipo_local VARCHAR(100) REFERENCES equipo(nombre_oficial),
    equipo_visitante VARCHAR(100) REFERENCES equipo(nombre_oficial),
    jornada INTEGER,
    goles_local INTEGER,
    goles_visitante INTEGER
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
