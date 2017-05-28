SELECT COUNT(*) num, estado FROM (
	(SELECT estado FROM aeropuerto a1
	INNER JOIN ciudad c1 ON a1.ciudad = c1.estado
	INNER JOIN avion a ON a1.iata = a.numero_de_cola
	INNER JOIN VUELOS_RETRASADOS r ON r.vuelo = a.id)
	UNION ALL
	(SELECT estado FROM aeropuerto a2
	INNER JOIN ciudad c1 ON a2.ciudad = c1.estado
	INNER JOIN avion a ON a2.iata = a.numero_de_cola
	INNER JOIN VUELOS_RETRASADOS r ON r.vuelo = a.id)
) GROUP BY estado;
