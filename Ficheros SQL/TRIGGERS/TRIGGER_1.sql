-- Con este trigger se pretende mantener la cuenta del número de actores de cada película
-- para de esta forma aumentar la eficiencia en la primera consulta
CREATE TABLE num_actores_pelicula (
    pelicula INTEGER PRIMARY KEY,-- REFERENCES PELICULA(ID),
    num_actores INTEGER
);

-- Cuando se añade una película esta se añade al registro con 0 actores
CREATE OR REPLACE TRIGGER nu_act_pel_insert_pel
AFTER INSERT
  ON PELICULA
  FOR EACH ROW
    DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
      INSERT INTO num_actores_pelicula (num_actores_pelicula.pelicula,num_actores_pelicula.num_actores) VALUES (:NEW.ID,0);
      COMMIT;
END;
/

-- Cuando se añade un actor a una película se suma al 1 al número de actores
CREATE OR REPLACE TRIGGER nu_act_pel_insert_act_pel
AFTER INSERT
  ON ACTOR_PELICULA
  FOR EACH ROW
    DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
      UPDATE num_actores_pelicula
      SET num_actores_pelicula.num_actores=num_actores_pelicula.num_actores+1
      WHERE num_actores_pelicula.pelicula= :NEW.PELICULA;
      COMMIT;
END;
/

-- Trigger que precalcula los actores de cada película al realizar el update
CREATE OR REPLACE TRIGGER nu_act_pel_update_act_pel
AFTER UPDATE
  ON ACTOR_PELICULA
    FOR EACH ROW
BEGIN

  IF :OLD.PELICULA != :NEW.PELICULA
  THEN
    UPDATE num_actores_pelicula
    SET num_actores_pelicula.num_actores=num_actores_pelicula.num_actores-1
    WHERE num_actores_pelicula.pelicula= :OLD.PELICULA;

    UPDATE num_actores_pelicula
    SET num_actores_pelicula.num_actores=num_actores_pelicula.num_actores+1
    WHERE num_actores_pelicula.pelicula= :NEW.PELICULA;
  END IF;
END;
/

-- No hay trigger para update de película debido a que lo único que podria hacer
-- que hubiera que modificar algo sería cambiar el id, el cual no tiene sentido modificarlo
--El ON DELETE SE HACE EN EL on delete cascade

-- Trigger que precalcula los actores de cada película al realizar el delete
CREATE OR REPLACE TRIGGER nu_ac_pel_delete_act_pel
AFTER DELETE
  ON ACTOR_PELICULA
    FOR EACH ROW
    DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  DELETE FROM num_actores_pelicula
  WHERE num_actores_pelicula.pelicula= :OLD.PELICULA;
  COMMIT;
END;
/