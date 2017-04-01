CREATE OR REPLACE TRIGGER goles_avr
  AFTER DELETE OR INSERT OR UPDATE
  OF goles_local, goles_visitante, jornada
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
    WHERE temporada = NEW.idTemp AND
      (equipo = NEW.equipo_local OR equipo = NEW.equipo_visitante);

    -- Equipo local (eq)
    -- Suma de goles de eq como equipo local en esta temporada.
    SELECT SUM(goles_local) INTO a FROM partido
    WHERE equipo_local = NEW.equipo_local AND idTemp = NEW.idTemp;
    -- Suma de goles de eq como equipo visitante en esta temporada.
    SELECT SUM(goles_local) INTO b FROM partido
    WHERE equipo_visitante = NEW.equipo_local AND idTemp = NEW.idTemp;
    -- Cuantos partidos ha disputado eq en esta temporada.
    SELECT COUNT(*) INTO c FROM partido
    WHERE equipo_local = NEW.equipo_local OR equipo_visitante = NEW.equipo_local;
    -- Volcar el resultado a la tabla goles.
    INSERT INTO goles (temporada, equipo, goles) VALUES (NEW.idTemp, NEW.equipo_local, (a + b) / c);

    -- Equipo visitante
    SELECT SUM(goles_local) INTO a FROM partido
    WHERE equipo_local = NEW.equipo_visitante AND idTemp = NEW.idTemp;
    SELECT SUM(goles_local) INTO b FROM partido
    WHERE equipo_visitante = NEW.equipo_visitante AND idTemp = NEW.idTemp;
    SELECT COUNT(*) INTO c FROM partido
    WHERE equipo_local = NEW.equipo_visitante OR equipo_visitante = NEW.equipo_visitante;
    INSERT INTO goles (temporada, equipo, goles) VALUES (NEW.idTemp, NEW.equipo_visitante, (a + b) / c);
  END;
  /
