CREATE OR REPLACE TRIGGER overlap
  AFTER INSERT OR UPDATE
  ON residir
  FOR EACH ROW
  DECLARE
    num NUMBER;
BEGIN
    SELECT COUNT(*) INTO num FROM residir WHERE (:NEW.fin > fin AND NEW.inicio < fin);
    IF(:NEW.inicio > :NEW.fin OR num = 1) THEN
        RAISE_APPLICATION_ERROR(1, 'Colapso de tiempos o inicio > fin');
    END IF;
  END;
  /
