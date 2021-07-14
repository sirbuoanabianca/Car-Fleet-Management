#9.Sa se afiseze primele trei masini cu cele mai multe alimentari, in 2 ani consecutivi precizand: numar, an
#fabricatie, marca, carburant, data alimentarii. 
DROP VIEW IF EXISTS top_3_masini_alimentari;
CREATE VIEW top_3_masini_alimentari
AS
		SELECT masina.numar_inmatriculare,masina.an_fabricatie,masina.marca,carburant.tip,alimentari.data_alimentarii
FROM alimentari 
LEFT JOIN masina ON alimentari.id_masina = masina.ID_masina 
LEFT JOIN carburant ON masina.id_carburant = carburant.ID_carburant
 join (SELECT id_masina
			FROM alimentari
            WHERE data_alimentarii>date_sub(current_date(),interval 2 year)
            GROUP BY id_masina ORDER BY count(*) desc limit 3) aux 
	ON alimentari.id_masina in (aux.id_masina) 
WHERE data_alimentarii>date_sub(current_date(),interval 2 year);


#10.Sa se afiseze soferul care are cel mai mare consum general (calculat pentru tot kilometrajul facut),
#precizand pentru fiecare masina condusa de respectivul sofer urmatoarele: sofer, numar, consum, si
#ponderea kilometrajului cu respectiva masina in numarul total de km parcursi de respectivul sofer. 
         
DROP VIEW IF EXISTS sofer_cel_mai_mare_consum;
CREATE VIEW sofer_cel_mai_mare_consum
AS   
 SELECT sofer.nume,
		sofer.prenume,
        ConsumMediuSofer(sofer.nume,sofer.prenume) AS "consum mediu total al soferului (L/ 100km)",
        masina.numar_inmatriculare,
        SUM(cursa.`consum(litri)`) AS "consum carburant litri pe masina",
        SUM(cursa.nr_km) AS "km parcursi cu respectiva masina",
        KmSoferPeMasina(cursa.id_sofer,cursa.id_masina)*100/sofer.km_totali AS "Procent km parcursi pe masina din km totali ai soferului"        
 FROM cursa
 LEFT JOIN sofer ON sofer.ID_sofer = cursa.id_sofer
 LEFT JOIN masina ON masina.ID_masina = cursa.id_masina
 WHERE cursa.id_sofer IN (SELECT sofer.ID_sofer 
							FROM sofer 
                            WHERE ConsumMediuSofer(sofer.nume,sofer.prenume) 
									= (SELECT MAX(ConsumMediuSofer(nume,prenume)) 
										FROM sofer )) 
GROUP BY masina.numar_inmatriculare;

#Afisare conturi cu detalii cont si nume sofer
DROP VIEW IF EXISTS detalii_cont;
CREATE VIEW detalii_cont
AS 
SELECT * from sofer 
inner join conturi using (id_sofer);  


#Afisare masini disponibile cu rezervorul plin
DROP VIEW IF EXISTS masini_disponibile_rezervor_plin;
CREATE VIEW masini_disponibile_rezervor_plin
AS 
SELECT numar_inmatriculare,detalii
FROM masina
JOIN status_masina ON status_masina.ID_masina=masina.ID_masina AND status_masina.disponibila<>0;

