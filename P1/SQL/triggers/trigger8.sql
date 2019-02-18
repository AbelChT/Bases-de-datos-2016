CREATE OR REPLACE TRIGGER overlap_del
  AFTER DELETE
  ON residir
  FOR EACH ROW
  DECLARE
    num NUMBER;
BEGIN
    SELECT COUNT(*) INTO num FROM residir WHERE (:OLD.fin > fin AND :OLD.inicio < fin);
    IF(:OLD.inicio > :OLD.fin OR num = 1) THEN
        RAISE_APPLICATION_ERROR(1, 'Colapso de tiempos o inicio > fin');
    END IF;
  END;
  /
