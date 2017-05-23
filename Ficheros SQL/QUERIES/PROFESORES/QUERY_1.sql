SELECT COUNT(*) num, estado FROM (
	(SELECT estado FROM aeropuerto a1
	INNER JOIN ciudad c1 ON a1.ciudad = c1.estado
	INNER JOIN avion a ON a2.iata = a.origen
	INNER JOIN retrasados r ON r.vuelo = a.id)
	UNION ALL
	(SELECT estado FROM aeropuerto a1
	INNER JOIN ciudad c1 ON a1.ciudad = c1.estado
	INNER JOIN avion a ON a2.iata = a.destino
	INNER JOIN retrasados r ON r.vuelo = a.id)
) GROUP BY estado;
