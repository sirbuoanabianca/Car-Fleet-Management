#8.Sa se scrie o functie care sa primeasca ca si parametri sofer(nume,prenume), si sa returneze consumul mediu. 

DROP FUNCTION IF EXISTS ConsumMediuSofer;
DELIMITER $$

CREATE FUNCTION ConsumMediuSofer (nume VARCHAR(45),prenume VARCHAR(45))
 RETURNS DECIMAL(6,4)
 DETERMINISTIC
BEGIN
DECLARE consum_mediu DECIMAL(6,4) DEFAULT 0;
DECLARE idSofer INT; 

SELECT ID_sofer INTO idSofer FROM sofer WHERE sofer.nume=nume AND sofer.prenume=prenume;
SELECT SUM(cursa.`consum(litri)`)*100/SUM(cursa.nr_km) INTO consum_mediu FROM cursa WHERE cursa.id_sofer=idSofer;
RETURN consum_mediu;

END$$
DELIMITER ;

#functie care calculeaza nr_km parcursi de un sofer pe o masina
DROP FUNCTION IF EXISTS KmSoferPeMasina;
DELIMITER $$

CREATE FUNCTION KmSoferPeMasina (idSofer INT,idMasina INT)
 RETURNS INT
 DETERMINISTIC
BEGIN
DECLARE kmParcursi INT DEFAULT 0; 

SELECT SUM(cursa.nr_km) INTO kmParcursi 
FROM cursa 
WHERE cursa.id_sofer=idSofer AND cursa.id_masina=idMasina
GROUP BY cursa.id_masina;
RETURN kmParcursi;

END$$
DELIMITER ;
