/*
Создаём базу
*/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `academy2` DEFAULT CHARACTER SET utf8 ;
USE `academy2` ;

-- -----------------------------------------------------
-- Table `academy2`.`Faculties`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `academy2`.`Faculties` (
  `idFaculties` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(100) NOT NULL DEFAULT 'check(`Name` != \'\')',
  PRIMARY KEY (`idFaculties`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy2`.`Departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `academy2`.`Departments` (
  `idDepartments` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(100) NOT NULL,
   CHECK(`Name` != ''),
  `Funding` INT NOT NULL DEFAULT 0, 
   CHECK(`Funding` >= 0),
  `Faculties_idFaculties` INT NOT NULL,
  PRIMARY KEY (`idDepartments`, `Faculties_idFaculties`),
  INDEX `fk_Departments_Faculties_idx` (`Faculties_idFaculties` ASC) VISIBLE,
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE,
  CONSTRAINT `fk_Departments_Faculties`
    FOREIGN KEY (`Faculties_idFaculties`)
    REFERENCES `academy2`.`Faculties` (`idFaculties`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy2`.`Groups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `academy2`.`Groups` (
  `idGroups` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(100) NOT NULL,
   CHECK(`Name` != ''),
  `Year` INT NOT NULL,
   CHECK(`Year` between 1 and 5),
  `Departments_idDepartments` INT NOT NULL,
  PRIMARY KEY (`idGroups`, `Departments_idDepartments`),
  INDEX `fk_Groups_Departments1_idx` (`Departments_idDepartments` ASC) VISIBLE,
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE,
  CONSTRAINT `fk_Groups_Departments1`
    FOREIGN KEY (`Departments_idDepartments`)
    REFERENCES `academy2`.`Departments` (`idDepartments`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy2`.`Teachers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `academy2`.`Teachers` (
  `idTeachers` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(100) NOT NULL, 
   CHECK(`Name` != ''),
  `Surname` NVARCHAR(100) NOT NULL, 
   CHECK(`Name` != ''),
  `Salary` INT NOT NULL,
   CHECK(`Salary` > 0),
  PRIMARY KEY (`idTeachers`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy2`.`Subjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `academy2`.`Subjects` (
  `idSubjects` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(100) NOT NULL, 
  CHECK(`Name` != ''),
  PRIMARY KEY (`idSubjects`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy2`.`Lectures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `academy2`.`Lectures` (
  `idLectures` INT NOT NULL AUTO_INCREMENT,
  `LectureRoom` NVARCHAR(100) NOT NULL,
  `DayOfWeek` INT NOT NULL,
  CHECK(`DayOfWeek` between 1 and 7),
  `Teachers_idTeachers` INT NOT NULL,
  `Subjects_idSubjects` INT NOT NULL,
  PRIMARY KEY (`idLectures`, `Teachers_idTeachers`, `Subjects_idSubjects`),
  INDEX `fk_Lectures_Teachers1_idx` (`Teachers_idTeachers` ASC) VISIBLE,
  INDEX `fk_Lectures_Subjects1_idx` (`Subjects_idSubjects` ASC) VISIBLE,
  CONSTRAINT `fk_Lectures_Teachers1`
    FOREIGN KEY (`Teachers_idTeachers`)
    REFERENCES `academy2`.`Teachers` (`idTeachers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lectures_Subjects1`
    FOREIGN KEY (`Subjects_idSubjects`)
    REFERENCES `academy2`.`Subjects` (`idSubjects`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy2`.`GroupsLectures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `academy2`.`GroupsLectures` (
  `idGroupsLectures` INT NOT NULL AUTO_INCREMENT,
  `Groups_idGroups` INT NOT NULL,
  `Lectures_idLectures` INT NOT NULL,
  PRIMARY KEY (`idGroupsLectures`, `Groups_idGroups`, `Lectures_idLectures`),
  INDEX `fk_GroupsLectures_Groups1_idx` (`Groups_idGroups` ASC) VISIBLE,
  INDEX `fk_GroupsLectures_Lectures1_idx` (`Lectures_idLectures` ASC) VISIBLE,
  CONSTRAINT `fk_GroupsLectures_Groups1`
    FOREIGN KEY (`Groups_idGroups`)
    REFERENCES `academy2`.`Groups` (`idGroups`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GroupsLectures_Lectures1`
    FOREIGN KEY (`Lectures_idLectures`)
    REFERENCES `academy2`.`Lectures` (`idLectures`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/*
Придумываем какие-нибудь данные
*/
INSERT INTO `Faculties`
(`Name`)
VALUES
('Applied Physics'),
('Computer Science');

INSERT INTO `Departments`
(`Name`,`Funding`,`Faculties_idFaculties`)
VALUES
('Electroengineering',10000,1),
('Software Development',11022,2);

INSERT INTO `Groups`
(`Name`,`Year`,`Departments_idDepartments`)
VALUES
('EE101',1,1),
('CS205',2,2);

INSERT INTO `Teachers`
(`Name`,`Surname`,`Salary`)
VALUES
('Dave','McQueen',1000),
('Jack','Underhill',1500);

INSERT INTO `Subjects`
(`Name`)
VALUES
('Introduction to Physical Science'),
('Object-Oriented Programming'),
('Introduction to Programming Languages');

INSERT INTO `Lectures`
(`LectureRoom`,`DayOfWeek`,`Teachers_idTeachers`,`Subjects_idSubjects`)
VALUES
('D201',2,1,1),
('C111',1,2,2);

INSERT INTO `GroupsLectures`
(`Groups_idGroups`,`Lectures_idLectures`)
VALUES
(1,3),
(2,4);

/*
Запросы
*/
-- Вывести количество преподавателей кафедры “Software Development”.
SELECT 
    COUNT(`idTeachers`)
FROM
    `Teachers`
WHERE
    `idTeachers` IN (SELECT 
            `Teachers_idTeachers`
        FROM
            `Lectures`
        WHERE
            `idLectures` IN (SELECT 
                    `Lectures_idLectures`
                FROM
                    `GroupsLectures`
                WHERE
                    `Groups_idGroups` IN (SELECT 
                            `idGroups`
                        FROM
                            `Groups`
                        WHERE
                            `Departments_idDepartments` IN (SELECT 
                                    `idDepartments`
                                FROM
                                    `Departments`
                                WHERE
                                    `Name` LIKE 'Software Development'))));

-- Вывести количество лекций, которые читает преподаватель “Dave McQueen”.
SELECT 
    COUNT(`idLectures`)
FROM
    `Lectures`
WHERE
    `Teachers_idTeachers` IN (SELECT 
            `idTeachers`
        FROM
            `Teachers`
        WHERE
            `Name` LIKE 'Dave'
                AND `Surname` LIKE 'McQueen');

-- Вывести количество занятий, проводимых в аудитории “D201”.
SELECT 
    COUNT(`idLectures`)
FROM
    `Lectures`
WHERE
    `LectureRoom` LIKE 'D201';

-- Вывести названия аудиторий и количество лекций, проводимых в них.
SELECT 
    `LectureRoom`, COUNT(`idLectures`) AS 'Number of Lectures'
FROM
    `Lectures`
GROUP BY `LectureRoom`;

-- Вывести среднюю ставку преподавателей факультета “Computer Science”.
SELECT 
    AVG(`Salary`)
FROM
    `Teachers`
WHERE
    `idTeachers` IN (SELECT 
            `Teachers_idTeachers`
        FROM
            `Lectures`
        WHERE
            `idLectures` IN (SELECT 
                    `Lectures_idLectures`
                FROM
                    `GroupsLectures`
                WHERE
                    `Groups_idGroups` IN (SELECT 
                            `idGroups`
                        FROM
                            `Groups`
                        WHERE
                            `Departments_idDepartments` IN (SELECT 
                                    `idDepartments`
                                FROM
                                    `Departments`
                                WHERE
                                    `Faculties_idFaculties` IN (SELECT 
                                            `idFaculties`
                                        FROM
                                            `Faculties`
                                        WHERE
                                            `Name` LIKE 'Computer Science')))));

-- Вывести средний фонд финансирования кафедр.
SELECT 
    AVG(`Funding`)
FROM
    `Departments`;

-- Вывести полные имена преподавателей и количество читаемых ими дисциплин.
SELECT 
    CONCAT(`Name`, ' ', `Surname`) AS 'Full name',
    COUNT(`Lectures`.`Subjects_idSubjects`) AS 'Number of subjects'
FROM
    `Teachers`
        INNER JOIN
    `Lectures` ON `Lectures`.`Teachers_idTeachers` = `Teachers`.`idTeachers`
GROUP BY `Teachers`.`idTeachers`;

-- Вывести количество лекций в каждый день недели.
SELECT 
    `DayOfWeek`,
    COUNT(`Subjects_idSubjects`) AS 'Number of lectures'
FROM
    `Lectures`
GROUP BY `DayOfWeek`
ORDER BY `DayOfWeek`;

-- Вывести номера аудиторий и количество кафедр, чьи лекции в них читаются.
SELECT 
    `Lectures`.`LectureRoom` AS 'Room',
    COUNT(`Departments`.`idDepartments`) AS 'Number of department'
FROM
    `Lectures`
        INNER JOIN
    `GroupsLectures` ON `Lectures`.`idLectures` = `GroupsLectures`.`Lectures_idLectures`
        INNER JOIN
    `Groups` ON `GroupsLectures`.`Groups_idGroups` = `Groups`.`idGroups`
        INNER JOIN
    `Departments` ON `Groups`.`Departments_idDepartments` = `Departments`.`idDepartments`
GROUP BY `Lectures`.`LectureRoom`;

-- Вывести названия факультетов и количество дисциплин, которые на них читаются.
SELECT 
    `Faculties`.`Name`,
    COUNT(`Subjects`.`idSubjects`) AS 'Number of subjects'
FROM
    `Faculties`
        INNER JOIN
    `Departments` ON `Faculties`.`idFaculties` = `Departments`.`Faculties_idFaculties`
        INNER JOIN
    `Groups` ON `Departments`.`idDepartments` = `Groups`.`Departments_idDepartments`
        INNER JOIN
    `GroupsLectures` ON `GroupsLectures`.`Groups_idGroups` = `Groups`.`idGroups`
        INNER JOIN
    `Lectures` ON `GroupsLectures`.`Lectures_idLectures` = `Lectures`.`idLectures`
        INNER JOIN
    `Subjects` ON `Lectures`.`Subjects_idSubjects` = `Subjects`.`idSubjects`
GROUP BY `Faculties`.`idFaculties`;

-- Вывести количество лекций для каждой пары преподаватель-аудитория.
SELECT 
    CONCAT(`Teachers`.`Name`,
            ' ',
            `Teachers`.`Surname`) AS 'Fullname',
    `Lectures`.`LectureRoom` AS 'Room',
    COUNT(`Lectures`.`idLectures`) AS 'Number of lectures'
FROM
    `Lectures`
        INNER JOIN
    `Teachers` ON `Lectures`.`Teachers_idTeachers` = `Teachers`.`idTeachers`
GROUP BY `Fullname` , `Room`;
