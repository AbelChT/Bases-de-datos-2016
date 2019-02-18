--
-- EMPATES
--

-- Tabla auxiliar al trigger empates_insert
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
    a NUMBER;
    b NUMBER;
BEGIN
    IF :NEW.GOLES_LOCAL=:NEW.GOLES_VISITANTE THEN
      --Equipo local
       SELECT count(*)
       INTO a
        FROM empates
        WHERE empates.equipo= :NEW.EQUIPO_LOCAL  AND empates.TEMPORADA = :NEW.IDTEMP;

      IF(a>0) THEN
        UPDATE EMPATES
        SET empates.NUM=empates.NUM+1
        WHERE empates.equipo= :NEW.EQUIPO_LOCAL AND empates.TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO EMPATES(empates.temporada,empates.equipo,empates.NUM) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_LOCAL,1);
      END IF;

      --Equipo visitante
      SELECT count(*)
      INTO b
        FROM empates
        WHERE empates.equipo = :NEW.EQUIPO_VISITANTE AND empates.TEMPORADA = :NEW.IDTEMP;

      IF(b>0) THEN
        UPDATE EMPATES
        SET empates.NUM=empates.NUM+1
        WHERE empates.equipo = :NEW.EQUIPO_VISITANTE AND empates.TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO EMPATES(empates.temporada,empates.equipo,empates.NUM) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_VISITANTE,1);

      END IF;
    END IF;
END;
/

-- Trigger que precalcula los empates al realizar update
CREATE OR REPLACE TRIGGER empates_update
AFTER UPDATE
  ON partido
  FOR EACH ROW
    DECLARE
    a NUMBER;
    b NUMBER;
BEGIN
      -- Elimino el registro de empates
    IF :OLD.GOLES_LOCAL=:OLD.GOLES_VISITANTE THEN
      UPDATE EMPATES
        SET empates.NUM=empates.NUM-1
        WHERE (empates.equipo = :OLD.EQUIPO_LOCAL) OR (empates.equipo = :OLD.EQUIPO_VISITANTE) AND empates.TEMPORADA = :OLD.IDTEMP;
    END IF;

      -- Pongo el nuevo registro de empates
    IF :NEW.GOLES_LOCAL=:NEW.GOLES_VISITANTE THEN
      --Equipo local
       SELECT count(*)
       INTO a
        FROM empates
        WHERE empates.equipo= :NEW.EQUIPO_LOCAL  AND empates.TEMPORADA = :NEW.IDTEMP;

      IF(a>0) THEN
        UPDATE EMPATES
        SET empates.NUM=empates.NUM+1
        WHERE empates.equipo= :NEW.EQUIPO_LOCAL AND empates.TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO EMPATES(empates.temporada,empates.equipo,empates.NUM) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_LOCAL,1);
      END IF;

      --Equipo visitante
      SELECT count(*)
      INTO b
        FROM empates
        WHERE empates.equipo = :NEW.EQUIPO_VISITANTE AND empates.TEMPORADA = :NEW.IDTEMP;

      IF(b>0) THEN
        UPDATE EMPATES
        SET empates.NUM=empates.NUM+1
        WHERE empates.equipo = :NEW.EQUIPO_VISITANTE AND empates.TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO EMPATES(empates.temporada,empates.equipo,empates.NUM) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_VISITANTE,1);

      END IF;
    END IF;
END;
/

-- Trigger que precalcula los empates al realizar delete
CREATE OR REPLACE TRIGGER empates_delete
AFTER DELETE
  ON partido
  FOR EACH ROW
BEGIN
      IF :OLD.GOLES_LOCAL=:OLD.GOLES_VISITANTE THEN
        UPDATE EMPATES
        SET empates.NUM=empates.NUM-1
        WHERE (empates.equipo = :OLD.EQUIPO_LOCAL) OR (empates.equipo = :OLD.EQUIPO_VISITANTE) AND empates.TEMPORADA = :OLD.IDTEMP;
      END IF;
END;
/

--
-- OVERLAP
--

-- Evita insertar datos inconsistentes en la tabla residir
CREATE OR REPLACE TRIGGER overlap
BEFORE INSERT
  ON residir
FOR EACH ROW
  BEGIN
    IF (:NEW.inicio > :NEW.fin ) THEN
      RAISE_APPLICATION_ERROR(1, 'Colapso de tiempos o inicio > fin');
    END IF;
  END;
/

-- Evita actualizar datos inconsistentes en la tabla residir
CREATE OR REPLACE TRIGGER overlap
BEFORE UPDATE
  ON residir
FOR EACH ROW
  BEGIN
    IF (:NEW.inicio > :NEW.fin ) THEN
      RAISE_APPLICATION_ERROR(1, 'Colapso de tiempos o inicio > fin');
    END IF;
  END;
/

--
-- MEDIA DE GOLES
--

-- Tabla que almacena en cada temporada los puntos guardados y el numero de partidos jugados
CREATE TABLE MEDIA_GOLES (
	equipo VARCHAR(100) REFERENCES equipo(nombre_oficial),
	temporada INTEGER REFERENCES temporada(id),
  goles INTEGER,
  numero_partidos_jugados INTEGER,
	PRIMARY KEY(equipo, temporada)
);

-- Trigger que calcula los goles acumulados asi como los partidos jugados en cada temporada
CREATE OR REPLACE TRIGGER media_goles_insert
AFTER INSERT
  ON partido
  FOR EACH ROW
    DECLARE
    a NUMBER;
    b NUMBER;
BEGIN
      --Equipo local
       SELECT count(*)
       INTO a
        FROM MEDIA_GOLES
        WHERE MEDIA_GOLES.equipo = :NEW.EQUIPO_LOCAL  AND MEDIA_GOLES.TEMPORADA = :NEW.IDTEMP;

      IF(a>0) THEN
        UPDATE MEDIA_GOLES
        SET MEDIA_GOLES.goles = MEDIA_GOLES.goles + :NEW.GOLES_LOCAL, MEDIA_GOLES.numero_partidos_jugados = MEDIA_GOLES.numero_partidos_jugados + 1
        WHERE empates.equipo= :NEW.EQUIPO_LOCAL AND empates.TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO MEDIA_GOLES(MEDIA_GOLES.temporada,MEDIA_GOLES.equipo,MEDIA_GOLES.numero_partidos_jugados,MEDIA_GOLES.goles) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_LOCAL,1,:NEW.GOLES_LOCAL);
      END IF;

      --Equipo visitante
       SELECT count(*)
       INTO b
        FROM MEDIA_GOLES
        WHERE MEDIA_GOLES.equipo = :NEW.EQUIPO_VISITANTE  AND MEDIA_GOLES.TEMPORADA = :NEW.IDTEMP;

      IF(b>0) THEN
        UPDATE MEDIA_GOLES
        SET MEDIA_GOLES.goles = MEDIA_GOLES.goles + :NEW.GOLES_VISITANTE, MEDIA_GOLES.numero_partidos_jugados = MEDIA_GOLES.numero_partidos_jugados + 1
        WHERE empates.equipo= :NEW.EQUIPO_VISITANTE AND empates.TEMPORADA = :NEW.IDTEMP;
      ELSE
        INSERT INTO MEDIA_GOLES(MEDIA_GOLES.temporada,MEDIA_GOLES.equipo,MEDIA_GOLES.numero_partidos_jugados,MEDIA_GOLES.goles) VALUES (:NEW.IDTEMP,:NEW.EQUIPO_VISITANTE,1,:NEW.GOLES_VISITANTE);
      END IF;

END;
