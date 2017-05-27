-- Se utiliza para almacenar los aviones que operan en cada aeropuerto
CREATE TABLE aviones_aereopuerto (
  avion INTEGER REFERENCES AVION(ID),
  aeropuerto VARCHAR(4) REFERENCES AEROPUERTO(IATA),
  PRIMARY KEY (avion,aeropuerto)
);

-- Falta implementar el trigger
CREATE OR REPLACE TRIGGER tr_aviones_aereopuerto_insert
  AFTER INSERT ON VUELO
  FOR EACH ROW
  BEGIN
    IF NOT EXISTS( SELECT *
                    FROM aviones_aereopuerto
                    WHERE :NEW.AVION=aviones_aereopuerto.avion AND :NEW.ORIGEN=aviones_aereopuerto.aeropuerto)
    THEN
      INSERT INTO aviones_aereopuerto(avion,aeropuerto) VALUES (:NEW.AVION,:NEW.ORIGEN);
    END IF;

    IF NOT EXISTS( SELECT *
                    FROM aviones_aereopuerto
                    WHERE :NEW.AVION=aviones_aereopuerto.avion AND :NEW.DESTINO=aviones_aereopuerto.aeropuerto)
    THEN
      INSERT INTO aviones_aereopuerto(avion,aeropuerto) VALUES (:NEW.AVION,:NEW.DESTINO);
    END IF;
  END;
/