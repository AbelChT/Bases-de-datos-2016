CREATE OR REPLACE TRIGGER temp_closed
  AFTER INSERT OR UPDATE
  ON partido
  FOR EACH ROW
  DECLARE
    num NUMBER;
BEGIN
    SELECT finalizada INTO num FROM temporada WHERE id = :NEW.idTemp;
    IF(num = 1) THEN
        RAISE_APPLICATION_ERROR(1, 'Temporada finalizada');
    END IF;
  END;
  /
