#5.Raport consum mediu al tuturor masinilor din parc continand numarul de inmatriculare si anul fabricatiei
SELECT masina.numar_inmatriculare,masina.an_fabricatie,SUM(cursa.`consum(litri)`)*100/SUM(cursa.nr_km) AS 'consum mediu\n(litri /100 km)'
FROM masina
JOIN cursa ON masina.ID_masina = cursa.id_masina
GROUP BY cursa.id_masina;

#6.Sa se genereze un raport detaliat care sa cuprinda numarul,anul fabricatiei, data cursei, soferul si consumul, 
#ordonat dupa sofer, consum, numar, in sens crescator si data cursei in sens descrescator. 
SELECT numar_inmatriculare, an_fabricatie , cursa.data_inceput , cursa.data_final, 
		sofer.nume, sofer.prenume,  cursa.`consum(litri)` * 100 / cursa.nr_km AS consum_mediu
FROM cursa
LEFT JOIN sofer ON cursa.id_sofer = sofer.ID_sofer
LEFT JOIN masina ON masina.ID_masina = cursa.id_masina
ORDER BY nume asc,consum_mediu asc, numar_inmatriculare asc, data_final desc;

#raport pentru soferii cu accidente in ordine descrescatoare
SELECT sofer.nume,sofer.prenume,COUNT(*) AS "Numar accidente"
FROM incident,sofer
WHERE tip="accident" AND sofer.id_sofer=incident.id_sofer
GROUP BY incident.id_sofer 
ORDER BY "Numar accidente" desc;
