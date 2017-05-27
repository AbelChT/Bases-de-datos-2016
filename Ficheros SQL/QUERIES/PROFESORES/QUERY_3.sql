-- Descripción de la tercera consulta obligatoria:bPor cada compañía aérea, lista
-- aquellas otras compañías que cubren al menos el 30% de sus trayectos
-- (aunque no coincidan en fechas y horarios), ordenándolo de
-- mayor a menor porcentaje de cobertura.

-- Contemplamos como un trayecto ir de A a B y otro diferente ir de B a A

-- Obtiene los diferentes vuelos de cada aerolínea

CREATE VIEW vuelos_aerolinea AS
	SELECT DISTINCT aerolinea, destino, origen 
	FROM vuelo;

-- Obtiene la cuenta de los diferentes vuelos de cada aerolínea

CREATE VIEW num_vuelos_aerol AS
	SELECT aerolinea, COUNT(*) as numero_vuelos
	FROM vuelos_aerolinea
	GROUP BY aerolinea;
	
-- Obtiene las coincidencias de cada aerolínea "A" con otra "B" distinta a esta en destino y origen
	
CREATE VIEW aerolineas_coincidencias AS
	SELECT a.aerolinea AS aerolinea_ppal, b.aerolinea  AS aerolinea_sec
	FROM vuelos_aerolinea a
	INNER JOIN vuelos_aerolinea b ON a.destino=b.destino AND a.origen=b.origen AND a.aerolinea!=b.aerolinea;
	
-- Obtiene la cuenta de las concidencias entre ambas aerolíneas

CREATE VIEW num_coinc_aerol AS
	SELECT aerolinea_ppal, aerolinea_sec, COUNT(*) as coincidencias
	FROM aerolineas_coincidencias
	GROUP BY aerolinea_ppal,aerolinea_sec;
	
-- Obtiene la relacion entre el número de vuelos de cada aerolínea y los que 
-- otra aerolínea cubre de esta ( la relacion coincidencias/total vuelos)

CREATE VIEW relaciones_vuelos AS
	SELECT aerolinea_ppal, aerolinea_sec, coincidencias, numero_vuelos
	FROM num_coinc_aerol
	INNER JOIN num_vuelos_aerol ON num_vuelos_aerol.aerolinea = num_coinc_aerol.aerolinea_ppal;
	
-- Obtiene el porcentaje de la relacion obtenida en la vista anterior para poder sacar
-- el resultado de la consulta

CREATE VIEW PORCENTAJES AS
SELECT aerolinea_ppal, aerolinea_sec, ((coincidencias/numero_vuelos)*100) AS porcent
FROM relaciones_vuelos
ORDER BY porcent DESC;

-- Obtenemos como resultado los pares de aerolíneas cuya coincidencia supera el 30%

SELECT * FROM PORCENTAJES
WHERE porcent >=30;

-- Elimina las vistas

DROP VIEW vuelos_aerolinea;
DROP VIEW num_vuelos_aerol;
DROP VIEW aerolineas_coincidencias;
DROP VIEW num_coinc_aerol;
DROP VIEW relaciones_vuelos;
DROP VIEW porcentajes;
	

