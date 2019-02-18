CREATE OR REPLACE TRIGGER goles_avr_del
  AFTER DELETE
  ON partido
  FOR EACH ROW
  DECLARE
    a NUMBER;
    b NUMBER;
    c NUMBER;
BEGIN
    --
    -- MEDIA GOLES
    --
    DELETE FROM goles
    WHERE temporada = OLD.idTemp AND
      (equipo = OLD.equipo_local OR equipo = OLD.equipo_visitante);

    -- Equipo local (eq)
    -- Suma de goles de eq como equipo local en esta temporada.
    SELECT SUM(goles_local) INTO a FROM partido
    WHERE equipo_local = OLD.equipo_local AND idTemp = OLD.idTemp;
    -- Suma de goles de eq como equipo visitante en esta temporada.
    SELECT SUM(goles_local) INTO b FROM partido
    WHERE equipo_visitante = OLD.equipo_local AND idTemp = OLD.idTemp;
    -- Cuantos partidos ha disputado eq en esta temporada.
    SELECT COUNT(*) INTO c FROM partido
    WHERE equipo_local = OLD.equipo_local OR equipo_visitante = OLD.equipo_local;
    -- Volcar el resultado a la tabla goles.
    INSERT INTO goles (temporada, equipo, goles) VALUES (OLD.idTemp, OLD.equipo_local, (a + b) / c);

    -- Equipo visitante
    SELECT SUM(goles_local) INTO a FROM partido
    WHERE equipo_local = OLD.equipo_visitante AND idTemp = OLD.idTemp;
    SELECT SUM(goles_local) INTO b FROM partido
    WHERE equipo_visitante = OLD.equipo_visitante AND idTemp = OLD.idTemp;
    SELECT COUNT(*) INTO c FROM partido
    WHERE equipo_local = OLD.equipo_visitante OR equipo_visitante = OLD.equipo_visitante;
    INSERT INTO goles (temporada, equipo, goles) VALUES (OLD.idTemp, OLD.equipo_visitante, (a + b) / c);
  END;
  /
