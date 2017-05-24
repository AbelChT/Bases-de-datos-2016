-- Aviones que operan en cada aeropuerto
CREATE VIEW aereopuerto_aviones AS
(SELECT avion,origen AS aeropuerto
FROM VUELO)
UNION -- Evita datos repetidos
(SELECT avion,destino AS aeropuerto
FROM VUELO
);

CREATE VIEW fecha_inscripcion_aeropuerto AS
SELECT avg(CURRENT_DATE - fecha_de_registro) AS media_edad,aereopuerto_aviones.aeropuerto
FROM aereopuerto_aviones
INNER JOIN avion ON aereopuerto_aviones.avion = avion.id AND avion.FECHA_DE_REGISTRO IS NOT NULL
GROUP BY aereopuerto_aviones.aeropuerto;


SELECT aeropuerto
FROM fecha_inscripcion_aeropuerto
INNER JOIN AEROPUERTO ON fecha_inscripcion_aeropuerto.aeropuerto=aeropuerto.IATA
WHERE fecha_inscripcion_aeropuerto.media_edad IN
(
SELECT max(media_edad) AS maxima_edad
FROM fecha_inscripcion_aeropuerto
);


