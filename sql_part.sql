/* 7. В подключенном MySQL репозитории создать базу данных “Друзья
человека” */

DROP DATABASE IF EXISTS друзья_человека;
CREATE DATABASE друзья_человека;
USE друзья_человека;

/* 8. Создать таблицы с иерархией из диаграммы в БД */

-- Animals
DROP TABLE IF EXISTS animals;
CREATE TABLE animals (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	type_of_animals VARCHAR(45) -- домашние или вьючные животные
);

-- Pets
DROP TABLE IF EXISTS pets;
CREATE TABLE pets (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	type_of_animals VARCHAR(45) -- виды: кошки, собаки и т.д.
);

-- PackAnimals
DROP TABLE IF EXISTS pack_animals;
CREATE TABLE pack_animals (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	type_of_animals VARCHAR(45) -- виды: лошади, верблюды, олени и т.д.
);

-- Cats
DROP TABLE IF EXISTS cats;
CREATE TABLE cats (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
    birthday DATE,
    commands VARCHAR(50)
);

-- Dogs
DROP TABLE IF EXISTS dogs;
CREATE TABLE dogs (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
    birthday DATE,
    commands VARCHAR(50)
);

-- Hamsters могут выполнять команды стоять, перевернуться, прыгать, фу
DROP TABLE IF EXISTS hamsters;
CREATE TABLE hamsters (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
    birthday DATE,
    commands VARCHAR(50)
);

-- Horses
DROP TABLE IF EXISTS horses;
CREATE TABLE horses (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
    birthday DATE,
    commands VARCHAR(50)
);

-- Camels
DROP TABLE IF EXISTS camels;
CREATE TABLE camels (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
    birthday DATE,
    commands VARCHAR(50)
);

-- Donkeys
DROP TABLE IF EXISTS donkeys;
CREATE TABLE donkeys (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
    birthday DATE,
    commands VARCHAR(50)
);

/* 9. Заполнить низкоуровневые таблицы именами(животных), командами
которые они выполняют и датами рождения */

INSERT INTO cats (name, birthday, commands)
VALUES
('Tom', '2021-05-12', 'принеси, голос'),
('Bob', '2019-10-03', 'ползи'),
('Meow', '2015-05-03', 'ползи'),
('Chief', '2012-07-15', 'принеси, голос, ползи');

INSERT INTO dogs (name, birthday, commands)
VALUES
('Thor', '2021-05-23', 'принеси, голос, нельзя'),
('Wolf', '2023-01-04', 'сидеть, лежать, жди'),
('Monti', '2023-01-04', 'сидеть, лежать, жди');

INSERT INTO hamsters (name, birthday, commands)
VALUES
('Jimmy', '2021-09-06', 'стоять'),
('Rocket', '2019-11-13', 'перевернуться');

INSERT INTO horses (name, birthday, commands)
VALUES
('Silver', '2018-03-10', 'рысь, шагом, стоять'),
('Cherry', '2023-07-25', 'вперед, стоять');

INSERT INTO camels (name, birthday, commands)
VALUES
('Prince', '2022-06-01', 'стоять, вперед'),
('Sofia', '2019-04-10', 'стоять, лежать,вперед');

INSERT INTO donkeys (name, birthday, commands)
VALUES
('Lora', '2023-12-05', 'стоять, вперед'),
('Otis', '2019-07-15', 'стоять, лежать, вперед');

/* 10. Удалив из таблицы верблюдов, т.к. верблюдов решили перевезти в другой
питомник на зимовку. Объединить таблицы лошади, и ослы в одну таблицу. */

DROP TABLE camels;
SELECT h.name AS name, 
	h.birthday AS birthday, 
    h.commands AS commands
FROM horses h
UNION
SELECT d.name, d.birthday, d.commands FROM donkeys d;

/* 11.Создать новую таблицу “молодые животные” в которую попадут все
животные старше 1 года, но младше 3 лет и в отдельном столбце с точностью
до месяца подсчитать возраст животных в новой таблице */

DROP TABLE IF EXISTS alltogether;
CREATE TEMPORARY TABLE alltogether AS
SELECT c.name, c.birthday, c.commands FROM cats c
UNION SELECT d.name, d.birthday, d.commands FROM dogs d
UNION SELECT h.name, h.birthday, h.commands FROM hamsters h
UNION SELECT hr.name, hr.birthday, hr.commands FROM horses hr
UNION SELECT dk.name, dk.birthday, dk.commands FROM donkeys dk;

DROP TABLE IF EXISTS young_animals;
CREATE TABLE young_animals AS
SELECT name, birthday, commands,
TIMESTAMPDIFF(month, birthday, now()) AS age_in_month
FROM alltogether
WHERE TIMESTAMPDIFF(year, birthday, now()) BETWEEN 1 AND 3;

/* 12. Объединить все таблицы в одну, при этом сохраняя поля, указывающие на
прошлую принадлежность к старым таблицам. */

-- FULL JOIN 
SELECT c.*, d.*, h.*, hr.*, dk.* FROM cats c
LEFT JOIN dogs d ON c.id = d.id
LEFT JOIN hamsters h ON d.id = h.id
LEFT JOIN horses hr ON h.id=hr.id
LEFT JOIN donkeys dk ON hr.id=dk.id
UNION
SELECT c.*, d.*, h.*, hr.*, dk.* FROM donkeys dk
LEFT JOIN horses hr ON dk.id = hr.id
LEFT JOIN hamsters h ON hr.id = h.id
LEFT JOIN dogs d ON h.id=d.id
LEFT JOIN cats c ON d.id=c.id;