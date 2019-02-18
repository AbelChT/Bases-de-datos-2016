CREATE VIEW ciudades_escalas AS
	SELECT ciudad, distancia_adiccional
	FROM aeropuerto
	INNER JOIN escalas_emergencias ON aeropuerto.iata = escalas_emergencias.aeropuerto_escala AND distancia_adiccional > 0;

CREATE VIEW numero_escalas AS
	SELECT ciudad, COUNT(*) AS escalas, SUM(distancia_adiccional) AS distancia
	FROM ciudades_escalas
	GROUP BY ciudad;

CREATE VIEW max_escalas AS
	SELECT ciudad, escalas,distancia
	FROM numero_escalas
	WHERE escalas = (
		SELECT MAX(escalas) FROM numero_escalas);
	
SELECT nombre, escalas,distancia
FROM ciudad
INNER JOIN max_escalas ON ciudad.id = max_escalas.ciudad
ORDER BY distancia DESC;

DROP VIEW ciudades_escalas;
DROP VIEW numero_escalas;
DROP VIEW max_escalas;