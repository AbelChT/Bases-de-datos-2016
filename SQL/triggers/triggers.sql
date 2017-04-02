/*DROP TRIGGER empates;
DROP TRIGGER empates_del;
DROP TRIGGER goles_avr;
DROP TRIGGER goles_avr_del;
DROP TRIGGER overlap;
DROP TRIGGER overlap_del;
--DROP TRIGGER temp_closed;
--DROP TRIGGER temp_closed_del;*/

--SELECT text FROM user_errors WHERE type='TRIGGER';
--SELECT dump('DESC empates', 16) FROm dual;

CREATE OR REPLACE TRIGGER goles_avr
AFTER INSERT OR UPDATE
OF goles_local, goles_visitante, jornada
  ON partido
FOR EACH ROW
  DECLARE
	  PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
    c NUMBER;
  BEGIN

    --
    -- MEDIA GOLES
    --
    DELETE FROM goles
    WHERE temporada = :NEW.idTemp AND
          (equipo = :NEW.equipo_local OR equipo = :NEW.equipo_visitante);

    -- Equipo local (eq)
    -- Suma de goles de eq como equipo local en esta temporada.
    SELECT SUM(goles_local) INTO a
    FROM partido
    WHERE equipo_local = :NEW.equipo_local AND idTemp = :NEW.idTemp;
    -- Suma de goles de eq como equipo visitante en esta temporada.
    SELECT SUM(goles_visitante) INTO b
    FROM partido
    WHERE equipo_visitante = :NEW.equipo_local AND idTemp = :NEW.idTemp;
    -- Cuantos partidos ha disputado eq en esta temporada.
    SELECT COUNT(*) INTO c
    FROM partido
    WHERE equipo_local = :NEW.equipo_local OR equipo_visitante = :NEW.equipo_local;
    -- Volcar el resultado a la tabla goles.
    INSERT INTO goles (temporada, equipo, goles) VALUES (:NEW.idTemp, :NEW.equipo_local, (a + b) / c);

    -- Equipo visitante
    SELECT SUM(goles_local) INTO a
    FROM partido
    WHERE equipo_local = :NEW.equipo_visitante AND idTemp = :NEW.idTemp;
    SELECT SUM(goles_visitante) INTO b
    FROM partido
    WHERE equipo_visitante = :NEW.equipo_visitante AND idTemp = :NEW.idTemp;
    SELECT COUNT(*) INTO c
    FROM partido
    WHERE equipo_local = :NEW.equipo_visitante OR equipo_visitante = :NEW.equipo_visitante;
    INSERT INTO goles (temporada, equipo, goles) VALUES (:NEW.idTemp, :NEW.equipo_visitante, (a + b) / c);

   	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER empates
AFTER INSERT OR UPDATE
OF goles_local, goles_visitante, jornada
  ON partido
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
  BEGIN
    --
    -- NUMERO EMPATES
    --
    DELETE FROM empates
    WHERE temporada = :NEW.idTemp AND
          (equipo = :NEW.equipo_local OR equipo = :NEW.equipo_visitante);

    -- Equipo local (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*)
    INTO a
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = :NEW.equipo_local AND idTemp = :NEW.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*)
    INTO b
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = :NEW.equipo_local AND idTemp = :NEW.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (:NEW.idTemp, :NEW.equipo_local, a + b);

    -- Equipo visitante (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*)
    INTO a
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = :NEW.equipo_visitante AND idTemp = :NEW.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*)
    INTO b
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = :NEW.equipo_visitante AND idTemp = :NEW.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (:NEW.idTemp, :NEW.equipo_visitante, a + b);

	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER goles_avr_del
