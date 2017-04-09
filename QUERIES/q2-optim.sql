CREATE OR REPLACE VIEW media_goles_v AS
SELECT
  TEMPORADA AS TEMP_,
  EQUIPO,
  GOLES / NUMERO_PARTIDOS_JUGADOS AS media
FROM MEDIA_GOLES
  WHERE GOLES / NUMERO_PARTIDOS_JUGADOS >= 3;

SELECT
  TEMPORADA.ANYO,
  TEMPORADA.DIVISION,
  EQUIPO,
  media
FROM media_goles_v
  INNER JOIN TEMPORADA ON media_goles_v.TEMP_ = TEMPORADA.ID;