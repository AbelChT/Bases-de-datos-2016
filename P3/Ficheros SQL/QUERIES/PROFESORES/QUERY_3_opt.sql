-- Tercera consulta obligatoria: Por cada compañía aérea, lista aquellas otras compañías que cubren al menos el
-- 30% de sus trayectos (aunque no coincidan en fechas y horarios), ordenándolo de
-- mayor a menor porcentaje de cobertura

-- Contemplamos como un trayecto ir de A a B y otro diferente ir de B a A

SELECT A.NOMBRE AS aerolinea_1, B.NOMBRE  AS aerolinea_2, ((coincidencias/numero_vuelos)*100) AS porcent
FROM( SELECT a.aerolinea AS aerolinea_ppal, b.aerolinea  AS aerolinea_sec, COUNT(*) as coincidencias
	    FROM viaje a
	    INNER JOIN viaje b ON a.destino=b.destino 
		AND a.origen=b.origen AND a.aerolinea!=b.aerolinea
	    GROUP BY (a.AEROLINEA,b.AEROLINEA))
INNER JOIN( SELECT aerolinea as aerolinea_contar, COUNT(*) as numero_vuelos
	          FROM viaje
	          GROUP BY aerolinea) ON aerolinea_contar = aerolinea_ppal 
			  AND ((coincidencias/numero_vuelos)>=0.3)
INNER JOIN AEROLINEA A ON aerolinea_ppal=A.IATA
INNER JOIN AEROLINEA B ON aerolinea_sec=B.IATA
ORDER BY porcent DESC;