AFTER DELETE
  ON partido
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
    c NUMBER;
  BEGIN
    --
    -- MEDIA GOLES
    --
    DELETE FROM goles
    WHERE temporada = :OLD.idTemp AND
          (equipo = :OLD.equipo_local OR equipo = :OLD.equipo_visitante);

    -- Equipo local (eq)
    -- Suma de goles de eq como equipo local en esta temporada.
    SELECT SUM(goles_local)
    INTO a
    FROM partido
    WHERE equipo_local = :OLD.equipo_local AND idTemp = :OLD.idTemp;
    -- Suma de goles de eq como equipo visitante en esta temporada.
    SELECT SUM(goles_local)
    INTO b
    FROM partido
    WHERE equipo_visitante = :OLD.equipo_local AND idTemp = :OLD.idTemp;
    -- Cuantos partidos ha disputado eq en esta temporada.
    SELECT COUNT(*)
    INTO c
    FROM partido
    WHERE equipo_local = :OLD.equipo_local OR equipo_visitante = :OLD.equipo_local;
    -- Volcar el resultado a la tabla goles.
    INSERT INTO goles (temporada, equipo, goles) VALUES (:OLD.idTemp, :OLD.equipo_local, (a + b) / c);

    -- Equipo visitante
    SELECT SUM(goles_local)
    INTO a
    FROM partido
    WHERE equipo_local = :OLD.equipo_visitante AND idTemp = :OLD.idTemp;
    SELECT SUM(goles_local)
    INTO b
    FROM partido
    WHERE equipo_visitante = :OLD.equipo_visitante AND idTemp = :OLD.idTemp;
    SELECT COUNT(*)
    INTO c
    FROM partido
    WHERE equipo_local = :OLD.equipo_visitante OR equipo_visitante = :OLD.equipo_visitante;
    INSERT INTO goles (temporada, equipo, goles) VALUES (:OLD.idTemp, :OLD.equipo_visitante, (a + b) / c);
	
	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER empates_del
AFTER DELETE
  ON partido
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
  BEGIN
    --
    -- NUMERO EMPATES
    --
    DELETE FROM empates
    WHERE temporada = :OLD.idTemp AND
          (equipo = :OLD.equipo_local OR equipo = :OLD.equipo_visitante);

    -- Equipo local (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*)
    INTO a
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = :OLD.equipo_local AND idTemp = :OLD.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*)
    INTO b
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = :OLD.equipo_local AND idTemp = :OLD.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (:OLD.idTemp, :OLD.equipo_local, a + b);

    -- Equipo visitante (eq)
    -- Cuantos partidos ha empatado eq como equipo visitante
    SELECT COUNT(*)
    INTO a
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_visitante = :OLD.equipo_visitante AND idTemp = :OLD.idTemp;
    -- Cuantos partidos ha empatado eq como equipo local
    SELECT COUNT(*)
    INTO b
    FROM partido
    WHERE goles_local = goles_visitante AND equipo_local = :OLD.equipo_visitante AND idTemp = :OLD.idTemp;
    -- Volcar el resultado a la tabla empates.
    INSERT INTO empates (temporada, equipo, num) VALUES (:OLD.idTemp, :OLD.equipo_visitante, a + b);

	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER overlap
BEFORE INSERT OR UPDATE
  ON residir
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    num NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO num
    FROM residir
    WHERE (:NEW.fin > fin AND :NEW.inicio < fin);
    IF (:NEW.inicio > :NEW.fin OR num = 1)
    THEN
      RAISE_APPLICATION_ERROR(1, 'Colapso de tiempos o inicio > fin');
    END IF;
	
	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER overlap_del
BEFORE DELETE
  ON residir
FOR EACH ROW
  DECLARE
    num NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO num
    FROM residir
    WHERE (:OLD.fin > fin AND :OLD.inicio < fin);
    IF (:OLD.inicio > :OLD.fin OR num = 1)
    THEN
      RAISE_APPLICATION_ERROR(1, 'Colapso de tiempos o inicio > fin');
    END IF;
	COMMIT;
  END;
/

/*
CREATE OR REPLACE TRIGGER temp_closed
BEFORE INSERT OR UPDATE
  ON partido
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    num NUMBER;
  BEGIN
    SELECT finalizada
    INTO num
    FROM temporada
    WHERE id = :NEW.idTemp;
    IF (num = 1)
    THEN
      RAISE_APPLICATION_ERROR(1, 'Temporada finalizada');
    END IF;
	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER temp_closed_del
BEFORE DELETE
  ON partido
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    num NUMBER;
  BEGIN
    SELECT finalizada
    INTO num
    FROM temporada
    WHERE id = :OLD.idTemp;
    IF (num = 1)
    THEN
      RAISE_APPLICATION_ERROR(1, 'Temporada finalizada');
    END IF;
	COMMIT;
  END;
/ */