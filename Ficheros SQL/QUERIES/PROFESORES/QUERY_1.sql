SELECT COUNT(*) num, estado FROM (
	(SELECT estado FROM VUELOS_RETRASADOS r
	INNER JOIN VUELO v ON v.ID = r.vuelo
	INNER JOIN aeropuerto a1 ON a1.IATA = v.ORIGEN
	INNER JOIN ciudad c1 ON a1.ciudad = c1.id
	WHERE EXISTS(SELECT id FROM escalas_emergencias WHERE vuelo = v.id))
	UNION ALL
	(SELECT estado FROM VUELOS_RETRASADOS r
	INNER JOIN VUELO v ON v.ID = r.vuelo
	INNER JOIN aeropuerto a1 ON a1.IATA = v.DESTINO
	INNER JOIN ciudad c1 ON a1.ciudad = c1.id
	WHERE EXISTS(SELECT id FROM escalas_emergencias WHERE vuelo = v.id))
) GROUP BY estado;
