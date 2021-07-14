#4.Să se scrie o procedura care sa permita alimentarea unei masini - procedura va fi apelata cu parametrii:
#numar_inmatriculare,data alimentarii,nume_sofer,prenume_sofer,nume benzinarie. 

DROP PROCEDURE IF EXISTS AlimentareMasina;
DELIMITER $$
CREATE PROCEDURE AlimentareMasina(numar_inmatriculare VARCHAR(7) ,data_alimentarii DATE,
								  nume_sofer VARCHAR(45),prenume_sofer VARCHAR(45),nume_benzinarie VARCHAR(45))
BEGIN
	START TRANSACTION;
    SET @idMasina=NULL;
    SET @idSofer=NULL;
    SET @idBenzinarie=NULL;
    
    SELECT ID_masina INTO @idMasina FROM masina WHERE masina.numar_inmatriculare=numar_inmatriculare;
    SELECT ID_sofer INTO @idSofer FROM sofer WHERE nume=nume_sofer AND prenume=prenume_sofer;
    SELECT ID_benzinarie INTO @idBenzinarie FROM benzinarie WHERE nume=nume_benzinarie;
    
    if(@idMasina is null OR @idSofer is null OR @idBenzinarie is null) then
    ROLLBACK;
    
    else
    
    SELECT cantitate_rezervor-nivel_rezervor INTO @pret_alimentare FROM masina WHERE ID_masina=@idMasina;
    SET @pret_alimentare=@pret_alimentare*(SELECT carburant.`pret/litru` 
											FROM carburant
											WHERE ID_carburant = ( SELECT masina.id_carburant FROM masina WHERE ID_masina=@idMasina)
                                            );
			
	UPDATE masina 
    SET masina.nivel_rezervor=masina.cantitate_rezervor
    WHERE masina.ID_masina=@idMasina;
    
    INSERT INTO alimentari(id_masina,id_sofer,data_alimentarii,pret,id_benzinarie)
    VALUE
    (@idMasina,@idSofer,data_alimentarii,@pret_alimentare,@idBenzinarie);
    COMMIT;
    
    END IF;
END$$
DELIMITER ;

#------------------------------------------------------------------------------------
#PROCEDURA inserare cursa
DROP PROCEDURE IF EXISTS InserareCursa;
DELIMITER $$
CREATE PROCEDURE InserareCursa(nume_sofer VARCHAR(45),prenume_sofer VARCHAR(45),numarInmatriculare VARCHAR(7),nrKm INT,consum INT,dataInceput DATE,dataFinal DATE)
BEGIN
START TRANSACTION;
    SET @idMasina=NULL;
    SET @idSofer=NULL;
    
    SELECT ID_masina INTO @idMasina FROM masina WHERE masina.numar_inmatriculare=numarInmatriculare;
    SELECT ID_sofer INTO @idSofer FROM sofer WHERE nume=nume_sofer AND prenume=prenume_sofer;
    
    if(@idMasina is null OR @idSofer is null) then
    ROLLBACK;
    
    else
    
     INSERT INTO cursa(id_sofer,id_masina,nr_km,`consum(litri)`,data_inceput,data_final)
    VALUE
    (@idSofer,@idMasina,nrKm,consum,dataInceput,dataFinal);
    COMMIT;
    
    END IF;
END$$
DELIMITER ;

#PROCEDURA inserare incident

DROP PROCEDURE IF EXISTS InserareIncident;
DELIMITER $$
CREATE PROCEDURE InserareIncident(TIP enum('amenda','accident','dauna totala','reparatie'),dataIncident DATE,
nume_sofer VARCHAR(45),prenume_sofer VARCHAR(45),numarInmatriculare VARCHAR(7),DESCRIERE VARCHAR(45),necesita_reparatii tinyint)

BEGIN
START TRANSACTION;
SET @idMasina=NULL;
SET @idSofer=NULL;
    
    SELECT ID_masina INTO @idMasina FROM masina WHERE masina.numar_inmatriculare=numarInmatriculare;
    SELECT ID_sofer INTO @idSofer FROM sofer WHERE nume=nume_sofer AND prenume=prenume_sofer;
    
    if(@idMasina is null OR @idSofer is null) then
    ROLLBACK;
    
    else
    
     INSERT INTO incident(tip,data_incident,id_sofer,id_masina,descriere,`necesita reparatii`)
    VALUE
    (TIP,dataIncident,@idSofer,@idMasina,DESCRIERE,necesita_reparatii);
    COMMIT;
    
    END IF;
END$$
DELIMITER ;


#PROCEDURA inserare SOFER
DROP PROCEDURE IF EXISTS InserareSofer;
DELIMITER $$
CREATE PROCEDURE InserareSofer(nume_sofer VARCHAR(45),prenume_sofer VARCHAR(45),pass VARCHAR(45))

