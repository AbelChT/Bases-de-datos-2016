CREATE OR REPLACE TRIGGER empates
  AFTER DELETE OR INSERT OR UPDATE
  OF goles_local, goles_visitante, jornada
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
    WHERE temporada = NEW.idTemp AND
      (equipo = NEW.equipo_local OR equipo = NEW.equipo_visitante);

    -- Equipo local (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*) INTO a FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = NEW.equipo_local AND idTemp = NEW.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*) INTO b FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = NEW.equipo_local AND idTemp = NEW.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (NEW.idTemp, NEW.equipo_local, a + b);

    -- Equipo visitante (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*) INTO a FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = NEW.equipo_visitante AND idTemp = NEW.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*) INTO b FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = NEW.equipo_visitante AND idTemp = NEW.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (NEW.idTemp, NEW.equipo_visitante, a + b);

  END;
  /
