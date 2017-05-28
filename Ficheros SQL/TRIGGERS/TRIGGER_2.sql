-- Descripción: Con este trigger se pretende mejorar el rendimiento de la consulta obligatoria nº2
-- para ello se crea la tabla aviones_aeropuerto en la que se guardan los aviones que operan en cada
-- aeropuerto. Los trigger se utilizan para mantener coherente esta tabla

-- Se utiliza para almacenar los aviones que operan en cada aeropuerto
CREATE TABLE aviones_aeropuerto (
  avion      INTEGER REFERENCES AVION (ID) ON DELETE CASCADE, -- Se almacenará el avion que opera
  aeropuerto VARCHAR(4) REFERENCES AEROPUERTO (IATA) ON DELETE CASCADE, -- Se almacenará el aeropuerto en el que se opera
  cuenta     INTEGER, -- Esta cuenta vale para controlar cuando eliminar la entrada
  -- Si llega a 0 se eliminar. Esto es obligatorio ya que aunque existe un algoritmo
  -- que permitiría no tener este campo, este necesita realizar una consulta
  -- sobre la tabla que se está modificando, lo que al menos en la versión de
  -- oracle sobre la que trabajamos porduce un error de tablas mutantes
  PRIMARY KEY (avion, aeropuerto)
);

CREATE OR REPLACE TRIGGER tr_aviones_aeropuerto_insert
AFTER INSERT ON VUELO
FOR EACH ROW
  DECLARE
    numero INTEGER;
  BEGIN
    IF (:NEW.ORIGEN IS NOT NULL) AND (:NEW.AVION IS NOT NULL)
    THEN
      SELECT count(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.AVION = aviones_aeropuerto.avion AND :NEW.ORIGEN = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto, cuenta) VALUES (:NEW.AVION, :NEW.ORIGEN, 1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.AVION AND aeropuerto = :NEW.ORIGEN;
      END IF;
    END IF;

    IF (:NEW.DESTINO IS NOT NULL) AND (:NEW.AVION IS NOT NULL)
    THEN
      SELECT count(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.AVION = aviones_aeropuerto.avion AND :NEW.DESTINO = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto, cuenta) VALUES (:NEW.AVION, :NEW.DESTINO,1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.AVION AND aeropuerto = :NEW.DESTINO;
      END IF;
    END IF;
  END;
/

CREATE OR REPLACE TRIGGER tr_aviones_aeropuerto_update
AFTER UPDATE ON VUELO
FOR EACH ROW
  DECLARE
    numero INTEGER;
  BEGIN
    IF (:OLD.ORIGEN IS NOT NULL) AND (:OLD.AVION IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.ORIGEN = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.ORIGEN = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.ORIGEN = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;

    IF (:OLD.DESTINO IS NOT NULL) AND (:OLD.AVION IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.DESTINO = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.DESTINO = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.DESTINO = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;

    IF (:NEW.ORIGEN IS NOT NULL) AND (:OLD.AVION IS NOT NULL)
    THEN
      SELECT count(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.AVION = aviones_aeropuerto.avion AND :NEW.ORIGEN = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto, cuenta) VALUES (:NEW.AVION, :NEW.ORIGEN, 1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.AVION AND aeropuerto = :NEW.ORIGEN;
      END IF;
    END IF;

    IF (:NEW.DESTINO IS NOT NULL) AND (:OLD.AVION IS NOT NULL)
    THEN
      SELECT count(*)
      INTO numero
      FROM aviones_aeropuerto
      WHERE :NEW.AVION = aviones_aeropuerto.avion AND :NEW.DESTINO = aviones_aeropuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aeropuerto (avion, aeropuerto,cuenta) VALUES (:NEW.AVION, :NEW.DESTINO,1);
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta + 1
        WHERE avion = :NEW.AVION AND aeropuerto = :NEW.DESTINO;
      END IF;

    END IF;

  END;
/

CREATE OR REPLACE TRIGGER tr_aviones_aeropuerto_delete
AFTER DELETE ON VUELO
FOR EACH ROW
  DECLARE
    numero INTEGER;
  BEGIN
    IF (:OLD.ORIGEN IS NOT NULL) AND (:OLD.AVION IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.ORIGEN = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.ORIGEN = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.ORIGEN = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;

    IF (:OLD.DESTINO IS NOT NULL) AND (:OLD.AVION IS NOT NULL)
    THEN
      SELECT cuenta
      INTO numero
      FROM aviones_aeropuerto
      WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.DESTINO = aviones_aeropuerto.aeropuerto;

      IF (numero = 1)
      THEN
        DELETE FROM aviones_aeropuerto
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.DESTINO = aviones_aeropuerto.aeropuerto;
      ELSE
        UPDATE aviones_aeropuerto
        SET cuenta = cuenta - 1
        WHERE :OLD.AVION = aviones_aeropuerto.avion AND :OLD.DESTINO = aviones_aeropuerto.aeropuerto;
      END IF;
    END IF;
  END;
/