BEGIN
	START TRANSACTION;
     INSERT INTO sofer(nume,prenume,km_totali)
    VALUE
    (nume_sofer,prenume_sofer,0);
    
    SET @id_sofer = NULL;
    
    SELECT ID_sofer INTO @id_sofer from sofer WHERE nume = nume_sofer and prenume = prenume_sofer;
    
    IF( @id_sofer is null ) then
		rollback;
	ELSE
		INSERT INTO conturi (user_name , user_pass , tip , id_sofer)
        VALUE ( concat(nume_sofer,prenume_sofer) , pass , "sofer" , @id_sofer );
        COMMIT;
	END IF;
    
    
    
END$$
DELIMITER ;


#PROCEDURA inserare MASINA
DROP PROCEDURE IF EXISTS InserareMasina;
DELIMITER $$
CREATE PROCEDURE InserareMasina(numarInmatriculare VARCHAR(7),marca VARCHAR(10),anFabricatie INT,iCarburant INT,
								kilometraj INT,cantitateRezervor INT)
BEGIN

     INSERT INTO masina(numar_inmatriculare,marca,an_fabricatie,id_carburant,kilometraj,cantitate_rezervor,nivel_rezervor)
    VALUE
    (numarInmatriculare,marca,anFabricatie,iCarburant,kilometraj,cantitateRezervor,cantitateRezervor);

END$$
DELIMITER ;

#PROCEDURA update PRET CARBURANT
DROP PROCEDURE IF EXISTS UpdatePretCarburant;
DELIMITER $$
CREATE PROCEDURE UpdatePretCarburant(TIP VARCHAR(45),PRET DECIMAL(3,2))
BEGIN
UPDATE carburant 
    SET carburant.`pret/litru`=PRET
    WHERE carburant.tip=TIP;
END$$
DELIMITER ;

#PROCEDURA pentru stergerea unei masini
DROP PROCEDURE IF EXISTS DeleteMasina;
DELIMITER $$
CREATE PROCEDURE DeleteMasina(numarInmatriculare VARCHAR(7))
BEGIN
START TRANSACTION;
	SET @idMasina=NULL;
	SELECT ID_masina INTO @idMasina FROM masina WHERE masina.numar_inmatriculare=numarInmatriculare;
if(@idMasina is null) then
    ROLLBACK;
    else
DELETE FROM masina
WHERE masina.numar_inmatriculare=numarInmatriculare;
COMMIT;
END IF;
END$$
DELIMITER ;


#PROCEDURA pentru stergerea unui sofer
DROP PROCEDURE IF EXISTS DeleteSofer;
DELIMITER $$
CREATE PROCEDURE DeleteSofer(nume_sofer VARCHAR(45),prenume_sofer VARCHAR(45))
BEGIN
START TRANSACTION;
SET @idSofer=NULL;
SELECT ID_sofer INTO @idSofer FROM sofer WHERE nume=nume_sofer AND prenume=prenume_sofer;
    if(@idSofer is null) then
		ROLLBACK;
    else
DELETE FROM sofer
WHERE sofer.ID_sofer=@idSofer;

COMMIT;
END IF;
END$$
DELIMITER ;


#5.Raport consum mediu al tuturor masinilor din parc continand numarul de inmatriculare si anul fabricatiei
DROP PROCEDURE IF EXISTS raport_consum_mediu_masini;
DELIMITER $$
CREATE PROCEDURE raport_consum_mediu_masini()
BEGIN

SELECT masina.numar_inmatriculare,masina.an_fabricatie,SUM(cursa.`consum(litri)`)*100/SUM(cursa.nr_km) AS 'consum mediu\n(litri /100 km)'
FROM masina
JOIN cursa ON masina.ID_masina = cursa.id_masina
GROUP BY cursa.id_masina;				--

END$$
DELIMITER ;


#6.Sa se genereze un raport detaliat care sa cuprinda numarul,anul fabricatiei, data cursei, soferul si consumul, 
#ordonat dupa sofer, consum, numar, in sens crescator si data cursei in sens descrescator.
DROP PROCEDURE IF EXISTS raport_consum_sofer;
DELIMITER $$
CREATE PROCEDURE raport_consum_sofer()
BEGIN

SELECT numar_inmatriculare, an_fabricatie , cursa.data_inceput , cursa.data_final, 
		sofer.nume, sofer.prenume,  cursa.`consum(litri)` * 100 / cursa.nr_km AS consum_mediu
FROM cursa
LEFT JOIN sofer ON cursa.id_sofer = sofer.ID_sofer
LEFT JOIN masina ON masina.ID_masina = cursa.id_masina
ORDER BY nume asc,consum_mediu asc, numar_inmatriculare asc, data_final desc;

END$$
DELIMITER ;
--  

#raport pentru soferii cu accidente in ordine descrescatoare
DROP PROCEDURE IF EXISTS raport_accidente;
DELIMITER $$
CREATE PROCEDURE raport_accidente()
BEGIN

SELECT sofer.nume,sofer.prenume,COUNT(*) AS "Numar accidente"
FROM incident,sofer
WHERE tip="accident" AND sofer.id_sofer=incident.id_sofer
GROUP BY incident.id_sofer 
ORDER BY "Numar accidente" desc;

END$$
DELIMITER ;



    