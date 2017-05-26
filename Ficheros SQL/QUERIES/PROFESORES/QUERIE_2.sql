CREATE OR REPLACE VIEW m_edad_aviones_por_aeropuerto AS
SELECT  EXTRACT(YEAR FROM sysdate) -  avg(fecha_de_registro) AS media_edad, aeropuerto
FROM (
      (
        SELECT avion,origen AS aeropuerto
        FROM VUELO
      )
        UNION -- Evita datos repetidos
      (
        SELECT avion,destino AS aeropuerto
         FROM VUELO
      )
  )
INNER JOIN avion ON avion = avion.id AND avion.FECHA_DE_REGISTRO IS NOT NULL
GROUP BY aeropuerto;

SELECT aeropuerto.NOMBRE,m_edad_aviones_por_aeropuerto.media_edad
FROM m_edad_aviones_por_aeropuerto
INNER JOIN AEROPUERTO ON m_edad_aviones_por_aeropuerto.aeropuerto=aeropuerto.IATA
INNER JOIN (SELECT max(media_edad) AS maxima_edad FROM m_edad_aviones_por_aeropuerto) ON maxima_edad=m_edad_aviones_por_aeropuerto.media_edad;

DROP VIEW m_edad_aviones_por_aeropuerto;