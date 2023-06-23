-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb_argo
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb_argo` ;

-- -----------------------------------------------------
-- Schema mydb_argo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb_argo` DEFAULT CHARACTER SET utf8 ;
USE `mydb_argo` ;

-- -----------------------------------------------------
-- Table `mydb_argo`.`docenti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`docenti` (
  `username` VARCHAR(20) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  `nome` VARCHAR(100) NULL,
  `cognome` VARCHAR(100) NULL,
  `codiceFiscale` VARCHAR(16) NULL,
  `dataNascita` DATE NULL,
  `comuneResidenza` VARCHAR(50) NULL,
  `email` VARCHAR(45) NULL,
  `numeroCellulare` VARCHAR(11) NULL,
  PRIMARY KEY (`username`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`studenti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`studenti` (
  `matricola` INT NOT NULL,
  `username` VARCHAR(20) NULL,
  `password` VARCHAR(50) NULL,
  `nome` VARCHAR(100) NULL,
  `cognome` VARCHAR(100) NULL,
  `codiceFiscale` VARCHAR(16) NULL,
  `dataNascita` DATE NULL,
  `comuneResidenza` VARCHAR(50) NULL,
  `email` VARCHAR(45) NULL,
  `numeroCellulare` VARCHAR(11) NULL,
  PRIMARY KEY (`matricola`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`genitori`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`genitori` (
  `username` VARCHAR(20) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  `nome` VARCHAR(100) NULL,
  `cognome` VARCHAR(100) NULL,
  `codiceFiscale` VARCHAR(16) NULL,
  `dataNascita` DATE NULL,
  `comuneResidenza` VARCHAR(50) NULL,
  `email` VARCHAR(45) NULL,
  `numeroCellulare` VARCHAR(11) NULL,
  `studente_figlio` INT NULL,
  PRIMARY KEY (`username`),
  INDEX `genitore_di_idx` (`studente_figlio` ASC) VISIBLE,
  CONSTRAINT `genitore_di`
    FOREIGN KEY (`studente_figlio`)
    REFERENCES `mydb_argo`.`studenti` (`matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`classi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`classi` (
  `idclassi` INT NOT NULL,
  `sezione` CHAR(1) NULL,
  `anno` VARCHAR(3) NULL,
  `annoScolastico` INT NULL,
  PRIMARY KEY (`idclassi`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`materie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`materie` (
  `idmaterie` INT NOT NULL,
  `nome` VARCHAR(30) NULL,
  `docente` VARCHAR(20) NULL,
  `classe` INT NOT NULL,
  PRIMARY KEY (`idmaterie`),
  INDEX `insegnata_in_idx` (`classe` ASC) VISIBLE,
  INDEX `insegnata_da_idx` (`docente` ASC) VISIBLE,
  CONSTRAINT `insegnata_in`
    FOREIGN KEY (`classe`)
    REFERENCES `mydb_argo`.`classi` (`idclassi`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `insegnata_da`
    FOREIGN KEY (`docente`)
    REFERENCES `mydb_argo`.`docenti` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`valutazioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`valutazioni` (
  `idvalutazioni` INT NOT NULL,
  `studente` INT NULL,
  `materia` INT NULL,
  `data` DATE NULL,
  `voto` FLOAT NULL,
  PRIMARY KEY (`idvalutazioni`),
  INDEX `assegnata_a_idx` (`studente` ASC) VISIBLE,
  INDEX `assegnata_in_idx` (`materia` ASC) VISIBLE,
  CONSTRAINT `assegnata_a`
    FOREIGN KEY (`studente`)
    REFERENCES `mydb_argo`.`studenti` (`matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `assegnata_in`
    FOREIGN KEY (`materia`)
    REFERENCES `mydb_argo`.`materie` (`idmaterie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`pagelle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`pagelle` (
  `studente` INT NOT NULL,
  `quadrimestre` VARCHAR(45) NOT NULL,
  `annoScolastico` INT NOT NULL,
  `stato` VARCHAR(45) NULL,
  `mediavoti` FLOAT NULL,
  `idpagelle` INT NOT NULL,
  PRIMARY KEY (`idpagelle`),
  CONSTRAINT `ottenuta_da`
    FOREIGN KEY (`studente`)
    REFERENCES `mydb_argo`.`studenti` (`matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`studente_in_classe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`studente_in_classe` (
  `studente` INT NOT NULL,
  `classe` INT NOT NULL,
  PRIMARY KEY (`studente`, `classe`),
  INDEX `classe_idx` (`classe` ASC) VISIBLE,
  CONSTRAINT `studente`
    FOREIGN KEY (`studente`)
    REFERENCES `mydb_argo`.`studenti` (`matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `classe`
    FOREIGN KEY (`classe`)
    REFERENCES `mydb_argo`.`classi` (`idclassi`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`registri_elettronici`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`registri_elettronici` (
  `idregistro` INT NOT NULL,
  `classe` INT NOT NULL,
  PRIMARY KEY (`idregistro`, `classe`),
  INDEX `relativo_a_idx` (`classe` ASC) VISIBLE,
  CONSTRAINT `relativo_a`
    FOREIGN KEY (`classe`)
    REFERENCES `mydb_argo`.`classi` (`idclassi`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`attivita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`attivita` (
  `idattivita` INT NOT NULL,
  `classe` INT NULL,
  `docente` VARCHAR(20) NULL,
  `data` DATE NULL,
  `descrizione` VARCHAR(100) NULL,
  PRIMARY KEY (`idattivita`),
  INDEX `classe_idx` (`classe` ASC) VISIBLE,
  INDEX `docente_idx` (`docente` ASC) VISIBLE,
  CONSTRAINT `classe_coinvolta`
    FOREIGN KEY (`classe`)
    REFERENCES `mydb_argo`.`registri_elettronici` (`idregistro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `docente_presente`
    FOREIGN KEY (`docente`)
    REFERENCES `mydb_argo`.`docenti` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_argo`.`giudizi_finali`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_argo`.`giudizi_finali` (
  `pagella` INT NOT NULL,
  `materia` INT NOT NULL,
  `voto` FLOAT NULL,
  `quadrimestre` VARCHAR(45) NULL,
  INDEX `giudizio_in_idx` (`materia` ASC) VISIBLE,
  INDEX `relativo_a_idx` (`pagella` ASC) VISIBLE,
  PRIMARY KEY (`pagella`, `materia`),
  CONSTRAINT `giudizio_in`
    FOREIGN KEY (`materia`)
    REFERENCES `mydb_argo`.`materie` (`idmaterie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `contenuto_in`
    FOREIGN KEY (`pagella`)
    REFERENCES `mydb_argo`.`pagelle` (`studente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `mydb_argo`.`classi`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (1, 'A', 'I', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (2, 'B', 'I', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (3, 'C', 'I', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (4, 'A', 'II', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (5, 'B', 'II', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (6, 'C', 'II', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (7, 'A', 'III', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (8, 'B', 'III', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (9, 'C', 'III', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (10, 'A', 'IV', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (11, 'B', 'IV', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (12, 'C', 'IV', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (13, 'A', 'V', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (14, 'B', 'V', 2022);
INSERT INTO `mydb_argo`.`classi` (`idclassi`, `sezione`, `anno`, `annoScolastico`) VALUES (15, 'C', 'V', 2022);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb_argo`.`materie`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (1, 'Italiano', NULL, 1);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (2, 'Storia', NULL, 1);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (3, 'Latino', NULL, 1);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (4, 'Matematica', NULL, 2);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (5, 'Fisica', NULL, 2);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (6, 'Scienze', NULL, 2);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (7, 'Italiano', NULL, 3);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (8, 'Informatica', NULL, 3);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (9, 'Matematica', NULL, 3);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (10, 'Italiano', NULL, 4);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (11, 'Storia', NULL, 4);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (12, 'Latino', NULL, 4);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (13, 'Matematica', NULL, 5);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (14, 'Fisica', NULL, 5);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (15, 'Scienze', NULL, 5);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (16, 'Italiano', NULL, 6);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (17, 'Informatica', NULL, 6);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (18, 'Matematica', NULL, 6);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (19, 'Italiano', NULL, 7);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (20, 'Latino', NULL, 7);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (21, 'Filosofia', NULL, 7);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (22, 'Matematica', NULL, 8);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (23, 'Fisica', NULL, 8);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (24, 'Scienze', NULL, 8);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (25, 'Italiano', NULL, 9);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (26, 'Informatica', NULL, 9);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (27, 'Database', NULL, 9);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (28, 'Italiano', NULL, 10);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (29, 'Storia', NULL, 10);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (30, 'Filosofia', NULL, 10);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (31, 'Matematica', NULL, 11);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (32, 'Fisica', NULL, 11);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (33, 'Scienze', NULL, 11);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (34, 'Italiano', NULL, 12);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (35, 'Informatica', NULL, 12);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (36, 'Database', NULL, 12);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (37, 'Italiano', NULL, 13);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (38, 'Storia', NULL, 13);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (39, 'Filosofia', NULL, 13);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (40, 'Matematica', NULL, 14);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (41, 'Fisica', NULL, 14);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (42, 'Scienze', NULL, 14);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (43, 'Italiano', NULL, 15);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (44, 'Informatica', NULL, 15);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (45, 'Database', NULL, 15);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb_argo`.`registri_elettronici`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (1, 1);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (2, 2);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (3, 3);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (4, 4);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (5, 5);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (6, 6);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (7, 7);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (8, 8);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (9, 9);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (10, 10);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (11, 11);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (12, 12);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (13, 13);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (14, 14);
INSERT INTO `mydb_argo`.`registri_elettronici` (`idregistro`, `classe`) VALUES (15, 15);

COMMIT;

