-- Guarda información de las ciudades
CREATE TABLE ciudad (
  id     INTEGER PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  estado VARCHAR(50) NOT NULL,  pais   VARCHAR(50) NOT NULL,
  UNIQUE (nombre, estado, pais)
);

-- Guarda información de los aeropuertos
CREATE TABLE aeropuerto (
  iata     VARCHAR(4) PRIMARY KEY, -- Hay aeropuertos con iata de 4 letras
  oaci     VARCHAR(4) UNIQUE,
  nombre   VARCHAR(45),
  longitud FLOAT,
  latitud  FLOAT,
  ciudad   INTEGER REFERENCES ciudad (id) ON DELETE SET NULL
);

-- Guarda información sobre los diferentes modelos de avión
CREATE TABLE modelo_de_avion (
  id         INTEGER PRIMARY KEY,
  nombre     VARCHAR(50)  NOT NULL,
  fabricante VARCHAR(1000) NOT NULL,
  tipo_motor VARCHAR(50),
  tipo_avion VARCHAR(50),
  UNIQUE (nombre, fabricante)
);

-- Guarda información referentes a cada avion en concreto
CREATE TABLE avion (
  id                INTEGER PRIMARY KEY,
  numero_de_cola    VARCHAR(7) NOT NULL,
  modelo            INTEGER REFERENCES modelo_de_avion (id) ON DELETE SET NULL,
  fecha_de_registro INTEGER CHECK (fecha_de_registro>=1903), -- año de registro, en 1903
  -- se construyó el primer avión por lo que no podriamos registra un avión anterior a esa fecha
  -- aunque se podría acotar tambien para evitar que se inserten aviones con un año de registro
  -- superior a la fecha actual se ha decidido no hacerlo
  UNIQUE (numero_de_cola, fecha_de_registro)
);

-- Guarda información referente a las aerolíneas
CREATE TABLE aerolinea (
  iata      VARCHAR(7) PRIMARY KEY, -- Para permitir los iata con ()
  nombre    VARCHAR(100),
  fundacion DATE, -- Fecha de fundación de la aerolínea
  sede      INTEGER REFERENCES ciudad (id) ON DELETE SET NULL -- Ubicación de la sede de la aerolínea
);

-- Guarda información referente a los vuelos sin incluir los diversos problemas que pueden sufrir estos
CREATE TABLE vuelo (
  id                      INTEGER PRIMARY KEY,
  numero_vuelo            INTEGER,
  fecha                   DATE,
  avion                   INTEGER REFERENCES avion (id) ON DELETE SET NULL, -- Avion que realiza el vuelo
  aerolinea               VARCHAR(7) REFERENCES aerolinea (iata) ON DELETE SET NULL,
  destino                 VARCHAR(4) REFERENCES aeropuerto (iata) ON DELETE SET NULL,
  origen                  VARCHAR(4) REFERENCES aeropuerto (iata) ON DELETE SET NULL,
  hora_salida_programada  INTEGER CHECK ((hora_salida_programada / 100) >= 0 AND (hora_salida_programada / 100) < 24 AND MOD(hora_salida_programada, 100) >= 0 AND MOD(hora_salida_programada, 100) < 60),-- formato hhmm
  hora_salida_real        INTEGER CHECK ((hora_salida_real / 100) >= 0 AND (hora_salida_real / 100) < 24 AND MOD(hora_salida_real, 100) >= 0 AND MOD(hora_salida_real, 100) < 60),-- formato hhmm
  hora_despegue           INTEGER CHECK ((hora_despegue / 100) >= 0 AND (hora_despegue / 100) < 24 AND MOD(hora_despegue, 100) >= 0 AND MOD(hora_despegue, 100) < 60),-- formato hhmm
  hora_aterrizaje         INTEGER CHECK ((hora_aterrizaje / 100) >= 0 AND (hora_aterrizaje / 100) < 24 AND MOD(hora_aterrizaje, 100) >= 0 AND MOD(hora_aterrizaje, 100) < 60),-- formato hhmm
  hora_llegada_programada INTEGER CHECK ((hora_llegada_programada / 100) >= 0 AND (hora_llegada_programada / 100) < 24 AND MOD(hora_llegada_programada, 100) >= 0 AND MOD(hora_llegada_programada, 100) < 60),-- formato hhmm
  hora_llegada_real       INTEGER CHECK ((hora_llegada_real / 100) >= 0 AND (hora_llegada_real / 100) < 24 AND MOD(hora_llegada_real, 100) >= 0 AND MOD(hora_llegada_real, 100) < 60),-- formato hhmm
  distancia               FLOAT, -- Distancia en el caso de que se produzca el vuelo sin incidentes
                                 -- si se producen escalas por emergencia no aparece reflejada aqui
                                 -- la distancia añadida por esta
 UNIQUE (numero_vuelo, fecha, aerolinea,hora_salida_programada)
);

-- Relaciona cada vuelo cancelado con su(s) causa(s)
CREATE TABLE vuelos_cancelados (
  vuelo  INTEGER REFERENCES vuelo (id) ON DELETE CASCADE,
  causa VARCHAR(10) CHECK(causa IN ('Carrier','Weather','NAS','Security')), -- Causa de la cancelación
  PRIMARY KEY (vuelo, causa)
);

-- Relaciona cada vuelo retrasado con su(s) causa(s) y el tiempo añadido por este retraso
CREATE TABLE vuelos_retrasados (
  vuelo INTEGER REFERENCES vuelo (id) ON DELETE CASCADE,
  causa VARCHAR(3) CHECK(causa IN ('CAR','LAT','NAS','SEC','WEA')), -- causa del retraso
  tiempo INTEGER, -- tiempo añadido por el retraso
  PRIMARY KEY (vuelo, causa)
);

-- Relaciona cada vuelo con las escalas de emergencia que ha tenido
CREATE TABLE escalas_emergencias (
  vuelo                INTEGER REFERENCES vuelo (id) ON DELETE CASCADE,
  avion                INTEGER REFERENCES avion (id) ON DELETE SET NULL,
  aeropuerto_escala    VARCHAR(4) REFERENCES aeropuerto (iata) ON DELETE SET NULL,
  hora_despegue        INTEGER CHECK ((hora_despegue / 100) >= 0 AND (hora_despegue / 100) < 24 AND MOD(hora_despegue, 100) >= 0 AND MOD(hora_despegue, 100) < 60),-- formato hhmm
  hora_aterrizaje      INTEGER CHECK ((hora_aterrizaje / 100) >= 0 AND (hora_aterrizaje / 100) < 24 AND MOD(hora_aterrizaje, 100) >= 0 AND MOD(hora_aterrizaje, 100) < 60),-- formato hhmm
  distancia_adiccional FLOAT,
  PRIMARY KEY (vuelo, hora_despegue)
);
