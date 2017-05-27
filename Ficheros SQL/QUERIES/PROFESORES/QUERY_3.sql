-- Contemplamos como un trayecto ir de A a B y otro diferente ir de B a A
CREATE VIEW vuelos_aerolinea AS
	SELECT DISTINCT aerolinea, destino, origen 
	FROM vuelo;

CREATE VIEW num_vuelos_aerol AS
	SELECT aerolinea, COUNT(*) as numero_vuelos
	FROM vuelos_aerolinea
	GROUP BY aerolinea;
	
CREATE VIEW aerolineas_coincidencias AS
	SELECT a.aerolinea AS aerolinea_ppal, b.aerolinea  AS aerolinea_sec
	FROM vuelos_aerolinea a
	INNER JOIN vuelos_aerolinea b ON a.destino=b.destino AND a.origen=b.origen AND a.aerolinea!=b.aerolinea;

CREATE VIEW num_coinc_aerol AS
	SELECT aerolinea_ppal, aerolinea_sec, COUNT(*) as coincidencias
	FROM aerolineas_coincidencias
	GROUP BY aerolinea_ppal,aerolinea_sec;
	
CREATE VIEW relaciones_vuelos AS
	SELECT aerolinea_ppal, aerolinea_sec, coincidencias, numero_vuelos
	FROM num_coinc_aerol
	INNER JOIN num_vuelos_aerol ON num_vuelos_aerol.aerolinea = num_coinc_aerol.aerolinea_ppal;
	
CREATE VIEW PORCENTAJES AS
SELECT aerolinea_ppal, aerolinea_sec, ((coincidencias/numero_vuelos)*100) AS porcent
FROM relaciones_vuelos
ORDER BY porcent DESC;

SELECT * FROM PORCENTAJES
WHERE porcent >=30;

DROP VIEW vuelos_aerolinea;
DROP VIEW num_vuelos_aerol;
DROP VIEW aerolineas_coincidencias;
DROP VIEW num_coinc_aerol;
DROP VIEW relaciones_vuelos;
DROP VIEW porcentajes;
	

