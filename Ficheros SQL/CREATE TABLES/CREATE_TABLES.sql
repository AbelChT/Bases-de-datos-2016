-- Almacena las ciudades con su correspondiente nombre,
-- estado y pais
CREATE TABLE ciudad (
  id     INTEGER PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  estado VARCHAR(50) NOT NULL,
  pais   VARCHAR(50) NOT NULL,
  UNIQUE (nombre, estado, pais)
);

-- Almacena los aeropuertos, su IATA, sus coordenadas, y su ciudad de ubicacion
CREATE TABLE aeropuerto (
  iata     VARCHAR(4) PRIMARY KEY, -- Hay aereopuertos con iata de 4 letras
  oaci     VARCHAR(4) UNIQUE,
  nombre   VARCHAR(40),
  longitud FLOAT,
  latitud  FLOAT,
  ciudad   INTEGER REFERENCES ciudad (id) ON DELETE SET NULL
);

-- Almacena los diferentes modelos que existen de aviones, asi como su
-- nombre y el fabricante de cada modelo
CREATE TABLE modelo_de_avion (
  id         INTEGER PRIMARY KEY,
  nombre     VARCHAR(50)  NOT NULL,
  fabricante VARCHAR(100) NOT NULL,
  tipo_motor VARCHAR(50),
  tipo_avion VARCHAR(50),
  UNIQUE (nombre, fabricante)
);

-- Almacena los datos de cada avion, es decir, su tailname,
-- el modelo del avion, etcetera
--(Se permiten aviones sin modelo)
CREATE TABLE avion (
  id                INTEGER PRIMARY KEY,
  numero_de_cola    VARCHAR(7) NOT NULL,
  modelo            INTEGER REFERENCES modelo_de_avion (id) ON DELETE SET NULL,
  fecha_de_registro INTEGER,-- DATE,
  UNIQUE (numero_de_cola, fecha_de_registro)
);

-- Almacena las aerolíneas con su nombre y su IATA correspondiente
CREATE TABLE aerolinea (
  iata      VARCHAR(7) PRIMARY KEY, -- Para permitir los iata con ()
  nombre    VARCHAR(100),
  fundacion DATE,
  sede      INTEGER REFERENCES ciudad (id) ON DELETE SET NULL
);

-- Almacena los datos de cada vuelo (fisico) realizado, su numero
-- fecha, aerolinea que lo organiza, destino y origen, etcetera
CREATE TABLE vuelo (
  id                      INTEGER PRIMARY KEY,
  numero_vuelo            INTEGER,
  fecha                   DATE,
  avion                   INTEGER REFERENCES avion (id) ON DELETE SET NULL, -- Avion que realiza el vuelo
  aerolinea               VARCHAR(7) REFERENCES aerolinea (iata) ON DELETE SET NULL,
  destino                 VARCHAR(4) REFERENCES aeropuerto (iata) ON DELETE SET NULL,
  origen                  VARCHAR(4) REFERENCES aeropuerto (iata) ON DELETE SET NULL,
  hora_salida_programada  INTEGER,
  hora_salida_real        INTEGER,
  hora_despegue           INTEGER,
  hora_aterrizaje         INTEGER,
  hora_llegada_programada INTEGER,
  hora_llegada_real       INTEGER,
  distancia               FLOAT, -- Total incluyendo distancia producida por escalas
  UNIQUE (numero_vuelo, fecha, aerolinea,hora_salida_programada)
);

-- Relaciona cada vuelo con su(s) codigo(s) de cancelacion
CREATE TABLE vuelos_cancelados (--- Revisar
  vuelo  INTEGER REFERENCES vuelo (id) ON DELETE CASCADE,
  codigo VARCHAR(10),
  PRIMARY KEY (vuelo, codigo)
);

-- Relaciona cada vuelo con su el tipo/s de retraso que ha sufrido (causas)
CREATE TABLE vuelos_retrasados (
  vuelo INTEGER REFERENCES vuelo (id) ON DELETE CASCADE,
  --	tipos: por la compa�ia, por el temporal, por problemas con la seguridad,
  --	por problemas de seguridad del gobierno, por retraso en la llegada del avi�n
  causa VARCHAR(20),
  PRIMARY KEY (vuelo, causa)
);

-- Relaciona cada vuelo con las escalas de emergencia que ha tenido
CREATE TABLE escalas_emergencias (
  vuelo                INTEGER REFERENCES vuelo (id) ON DELETE CASCADE,
  avion                INTEGER REFERENCES avion (id) ON DELETE SET NULL,
  aeropuerto_escala    VARCHAR(4) REFERENCES aeropuerto (iata) ON DELETE SET NULL,
  hora_despegue        INTEGER,
  hora_aterrizaje      INTEGER,
  distancia_adiccional FLOAT,
  PRIMARY KEY (vuelo, hora_despegue)
);