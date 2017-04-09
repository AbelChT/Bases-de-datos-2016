--
-- Descripción: Esta optimización crea la tabla empates en la cual se almacena en cada temporada
-- por cada equipo el número de empates que ha tenido mediante triggers. De esta forma es rápido
-- obtener el equipo que más empates obtuvo cada temporada
--

CREATE TABLE empates (
    temporada INTEGER REFERENCES temporada(id),
    equipo VARCHAR(100) REFERENCES equipo(nombre_oficial),
    num INTEGER,
    PRIMARY KEY (temporada, equipo)
);

-- Trigger que precalcula los empates al realizar insert
CREATE OR REPLACE TRIGGER empates_insert
AFTER INSERT
  ON partido
  FOR EACH ROW
    DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
BEGIN
    IF :NEW.GOLES_LOCAL=:NEW.GOLES_VISITANTE THEN
      --Equipo local
       SELECT count(*)
       INTO a
        FROM empates
        WHERE equipo= :NEW.EQUIPO_LOCAL  AND TEMPORADA = :NEW.IDTEMP;

      IF(a>0) THEN
        UPDATE empates
        SET num=num+1
        WHERE equipo= :NEW.EQUIPO_LOCAL AND TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO empates(temporada,equipo,num) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_LOCAL,1);
      END IF;

      --Equipo visitante
      SELECT count(*)
      INTO b
        FROM empates
        WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;

      IF(b>0) THEN
        UPDATE empates
        SET num=num+1
        WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO empates(temporada,equipo,num) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_VISITANTE,1);

      END IF;
    END IF;
	COMMIT;
END;
/

-- Trigger que precalcula los empates al realizar update
CREATE OR REPLACE TRIGGER empates_update
AFTER UPDATE
  ON partido
  FOR EACH ROW
    DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
BEGIN
      -- Elimino el registro de empates
    IF :OLD.GOLES_LOCAL=:OLD.GOLES_VISITANTE THEN
      UPDATE empates
        SET num=num-1
        WHERE (equipo = :OLD.EQUIPO_LOCAL) OR (equipo = :OLD.EQUIPO_VISITANTE) AND TEMPORADA = :OLD.IDTEMP;
    END IF;

      -- Pongo el nuevo registro de empates
    IF :NEW.GOLES_LOCAL=:NEW.GOLES_VISITANTE THEN
      --Equipo local
       SELECT count(*)
       INTO a
        FROM empates
        WHERE equipo= :NEW.EQUIPO_LOCAL  AND TEMPORADA = :NEW.IDTEMP;

      IF(a>0) THEN
        UPDATE empates
        SET num=num+1
        WHERE equipo= :NEW.EQUIPO_LOCAL AND TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO empates(temporada,equipo,num) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_LOCAL,1);
      END IF;

      --Equipo visitante
      SELECT count(*)
      INTO b
        FROM empates
        WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;

      IF(b>0) THEN
        UPDATE empates
        SET num=num+1
        WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO empates(temporada,equipo,num) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_VISITANTE,1);

      END IF;
    END IF;

	COMMIT;
END;
/

-- Trigger que precalcula los empates al realizar delete
CREATE OR REPLACE TRIGGER empates_delete
AFTER DELETE
  ON partido
  FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
      IF :OLD.GOLES_LOCAL=:OLD.GOLES_VISITANTE THEN
        UPDATE empates
        SET num=num-1
        WHERE (equipo = :OLD.EQUIPO_LOCAL) OR (equipo = :OLD.EQUIPO_VISITANTE) AND TEMPORADA = :OLD.IDTEMP;
      END IF;
	  COMMIT;
END;
/



--
-- Descripción: Esta optimización crea la tabla media_goles, en la cual por cada se almacena
-- el numero de goles marcados por cada equipo cada temporada y el número de partidos jugados
-- por este equipo mediante triggers. De esta forma podemos obtener de una manera muy rápida la media de goles
-- de un equipo en una temporada.
--

CREATE TABLE media_goles (
  equipo                  VARCHAR(100) REFERENCES equipo (nombre_oficial),
  temporada               INTEGER REFERENCES temporada (id),
  goles                   INTEGER,
  numero_partidos_jugados INTEGER,
  PRIMARY KEY (equipo, temporada)
);

