DROP TABLE viaje;
DROP TRIGGER viajeInsert;
DROP TRIGGER viajeUpdate;
DROP TRIGGER viajeDelete;

--
-- Tabla para almacenar los distintos viajes que tiene cada aerolinea
--
CREATE TABLE viaje (
  aerolinea               VARCHAR(7) REFERENCES aerolinea (iata),
  destino                 VARCHAR(4) REFERENCES aeropuerto (iata),
  origen                  VARCHAR(4) REFERENCES aeropuerto (iata),
  cuenta				  INTEGER,
  PRIMARY KEY(aerolinea,destino,origen)
);

--
-- Actualiza la tabla anterior cada vez que se inserta un nuevo vuelo
--

CREATE TRIGGER viajeInsert
  AFTER INSERT
  ON vuelo
  FOR EACH ROW
  DECLARE
  countVuelos INTEGER;
BEGIN
  SELECT COUNT(*) INTO countVuelos FROM viaje WHERE EXISTS( SELECT * FROM viaje WHERE viaje.aerolinea = :NEW.aerolinea AND viaje.origen = :NEW.origen AND viaje.destino = :NEW.destino);
  IF (countVuelos = 0) THEN
    INSERT INTO viaje (aerolinea,destino,origen,cuenta) VALUES (:NEW.aerolinea, :NEW.destino, :NEW.origen, 1);
  ELSE 
	  UPDATE viaje SET cuenta = cuenta + 1 WHERE viaje.aerolinea = :NEW.aerolinea AND viaje.origen = :NEW.origen AND viaje.destino = :NEW.destino;
  END IF;
END;
/

--
-- Actualiza la tabla anterior cada vez que se actualiza un vuelo
--

CREATE TRIGGER viajeUpdate
  AFTER UPDATE
  ON vuelo
  FOR EACH ROW
  DECLARE
	countVuelos		INTEGER;
	countAntigua	INTEGER;
BEGIN
	SELECT COUNT(*) INTO countVuelos FROM viaje WHERE EXISTS ( SELECT * FROM viaje WHERE aerolinea = :OLD.aerolinea AND origen = :OLD.origen AND destino = :OLD.destino);
    IF (countVuelos = 1)
      THEN
        DELETE FROM viaje
        WHERE :OLD.aerolinea = aerolinea AND :OLD.origen = origen AND :OLD.destino = destino;
      ELSE
        UPDATE viaje
        SET cuenta = cuenta - 1
        WHERE :OLD.aerolinea = aerolinea AND :OLD.origen = origen AND :OLD.destino = destino;
    END IF;
	SELECT COUNT(*) INTO countVuelos FROM viaje WHERE aerolinea = :NEW.aerolinea AND origen = :NEW.origen AND destino = :NEW.destino;
	IF (countVuelos = 0) THEN
		INSERT INTO viaje (aerolinea,destino,origen,cuenta) VALUES (:NEW.aerolinea, :NEW.destino, :NEW.origen, 1);
	ELSE 
		UPDATE viaje SET cuenta = cuenta + 1 WHERE aerolinea = :NEW.aerolinea AND origen = :NEW.origen AND destino = :NEW.destino;
    END IF;
END;
/

--
-- Actualiza la tabla anterior cada vez que se elimina un vuelo
--

CREATE TRIGGER viajeDelete
  AFTER DELETE
  ON vuelo
  FOR EACH ROW
  DECLARE
  countVuelos INTEGER;
BEGIN
  
  SELECT COUNT(*) INTO countVuelos FROM viaje WHERE EXISTS( SELECT * FROM viaje WHERE aerolinea = :OLD.aerolinea  AND origen = :OLD.origen AND destino = :OLD.destino);
  IF countVuelos < 2 THEN
	IF countVuelos = 1 THEN
	  	DELETE FROM viaje WHERE aerolinea = :OLD.aerolinea  AND origen = :OLD.origen AND destino = :OLD.destino;
  	END IF;
  ELSE
	UPDATE viaje
        SET cuenta = cuenta - 1
        WHERE :OLD.aerolinea = aerolinea AND :OLD.origen = origen AND :OLD.destino = destino;
  END IF;
END;
/