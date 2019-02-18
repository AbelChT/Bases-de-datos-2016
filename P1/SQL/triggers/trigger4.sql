CREATE OR REPLACE TRIGGER empates_del
  AFTER DELETE
  ON partido
  FOR EACH ROW
  DECLARE
    a NUMBER;
    b NUMBER;
BEGIN
    --
    -- NUMERO EMPATES
    --
    DELETE FROM empates
    WHERE temporada = OLD.idTemp AND
      (equipo = OLD.equipo_local OR equipo = OLD.equipo_visitante);

    -- Equipo local (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*) INTO a FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = OLD.equipo_local AND idTemp = OLD.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*) INTO b FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = OLD.equipo_local AND idTemp = OLD.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (OLD.idTemp, OLD.equipo_local, a + b);

    -- Equipo visitante (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*) INTO a FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = OLD.equipo_visitante AND idTemp = OLD.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*) INTO b FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = OLD.equipo_visitante AND idTemp = OLD.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (OLD.idTemp, OLD.equipo_visitante, a + b);

  END;
  /
