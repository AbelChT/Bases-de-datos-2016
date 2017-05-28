SELECT COUNT(*) num, estado FROM (
	(SELECT estado FROM VUELOS_RETRASADOS r
	INNER JOIN VUELO v ON v.ID = r.vuelo
	INNER JOIN aeropuerto a1 ON a1.IATA = v.ORIGEN
	INNER JOIN ciudad c1 ON a1.ciudad = c1.id
	INNER JOIN avion a ON a1.iata = a.numero_de_cola)
	UNION ALL
	(SELECT estado FROM VUELOS_RETRASADOS r
	INNER JOIN VUELO v ON v.ID = r.vuelo
	INNER JOIN aeropuerto a1 ON a1.IATA = v.DESTINO
	INNER JOIN ciudad c1 ON a1.ciudad = c1.id
	INNER JOIN avion a ON a1.iata = a.numero_de_cola)
) GROUP BY estado;
