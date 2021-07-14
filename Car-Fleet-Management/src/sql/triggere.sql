
# TRIGGER creare status masina la inserarea unei masini in tabela
DROP TRIGGER IF EXISTS creare_status ;
DELIMITER $$
CREATE TRIGGER creare_status AFTER insert ON masina
FOR EACH ROW 
BEGIN
INSERT INTO status_masina(id_masina,disponibila,detalii)
VALUES
(NEW.id_masina,1,"in parcare");

END $$
DELIMITER ;

#7.Sa se scrie un trigger care sa nu permita adaugarea informatiilor despre cursa, daca consumul mediu rezultat este de 3 ori mai mic decat consumul mediu total pe masina respectiva 
#si sa semnaleze eroare. 
DROP TRIGGER IF EXISTS nu_permit_inserare_cursa;
DELIMITER $$

CREATE TRIGGER nu_permit_inserare_cursa BEFORE insert on cursa
FOR EACH ROW
BEGIN
SET @consumMediuTotal=NULL;

SELECT SUM(cursa.`consum(litri)`) * 100 / SUM(cursa.nr_km) INTO @consumMediuTotal FROM cursa WHERE cursa.id_masina=NEW.id_masina;
IF(NEW.`consum(litri)`/NEW.nr_km * 100< @consumMediuTotal/3) THEN
SIGNAL SQLSTATE '45000' set message_text='EROARE la adaugarea informatiilor despre cursa!';
END IF;
END $$
DELIMITER ;

#trigger pentru incidente-update status masina in caz de accident/necesita reparatii sau dauna totala
DROP TRIGGER IF EXISTS incident_update_status;
DELIMITER $$

CREATE TRIGGER incident_update_status AFTER insert on incident
FOR EACH ROW
BEGIN
if (NEW.tip="accident" AND NEW.`necesita reparatii`=1) THEN
		UPDATE status_masina
        SET disponibila=0,
			detalii="Necesita reparatii!"
        WHERE status_masina.id_masina=NEW.id_masina;

ELSEIF(NEW.tip="dauna totala") THEN
		UPDATE status_masina
        SET disponibila=0,
			detalii="DAUNA TOTALA!"
         WHERE status_masina.id_masina=NEW.id_masina; 
         
ELSEIF(NEW.tip="reparatie") THEN
		UPDATE status_masina
        SET disponibila=1,
			detalii="Masina se afla in parcare"
         WHERE status_masina.id_masina=NEW.id_masina;          
END IF;

END $$
DELIMITER ;


#trigger pentru inserari in cursa - adaugare km si scadere nivel carburant
DROP TRIGGER IF EXISTS trigger_update_km_combustibil;
DELIMITER $$

CREATE TRIGGER trigger_update_km_combustibil AFTER insert on cursa
FOR EACH ROW
BEGIN
IF( EXISTS (SELECT masina.ID_masina from masina where masina.ID_masina= new.id_masina)
	AND
    EXISTS (SELECT sofer.ID_sofer from sofer WHERE sofer.ID_sofer = NEW.id_sofer)) THEN 
    
    UPDATE sofer 
    SET km_totali = km_totali+NEW.nr_km
    WHERE sofer.ID_sofer = NEW.id_sofer;
    
    UPDATE masina
    SET kilometraj = kilometraj + NEW.nr_km,
		nivel_rezervor = nivel_rezervor - NEW.`consum(litri)`
	WHERE masina.ID_masina = NEW.id_masina;
END IF;

END $$
DELIMITER ;