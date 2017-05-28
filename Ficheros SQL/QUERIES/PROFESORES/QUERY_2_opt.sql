-- Optimización de la consulta obligatoria nº2 mediante el uso de diseño fisico
-- Descripción: Aeropuerto con los aviones más antiguos (mayor media de edad de
-- los aviones que operan en el aeropuerto)

-- Se presupone que los aviones que operan en cada aeropuerto son aquellos que realizan
-- trayectos con destino o con origen el aeropuerto concreto. No se tomarán como tal
-- aquellos que solamente hayan hecho escala por emergencia en ese aeropuerto

SELECT
  aeropuerto.nombre, EXTRACT(YEAR FROM sysdate) -  media_creacion
FROM (SELECT -- Se obtiene la media de registro de los aviones que operan en cada aeropuerto
        AVG(fecha_de_registro) AS media_creacion, aeropuerto
      FROM aviones_aeropuerto
      INNER JOIN avion ON avion = avion.id AND avion.fecha_de_registro IS NOT NULL
      GROUP BY aeropuerto
      )
INNER JOIN AEROPUERTO ON aeropuerto = aeropuerto.iata -- Se obtiene el nombre del aeropuerto
INNER JOIN (      SELECT -- Se obtiene la media registro de los aviones que operan en cada aeropuerto
                  MIN(AVG(fecha_de_registro)) AS maxima_edad
                  FROM aviones_aeropuerto
                  INNER JOIN avion ON avion = avion.id AND avion.fecha_de_registro IS NOT NULL
                  GROUP BY aeropuerto
    ) ON maxima_edad = media_creacion;
