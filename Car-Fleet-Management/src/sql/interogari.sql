#9.Sa se afiseze primele trei masini cu cele mai multe alimentari, in 2 ani consecutivi precizand: numar, an
#fabricatie, marca, carburant, data alimentarii. 

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