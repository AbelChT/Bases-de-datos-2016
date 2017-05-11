-- Almacena los aeropuertos, su IATA, sus coordenadas, y su ciudad de ubicaci�n
CREATE TABLE aeropuerto (
    IATA VARCHAR(3) PRIMARY KEY,
	longitud FLOAT,
	latitud	FLOAT,
    ciudad VARCHAR(50) REFERENCES ciudad(id) ON DELETE CASCADE,
);

-- Almacena las ciudades con su correspondiente nombre,
-- estado y pa�s
CREATE TABLE ciudad (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(50),
    estado VARCHAR(50),
    pais VARCHAR(50)
);

-- Almacena los datos de cada vuelo (f�sico) realizado, su numero
-- fecha, aerol�nea que lo organiza, destino y origen, etc�tera
CREATE TABLE vuelo (
  	id INTEGER PRIMARY KEY,
   	numero_vuelo INTEGER,
   	fecha DATE,
	avion VARCHAR(5) REFERENCES avion(tailname) ON DELETE CASCADE, 
   	aerolinea VARCHAR(2) REFERENCES aerolinea(iata) ON DELETE CASCADE,
   	destino VARCHAR(3) REFERENCES aeropuerto(iata) ON DELETE CASCADE,
   	origen VARCHAR(3) REFERENCES aeropuerto(iata) ON DELETE CASCADE,
	hora_salida_programada INTEGER,
	hora_salida_real	INTEGER,
	hora_despegue	INTEGER,
	hora_aterrizaje	INTEGER,
	hora_llegada_programada INTEGER,
	hora_llegada_real	INTEGER,
	distancia	FLOAT
);

-- Almacena los datos de cada avi�n, es decir, su tailname,
-- el modelo del avi�n, etc�tera
CREATE TABLE  avion (
	tailname VARCHAR(5) PRIMARY KEY,	
	modelo INTEGER REFERENCES modelo(id) ON DELETE CASCADE,  
	-- otros campos
);

-- Almacena los diferentes modelos que existen de aviones, as� como su
-- nombre y el fabricante de cada modelo
CREATE TABLE  modelo (
  	id INTEGER PRIMARY KEY,
   	nombre VARCHAR(50),
	fabricante VARCHAR(100)
	-- otros campos
);

-- Relaciona cada vuelo con el avi�n que lo realiza
--CREATE TABLE avion_vuelo (
--    vuelo INTEGER REFERENCES vuelo(id) ON DELETE CASCADE,
--    avion VARCHAR(5) REFERENCES avion(tailname) ON DELETE CASCADE,
--    PRIMARY KEY (vuelo,avion)
--);

-- Almacena las aerol�neas con su nombre y su IATA correspondiente
CREATE TABLE aerolinea (
	iata VARCHAR(2) PRIMARY KEY,
	nombre VARCHAR(100)
);

-- Relaciona cada vuelo con su codigo de cancelaci�n
CREATE TABLE vuelos_cancelados (
	vuelo INTEGER REFERENCES vuelo(id) ON DELETE CASCADE,
	codigo INTEGER,
	PRIMARY KEY(vuelo)
);

-- Relaciona cada vuelo con su el tipo/s de retraso que ha sufrido (causas)
CREATE TABLE vuelos_retrasados (
	vuelo INTEGER REFERENCES vuelo(id) ON DELETE CASCADE,
	tipo VARCHAR(20),
--	tipos: por la compa�ia, por el temporal, por problemas con la seguridad,
--	por problemas de seguridad del gobierno, por retraso en la llegada del avi�n
	PRIMARY KEY(vuelo,tipo)
); 

-- Relaciona cada vuelo con las escalas de emergencia que ha tenido
CREATE TABLE escalas (
	vuelo INTEGER REFERENCES vuelo(id) ON DELETE CASCADE,
	avion VARCHAR(5) REFERENCES avion(tailname) ON DELETE CASCADE, 
   	aerolinea VARCHAR(2) REFERENCES aerolinea(iata) ON DELETE CASCADE,
   	aeropuerto_escala VARCHAR(3) REFERENCES aeropuerto(iata) ON DELETE CASCADE,
	hora_despegue	INTEGER,
	hora_aterrizaje	INTEGER,
	distancia_adiccional	FLOAT,
	PRIMARY KEY(vuelo,hora_despegue)
);















