CREATE TABLE num_actores_pelicula (
    pelicula INTEGER PRIMARY KEY REFERENCES PELICULA(ID),
    num_actores INTEGER
);

-- Trigger que precalcula los actores de cada película al realizar el insert
CREATE OR REPLACE TRIGGER num_actores_pelicula_insert
AFTER INSERT
  ON ACTOR_PELICULA
  FOR EACH ROW
BEGIN
    IF EXISTS(SELECT *
              FROM  num_actores_pelicula
              WHERE pelicula = :NEW.PELICULA)
      THEN
        UPDATE num_actores_pelicula
        SET num_actores_pelicula.num_actores=num_actores_pelicula.num_actores+1
        WHERE num_actores_pelicula.pelicula= :NEW.PELICULA;
      ELSE
        INSERT INTO num_actores_pelicula (num_actores_pelicula.pelicula,num_actores_pelicula.num_actores) VALUES (:NEW.PELICULA,1);
      END IF;
END;
/

-- Trigger que precalcula los actores de cada película al realizar el update
CREATE OR REPLACE TRIGGER num_actores_pelicula_update
AFTER UPDATE
  ON ACTOR_PELICULA
    FOR EACH ROW
BEGIN
  UPDATE num_actores_pelicula
  SET num_actores_pelicula.num_actores=num_actores_pelicula.num_actores-1
  WHERE num_actores_pelicula.pelicula= :OLD.PELICULA;

  IF EXISTS(SELECT *
              FROM  num_actores_pelicula
              WHERE pelicula = :NEW.PELICULA)
      THEN
        UPDATE num_actores_pelicula
        SET num_actores_pelicula.num_actores=num_actores_pelicula.num_actores+1
        WHERE num_actores_pelicula.pelicula= :NEW.PELICULA;
      ELSE
        INSERT INTO num_actores_pelicula (num_actores_pelicula.pelicula,num_actores_pelicula.num_actores) VALUES (:NEW.PELICULA,1);
      END IF;
END;
/

-- Trigger que precalcula los actores de cada película al realizar el delete
CREATE OR REPLACE TRIGGER num_actores_pelicula_delete
AFTER DELETE
  ON ACTOR_PELICULA
    FOR EACH ROW
BEGIN
  UPDATE num_actores_pelicula
  SET num_actores_pelicula.num_actores=num_actores_pelicula.num_actores-1
  WHERE num_actores_pelicula.pelicula= :OLD.PELICULA;
END;
/