CREATE OR REPLACE TRIGGER media_goles_insert
AFTER INSERT
  ON partido
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
  BEGIN
    --Equipo local
    SELECT count(*)
    INTO a
    FROM media_goles
    WHERE equipo = :NEW.EQUIPO_LOCAL AND TEMPORADA = :NEW.IDTEMP;

    IF (a > 0)
    THEN
      UPDATE media_goles
      SET goles                 = goles + :NEW.GOLES_LOCAL,
        numero_partidos_jugados = numero_partidos_jugados + 1
      WHERE equipo = :NEW.EQUIPO_LOCAL AND TEMPORADA = :NEW.IDTEMP;
    ELSE
      INSERT INTO media_goles (temporada, equipo, numero_partidos_jugados, goles)
      VALUES (:NEW.IDTEMP, :NEW.EQUIPO_LOCAL, 1, :NEW.GOLES_LOCAL);
    END IF;

    --Equipo visitante
    SELECT count(*)
    INTO b
    FROM media_goles
    WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;

    IF (b > 0)
    THEN
      UPDATE media_goles
      SET goles                 = goles + :NEW.GOLES_VISITANTE,
        numero_partidos_jugados = numero_partidos_jugados + 1
      WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;
    ELSE
      INSERT INTO media_goles (temporada, equipo, numero_partidos_jugados, goles)
      VALUES (:NEW.IDTEMP, :NEW.EQUIPO_VISITANTE, 1, :NEW.GOLES_VISITANTE);
    END IF;
	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER media_goles_update
AFTER UPDATE
  ON partido
FOR EACH ROW
  DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
    a NUMBER;
    b NUMBER;
  BEGIN
    -- Equipo local
    UPDATE media_goles
    SET goles                 = goles - :OLD.GOLES_LOCAL,
      numero_partidos_jugados = numero_partidos_jugados - 1
    WHERE equipo = :OLD.EQUIPO_LOCAL AND TEMPORADA = :OLD.IDTEMP;

    -- Equipo visitante
    UPDATE media_goles
    SET goles                 = goles - :OLD.GOLES_VISITANTE,
      numero_partidos_jugados = numero_partidos_jugados - 1
    WHERE equipo = :OLD.EQUIPO_VISITANTE AND TEMPORADA = :OLD.IDTEMP;

    --Equipo local
    SELECT count(*)
    INTO a
    FROM media_goles
    WHERE equipo = :NEW.EQUIPO_LOCAL AND TEMPORADA = :NEW.IDTEMP;

    IF (a > 0)
    THEN
      UPDATE media_goles
      SET goles                 = goles + :NEW.GOLES_LOCAL,
        numero_partidos_jugados = numero_partidos_jugados + 1
      WHERE equipo = :NEW.EQUIPO_LOCAL AND TEMPORADA = :NEW.IDTEMP;
    ELSE
      INSERT INTO media_goles (temporada, equipo, numero_partidos_jugados, goles)
      VALUES (:NEW.IDTEMP, :NEW.EQUIPO_LOCAL, 1, :NEW.GOLES_LOCAL);
    END IF;

    --Equipo visitante
    SELECT count(*)
    INTO b
    FROM media_goles
    WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;

    IF (b > 0)
    THEN
      UPDATE media_goles
      SET goles                 = goles + :NEW.GOLES_VISITANTE,
        numero_partidos_jugados = numero_partidos_jugados + 1
      WHERE equipo = :NEW.EQUIPO_VISITANTE AND TEMPORADA = :NEW.IDTEMP;
    ELSE
      INSERT INTO media_goles (temporada, equipo, numero_partidos_jugados, goles)
      VALUES (:NEW.IDTEMP, :NEW.EQUIPO_VISITANTE, 1, :NEW.GOLES_VISITANTE);
    END IF;
	COMMIT;
  END;
/

CREATE OR REPLACE TRIGGER media_goles_delete
AFTER DELETE
  ON PARTIDO
FOR EACH ROW
	DECLARE
		PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    -- Equipo local
    UPDATE media_goles
    SET goles                 = goles - :OLD.GOLES_LOCAL,
      numero_partidos_jugados = numero_partidos_jugados - 1
    WHERE equipo = :OLD.EQUIPO_LOCAL AND TEMPORADA = :OLD.IDTEMP;

    -- Equipo visitante
    UPDATE media_goles
    SET goles                 = goles - :OLD.GOLES_VISITANTE,
      numero_partidos_jugados = numero_partidos_jugados - 1
    WHERE equipo = :OLD.EQUIPO_VISITANTE AND TEMPORADA = :OLD.IDTEMP;
	COMMIT;
  END;
/

--
-- Descripción: Con este trigger se busca evitar inconsistencias en la base de datos. Este evita que un
-- equipo empieze a entrenar en un estadio en una fecha anterior a la que dejó de entrenar en él
--

-- Evita insertar datos inconsistentes en la tabla residir
CREATE OR REPLACE TRIGGER overlap
BEFORE INSERT OR UPDATE
  ON residir
FOR EACH ROW
  BEGIN
    IF (:NEW.inicio > :NEW.fin ) THEN
      RAISE_APPLICATION_ERROR(1, 'Colapso de tiempos o inicio > fin');
    END IF;
  END;
/

-- Al eliminar no es necesario ya que no se pueden crear inconsistencias
