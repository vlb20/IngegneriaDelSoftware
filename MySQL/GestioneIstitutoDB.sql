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
-- Data for table `mydb_argo`.`docenti`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`docenti` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES ('doc1', 'prova1', 'ersilia', 'viola', 'VLIRSL80A41G964Q', '1980-01-01', 'Pozzuoli', 'ersv@learnopolis.it', '3274638973');
INSERT INTO `mydb_argo`.`docenti` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES ('doc2', 'proovaprova', 'giuditta', 'grosso', 'VLIRSL80A41G964Q', '1980-01-01', 'Napoli', 'g.grosso@learnopolis.it', '3274638973');
INSERT INTO `mydb_argo`.`docenti` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES ('doc3', '1234', 'anna', 'angeli', 'VLIRSL80A41G964Q', '1980-01-01', 'Napoli', 'annaan@learnopolis.it', '3274638973');
INSERT INTO `mydb_argo`.`docenti` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES ('vinny', 'FNS1926', 'vincenzo', 'moscato', 'VLIRSL80A41G964Q', '1980-01-01', 'Pozzuoli', 'vinnymoscato@learnopolis.it', '3274638973');
INSERT INTO `mydb_argo`.`docenti` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES ('doc4', '*hehvb&', 'ivania', 'avolio', 'VLIRSL80A41G964Q', '1980-01-01', 'Quarto', 'davolio@learnopolis.it', '3274638973');
INSERT INTO `mydb_argo`.`docenti` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES ('doc5', '!edrtyu/', 'paola', 'cannada', 'VLIRSL80A41G964Q', '1980-01-01', 'Monteruscello', 'emc2@learnopolis.it', '3274638973');
INSERT INTO `mydb_argo`.`docenti` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES ('doc6', '^fcgv*', 'brunella', 'basso', 'VLIRSL80A41G964Q', '1980-01-01', 'Giugliano in Campania', 'bbasso@learnopolis.it', '3274638973');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb_argo`.`studenti`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (1, 'cris', 'FNS4523', 'Cristina', 'Carleo', 'VLIRSL80A41G964Q', '2001-06-15', 'Giugliano in Campania', 'cris@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (2, 'vinci', 'uIQP503!24V^', 'Vincenzo Luigi', 'Bruno', 'VLIRSL80A41G964Q', '2001-06-15', 'Napoli', 'vlb@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (3, 'fla', 'uIQP503!24V^', 'Flavia', 'De Rosa', 'VLIRSL80A41G964Q', '2001-06-15', 'Napoli', 'fdr@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (4, 'kvaradona', 'uIQP503!24V^', 'Khvicha', 'Kvaratskhelia', 'VLIRSL80A41G964Q', '2001-06-15', 'Pozzuoli', 'kvara77@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (5, 'dilo', 'uIQP503!24V^', 'Giovanni', 'Di lorenzo', 'VLIRSL80A41G964Q', '2001-06-15', 'Pianura', 'dilo22@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (6, 'poli', 'uIQP503!24V^', 'Matteo', 'Politano', 'VLIRSL80A41G964Q', '2001-06-15', 'Monteruscello', 'poli21@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (7, 'eg94', 'uIQP503!24V^', 'Erich', 'Gamma', 'VLIRSL80A41G964Q', '2001-06-15', 'Marano di Napoli', 'eg94@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (8, 'jv94', 'uIQP503!24V^', 'John', 'Vlissides', 'VLIRSL80A41G964Q', '2001-06-15', 'Mugnano', 'jv94@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (9, 'rh94', 'uIQP503!24V^', 'Richard', 'Helm', 'VLIRSL80A41G964Q', '2001-06-15', 'Casavatore', 'rh94@studenti.learnopolis.it', '3627436428');
INSERT INTO `mydb_argo`.`studenti` (`matricola`, `username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`) VALUES (10, 'rj94', 'uIQP503!24V^', 'Ralph', 'Johnson', 'VLIRSL80A41G964Q', '2001-06-15', 'Villaricca', 'rj94@studenti.learnopolis.it', '3627436428');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb_argo`.`genitori`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`genitori` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`, `studente_figlio`) VALUES ('papadivinci', 'minollo3', 'Stefano', 'Bruno', 'VLIRSL80A41G964Q', '1980-01-01', 'Pozzuoli', 'stefbruno@alice.it', '3454738947', 2);
INSERT INTO `mydb_argo`.`genitori` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`, `studente_figlio`) VALUES ('mammadikvara', 'georgia26', 'Skyler', 'Beridze', 'VLIRSL80A41G964Q', '1980-01-01', 'Tbilisi', 'skyler35@hotmail.it', '3454738947', 4);
INSERT INTO `mydb_argo`.`genitori` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`, `studente_figlio`) VALUES ('genitore1', 'evitaperon36', 'Andrea', 'Cruz', 'VLIRSL80A41G964Q', '1980-01-01', 'Buenos Aires', 'evita80@yahoo.it', '3454738947', 6);
INSERT INTO `mydb_argo`.`genitori` (`username`, `password`, `nome`, `cognome`, `codiceFiscale`, `dataNascita`, `comuneResidenza`, `email`, `numeroCellulare`, `studente_figlio`) VALUES ('genitore2', 'malena64', 'Simone', 'Bellucci', 'VLIRSL80A41G964Q', '1980-01-01', 'Roma', 'ninasimone@gmail.com', '3454738947', 8);

COMMIT;


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
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (1, 'Italiano', 'doc2', 1);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (2, 'Storia', 'doc3', 1);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (3, 'Latino', 'doc1', 1);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (4, 'Matematica', 'doc4', 2);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (5, 'Fisica', 'doc5', 2);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (6, 'Scienze', 'doc6', 2);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (7, 'Italiano', 'doc2', 3);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (8, 'Informatica', 'vinny', 3);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (9, 'Matematica', 'doc4', 3);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (10, 'Italiano', NULL, 4);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (11, 'Storia', NULL, 4);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (12, 'Latino', NULL, 4);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (13, 'Matematica', NULL, 5);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (14, 'Fisica', NULL, 5);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (15, 'Scienze', NULL, 5);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (16, 'Italiano', 'doc3', 6);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (17, 'Informatica', 'vinny', 6);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (18, 'Matematica', 'doc4', 6);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (19, 'Italiano', 'doc2', 7);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (20, 'Latino', 'doc1', 7);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (21, 'Filosofia', 'doc3', 7);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (22, 'Matematica', 'doc4', 8);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (23, 'Fisica', 'doc4', 8);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (24, 'Scienze', 'doc5', 8);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (25, 'Italiano', NULL, 9);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (26, 'Informatica', 'vinny', 9);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (27, 'Database', 'vinny', 9);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (28, 'Italiano', NULL, 10);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (29, 'Storia', NULL, 10);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (30, 'Filosofia', NULL, 10);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (31, 'Matematica', NULL, 11);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (32, 'Fisica', NULL, 11);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (33, 'Scienze', NULL, 11);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (34, 'Italiano', NULL, 12);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (35, 'Informatica', 'vinny', 12);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (36, 'Database', NULL, 12);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (37, 'Italiano', NULL, 13);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (38, 'Storia', NULL, 13);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (39, 'Filosofia', NULL, 13);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (40, 'Matematica', NULL, 14);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (41, 'Fisica', NULL, 14);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (42, 'Scienze', NULL, 14);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (43, 'Italiano', NULL, 15);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (44, 'Informatica', NULL, 15);
INSERT INTO `mydb_argo`.`materie` (`idmaterie`, `nome`, `docente`, `classe`) VALUES (45, 'Database', 'vinny', 15);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb_argo`.`valutazioni`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (1, 2, 4, '2023-06-14', 8);
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (2, 4, 4, '2023-06-14', 7.5);
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (3, 4, 5, '2023-06-14', 8);
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (4, 6, 4, '2023-06-14', 4);
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (5, 6, 5, '2023-06-14', 6);
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (6, 6, 6, '2023-06-14', 8);
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (7, 8, 26, '2023-06-14', 10);
INSERT INTO `mydb_argo`.`valutazioni` (`idvalutazioni`, `studente`, `materia`, `data`, `voto`) VALUES (8, 8, 27, '2023-06-14', 10);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb_argo`.`studente_in_classe`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb_argo`;
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (1, 1);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (2, 2);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (3, 1);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (4, 2);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (5, 1);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (6, 2);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (7, 3);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (8, 3);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (9, 9);
INSERT INTO `mydb_argo`.`studente_in_classe` (`studente`, `classe`) VALUES (10, 9);

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

