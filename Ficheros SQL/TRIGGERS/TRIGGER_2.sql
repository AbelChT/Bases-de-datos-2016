-- Se utiliza para almacenar los aviones que operan en cada aeropuerto
CREATE TABLE aviones_aereopuerto (
  avion INTEGER REFERENCES AVION(ID) ON DELETE CASCADE,
  aeropuerto VARCHAR(4) REFERENCES AEROPUERTO(IATA) ON DELETE CASCADE,
  PRIMARY KEY (avion,aeropuerto)
);

CREATE OR REPLACE TRIGGER tr_aviones_aereopuerto_insert
  AFTER INSERT ON VUELO
  FOR EACH ROW
  DECLARE
    numero INTEGER;
  BEGIN

    IF :NEW.ORIGEN IS NOT NULL
      THEN
      SELECT count(*) INTO numero
      FROM aviones_aereopuerto
      WHERE :NEW.AVION=aviones_aereopuerto.avion AND :NEW.ORIGEN=aviones_aereopuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aereopuerto(avion,aeropuerto) VALUES (:NEW.AVION,:NEW.ORIGEN);
      END IF;
    END IF;

    IF :NEW.DESTINO IS NOT NULL
      THEN
      SELECT count(*) INTO numero
      FROM aviones_aereopuerto
      WHERE :NEW.AVION=aviones_aereopuerto.avion AND :NEW.DESTINO=aviones_aereopuerto.aeropuerto;

      IF (numero = 0)
      THEN
        INSERT INTO aviones_aereopuerto(avion,aeropuerto) VALUES (:NEW.AVION,:NEW.DESTINO);
      END IF;
    END IF;
  END;
/