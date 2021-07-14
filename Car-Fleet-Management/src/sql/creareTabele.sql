-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema parc_auto
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema parc_auto
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS parc_auto;
CREATE SCHEMA IF NOT EXISTS `parc_auto` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `parc_auto` ;

-- -----------------------------------------------------
-- Table `parc_auto`.`benzinarie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`benzinarie` (
  `ID_benzinarie` INT NOT NULL AUTO_INCREMENT,
  `nume` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`ID_benzinarie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parc_auto`.`carburant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`carburant` (
  `ID_carburant` INT NOT NULL AUTO_INCREMENT,
  `tip` VARCHAR(45) NULL DEFAULT NULL,
  `pret/litru` DECIMAL(3,2) NULL DEFAULT NULL,
  PRIMARY KEY (`ID_carburant`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parc_auto`.`masina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`masina` (
  `ID_masina` INT NOT NULL AUTO_INCREMENT,
  `numar_inmatriculare` VARCHAR(7) NULL DEFAULT NULL,
  `marca` VARCHAR(10) NULL DEFAULT NULL,
  `an_fabricatie` INT NULL DEFAULT NULL,
  `id_carburant` INT NULL DEFAULT NULL,
  `kilometraj` INT NULL DEFAULT NULL,
  `cantitate_rezervor` INT NULL DEFAULT NULL,
  `nivel_rezervor` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ID_masina`),
  INDEX `fk_masina_carburant1_idx` (`id_carburant` ASC) VISIBLE,
  CONSTRAINT `fk_masina_carburant1`
    FOREIGN KEY (`id_carburant`)
    REFERENCES `parc_auto`.`carburant` (`ID_carburant`)
    ON DELETE NO ACTION 	
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parc_auto`.`sofer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`sofer` (
  `ID_sofer` INT NOT NULL AUTO_INCREMENT,
  `nume` VARCHAR(45) NULL DEFAULT NULL,
  `prenume` VARCHAR(45) NULL DEFAULT NULL,
  `km_totali` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ID_sofer`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parc_auto`.`alimentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`alimentari` (
  `ID_alimentare` INT NOT NULL AUTO_INCREMENT,
  `id_masina` INT NULL DEFAULT NULL,
  `id_sofer` INT NULL DEFAULT NULL,
  `data_alimentarii` DATE NULL DEFAULT NULL,
  `pret` INT NULL DEFAULT NULL,
  `id_benzinarie` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ID_alimentare`),
  INDEX `fk_alimentari_benzinarie_idx` (`id_benzinarie` ASC) VISIBLE,
  INDEX `fk_alimentari_masina1_idx` (`id_masina` ASC) VISIBLE,
  INDEX `fk_alimentari_sofer1_idx` (`id_sofer` ASC) VISIBLE,
  CONSTRAINT `fk_alimentari_benzinarie`
    FOREIGN KEY (`id_benzinarie`)
    REFERENCES `parc_auto`.`benzinarie` (`ID_benzinarie`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alimentari_masina1`
    FOREIGN KEY (`id_masina`)
    REFERENCES `parc_auto`.`masina` (`ID_masina`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alimentari_sofer1`
    FOREIGN KEY (`id_sofer`)
    REFERENCES `parc_auto`.`sofer` (`ID_sofer`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parc_auto`.`cursa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`cursa` (
  `ID_cursa` INT NOT NULL AUTO_INCREMENT,
  `id_sofer` INT NULL DEFAULT NULL,
  `id_masina` INT NULL DEFAULT NULL,
  `nr_km` INT NULL DEFAULT NULL,
  `consum(litri)` INT NULL DEFAULT NULL,
  `data_inceput` DATE NULL DEFAULT NULL,
  `data_final` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`ID_cursa`),
  INDEX `fk_cursa_sofer1_idx` (`id_sofer` ASC) VISIBLE,
  INDEX `fk_cursa_masina1_idx` (`id_masina` ASC) VISIBLE,
  CONSTRAINT `fk_cursa_sofer1`
    FOREIGN KEY (`id_sofer`)
    REFERENCES `parc_auto`.`sofer` (`ID_sofer`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cursa_masina1`
    FOREIGN KEY (`id_masina`)
    REFERENCES `parc_auto`.`masina` (`ID_masina`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parc_auto`.`incident`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`incident` (
  `ID_incident` INT NOT NULL AUTO_INCREMENT,
  `tip` ENUM('amenda','accident','dauna totala','reparatie') NULL DEFAULT NULL,
  `data_incident` DATE NULL DEFAULT NULL,
  `id_sofer` INT NULL DEFAULT NULL,
  `id_masina` INT NULL DEFAULT NULL,
  `descriere` VARCHAR(45) NULL DEFAULT NULL,
  `necesita reparatii` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`ID_incident`),
  INDEX `fk_incident_sofer1_idx` (`id_sofer` ASC) VISIBLE,
  INDEX `fk_incident_masina1_idx` (`id_masina` ASC) VISIBLE,
  CONSTRAINT `fk_incident_sofer1`
    FOREIGN KEY (`id_sofer`)
    REFERENCES `parc_auto`.`sofer` (`ID_sofer`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_incident_masina1`
    FOREIGN KEY (`id_masina`)
    REFERENCES `parc_auto`.`masina` (`ID_masina`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `parc_auto`.`status_masina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parc_auto`.`status_masina` (
  `id_masina` INT NOT NULL,
  `disponibila` TINYINT NULL DEFAULT NULL,
  `detalii` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_masina`),
  CONSTRAINT `fk_status_masina_masina1`
    FOREIGN KEY (`id_masina`)
    REFERENCES `parc_auto`.`masina` (`ID_masina`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS `parc_auto`.`conturi` (
  `ID_cont` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NULL,
  `user_pass` VARCHAR(45) NULL,
  `tip` ENUM('sofer', 'admin') NULL,
  `id_sofer` INT,
  PRIMARY KEY (`ID_cont`),
  CONSTRAINT `fk_conturi_sofer1`
    FOREIGN KEY (`id_sofer`)
    REFERENCES `parc_auto`.`sofer` (`ID_sofer`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);
  


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
