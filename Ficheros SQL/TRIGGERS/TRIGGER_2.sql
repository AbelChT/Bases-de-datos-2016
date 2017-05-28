-- Descripción: Con esta optimización se pretende mejorar el rendimiento de la consulta obligatoria nº2
-- para ello se crea la tabla aviones_aeropuerto en la que se guardan los aviones que operan en cada
-- aeropuerto. Los trigger se utilizan para mantener coherente esta tabla.

-- En ellos lo que se hace es al insertar un dato en la tabla vuelo, si el
-- avion que realiza ese vuelo y el origen, o el destino del vuelo no son una
-- tupla guardada en aviones_aeropuerto, la añade y pone el valor cuenta a 1.
-- En el caso de que si que sea una de las tuplas guardadas aumenta en una unidad el valor cuenta.

-- En el caso de eliminar una tupla de la tabla vuelo, mientras el valor cuenta
-- sea superior a 1 se resta una unidad a este. En el caso de que sea 1 implica
-- que el vuelo a eliminar es el único que realiza ese avion con origen o destino
-- ese aeropuerto, por ello se elimina la tupla de la tabla aviones_aeropuerto.

-- Se utiliza para almacenar los aviones que operan en cada aeropuerto
CREATE TABLE aviones_aeropuerto (
  avion      INTEGER REFERENCES avion (id) ON DELETE CASCADE, -- Se almacenará el avion que opera
  aeropuerto VARCHAR(4) REFERENCES aeropuerto (iata) ON DELETE CASCADE, -- Se almacenará el aeropuerto en el que se opera
  cuenta     INTEGER, -- Esta cuenta vale para controlar cuando eliminar la entrada
  -- Si llega a 0 se eliminar. Esto es obligatorio ya que aunque existe un algoritmo
  -- que permitiría no tener este campo, este necesita realizar una consulta
  -- sobre la tabla que se está modificando, lo que al menos en la versión de
  -- oracle sobre la que trabajamos porduce un error de tablas mutantes
  PRIMARY KEY (avion, aeropuerto)
);

CREATE OR REPLACE TRIGGER tr_aviones_aeropuerto_insert
AFTER INSERT ON vuelo
FOR EACH ROW
  DECLARE
    numero INTEGER;
  BEGIN
    IF (:NEW.origen IS NOT NULL) AND (:NEW.avion IS NOT NULL)
    THEN
      SELECT COUNT(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.avion = aviones_aeropuerto.avion AND :NEW.origen = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto, cuenta) VALUES (:NEW.avion, :NEW.origen, 1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.avion AND aeropuerto = :NEW.origen;
      END IF;
    END IF;

    IF (:NEW.destino IS NOT NULL) AND (:NEW.avion IS NOT NULL)
    THEN
      SELECT COUNT(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.avion = aviones_aeropuerto.avion AND :NEW.destino = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto, cuenta) VALUES (:NEW.avion, :NEW.destino, 1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.avion AND aeropuerto = :NEW.destino;
      END IF;
    END IF;
  END;
/

CREATE OR REPLACE TRIGGER tr_aviones_aeropuerto_update
AFTER UPDATE ON vuelo
FOR EACH ROW
  DECLARE
    numero INTEGER;
  BEGIN
    IF (:OLD.origen IS NOT NULL) AND (:OLD.avion IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.origen = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.origen = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.origen = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;

    IF (:OLD.destino IS NOT NULL) AND (:OLD.avion IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.destino = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.destino = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.destino = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;

    IF (:NEW.origen IS NOT NULL) AND (:OLD.avion IS NOT NULL)
    THEN
      SELECT COUNT(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.avion = aviones_aeropuerto.avion AND :NEW.origen = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto, cuenta) VALUES (:NEW.avion, :NEW.origen, 1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.avion AND aeropuerto = :NEW.origen;
      END IF;
    END IF;

    IF (:NEW.destino IS NOT NULL) AND (:OLD.avion IS NOT NULL)
    THEN
      SELECT COUNT(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.avion = aviones_aeropuerto.avion AND :NEW.destino = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto,cuenta) VALUES (:NEW.avion, :NEW.destino, 1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.avion AND aeropuerto = :NEW.destino;
      END IF;

    END IF;

  END;
/

CREATE OR REPLACE TRIGGER tr_aviones_aeropuerto_delete
AFTER DELETE ON vuelo
FOR EACH ROW
  DECLARE
    numero INTEGER;
  BEGIN
    IF (:OLD.origen IS NOT NULL) AND (:OLD.avion IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.origen = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.origen = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.origen = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;

    IF (:OLD.destino IS NOT NULL) AND (:OLD.avion IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.destino = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.destino = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.avion = aviones_aeropuerto.avion AND :OLD.destino = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;
  END;
/
