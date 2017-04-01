CREATE OR REPLACE TRIGGER temp_closed_del
  AFTER DELETE
  ON partido
  FOR EACH ROW
  DECLARE
    num NUMBER;
BEGIN
    SELECT finalizada INTO num FROM temporada WHERE id = :OLD.idTemp;
    IF(num = 1) THEN
        RAISE_APPLICATION_ERROR(1, 'Temporada finalizada');
    END IF;
  END;
  /
