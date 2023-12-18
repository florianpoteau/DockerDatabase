CREATE TABLE "User" (
id SERIAL PRIMARY KEY,
nom VARCHAR(25),
prenom VARCHAR(25),
email VARCHAR(100),
password VARCHAR(100),
role VARCHAR(20)
);

create table "Director"(
id SERIAL primary key,
nom varchar(25),
prenom varchar(25)
);

create table "Actor"(
id SERIAL primary key,
nom varchar(25),
prenom varchar(25),
role varchar(20),
birth date
);

create table "Movie" (
id SERIAL primary key,
titre varchar(80),
duree time,
annee date,
director_id int,
FOREIGN KEY (director_id) REFERENCES "Director"(id)
);

create table "RoleActorMovie"(
id_actor int,
FOREIGN KEY (id_actor) REFERENCES "Actor"(id),
id_movie int,
FOREIGN KEY (id_movie) REFERENCES "Movie"(id)
);

create table "FavoriteMovie"(
id_user int,
FOREIGN KEY (id_user) REFERENCES "User"(id),
id_movie int,
FOREIGN KEY (id_movie) REFERENCES "Movie"(id)
);

CREATE TABLE UserArchive (
archive_id SERIAL PRIMARY KEY,
user_id INT,
modification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
operation_type VARCHAR(10),
old_data JSONB,
new_data JSONB
);

CREATE OR REPLACE FUNCTION user_update_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
IF TG_TABLE_NAME = 'User' THEN
INSERT INTO UserArchive (user_id, operation_type, old_data, new_data)
VALUES (NEW.id, 'update', row_to_json(OLD), row_to_json(NEW));
END IF;

    RETURN NEW;

END;

$$
LANGUAGE plpgsql;

CREATE TRIGGER user_update_trigger
BEFORE UPDATE ON "User"
FOR EACH ROW
EXECUTE FUNCTION user_update_trigger_function();

