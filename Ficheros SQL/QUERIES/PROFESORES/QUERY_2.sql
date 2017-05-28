-- Consulta obligatoria nº2
-- Descripción: Aeropuerto con los aviones más antiguos (mayor media de edad de
-- los aviones que operan en el aeropuerto)

-- Se presupone que los aviones que operan en cada aeropuerto son aquellos que realizan
-- trayectos con destino o con origen el aeropuerto concreto. No se tomarán como tal
-- aquellos que solamente hayan hecho escala por emergencia en ese aeropuerto

SELECT
  aeropuerto.NOMBRE, media_edad
FROM (SELECT -- Se obtiene la media de edad de los aviones que operan en cada aeropuerto
        EXTRACT(YEAR FROM sysdate) - avg(fecha_de_registro) AS media_edad, aeropuerto
      FROM( -- Se obtienen los aviones que operan en cada aeropuerto
        (
          SELECT
            avion,
            origen AS aeropuerto
          FROM VUELO
        )
        UNION -- Evita datos repetidos
        (
          SELECT
            avion,
            destino AS aeropuerto
          FROM VUELO
        )
        )
      INNER JOIN avion ON avion = avion.id AND avion.FECHA_DE_REGISTRO IS NOT NULL
      GROUP BY aeropuerto
      )   
INNER JOIN AEROPUERTO ON aeropuerto = aeropuerto.IATA
  -- Se obtiene el nombre del aeropuerto
INNER JOIN (      SELECT -- Se obtiene la media de edad de los aviones que operan en cada aeropuerto
                  max(EXTRACT(YEAR FROM sysdate) - avg(fecha_de_registro)) AS maxima_edad
                  FROM( -- Se obtienen los aviones que operan en cada aeropuerto
                    (
                      SELECT
                        avion,
                        origen AS aeropuerto
                      FROM VUELO
                    )
                    UNION -- Evita datos repetidos
                    (
                      SELECT
                        avion,
                        destino AS aeropuerto
                      FROM VUELO
                    )
                    )
                  INNER JOIN avion ON avion = avion.id AND avion.FECHA_DE_REGISTRO IS NOT NULL
                  GROUP BY aeropuerto
    -- Se obtiene la tupla aeropuerto, edad con el aeropuerto que posee de media aviones de mayor edad
    ) ON maxima_edad = media_edad;
