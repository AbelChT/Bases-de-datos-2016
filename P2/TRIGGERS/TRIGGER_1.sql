-- Con este trigger se pretende mantener la cuenta del número de actores de cada película
-- para de esta forma aumentar la eficiencia en la primera consulta

-- Se crea la tabla en la cual se almacenará el número de actores de cada película
CREATE TABLE num_actores_pelicula (
    pelicula INTEGER PRIMARY KEY,
    num_actores INTEGER
);

-- Crea un índice que hace que disminuya el tiempo de consulta cuando se hacen
-- búsquedas según el número de actores
CREATE INDEX num_act_pelicula_idx ON NUM_ACTORES_PELICULA(num_actores);

-- Trigger que al realizar una inserción de una nueva película en la tabla
-- película esta se añada a num_actores_pelicula con 0 actores
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

-- Trigger que al realizar una inserción de una nueva tupla (película, actor) en la tabla actor_pelicula ,
-- aumente en una unidad el número de actores de la película en cuestión en la tabla
-- num_actores_pelicula
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

-- Trigger que al realizar una actualización de una tupla (película, actor) en la tabla actor_pelicula ,
-- actualice los valores de la tabla num_actores_pelicula
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


-- Trigger que al eliminar una tupla (película, actor) en la tabla actor_pelicula,
-- actualiza los valores de la tabla num_actores_pelicula
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
