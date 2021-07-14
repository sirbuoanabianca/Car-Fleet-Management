	INSERT INTO sofer(nume,prenume,km_totali)
    VALUES
		("Duma","Antonio",40000),
        ("Ion","Mihai",20000),
        ("Pop","Vasile",0),
        ("Popa","Marin",15000),
        ("Marin","Ovidiu",30000);
        
        INSERT INTO carburant(tip,`pret/litru`)
        VALUES
			("motorina",4.53),
            ("benzina",4.44),
            ("GPL",2.53);
        
        
	INSERT INTO masina(numar_inmatriculare,marca,an_fabricatie,id_carburant,kilometraj,cantitate_rezervor,nivel_rezervor)
    VALUES
		("TMXXYY1","Logan",2007,1,100,50,50),
        ("TMXXYY2","Renault",2006,3,50,55,55),
        ("TMXXYY3","Aro",2000,2,150,50,50),
        ("TMXXYY4","Cielo",2001,1,230,45,45),
        ("TMXXYY5","Matiz",2005,2,89,55,55),
        ("TMXXYY6","Nissan",2006,2,256,60,60);
        
	INSERT INTO benzinarie (nume)
    VALUES
		("Petrom"),
        ("OMV"),
        ("Lukoil"),
        ("MOL"),
        ("Rompetrol");
        
     INSERT INTO cursa(id_sofer,id_masina,nr_km,`consum(litri)`,data_inceput,data_final)
     VALUES
		(1,4,65,5,"2019-10-01","2019-10-01"),
        (3,2,110,15,"2019-10-02","2019-10-03"),
        (1,6,78,12,"2019-10-05","2019-10-05"),
        (5,1,44,9,"2019-10-06","2019-10-07"),
        (4,2,57,10,"2019-10-07","2019-10-08");
        
       # (2,1,77,5,"2019-10-10","2019-10-11"); #aici ar trebui sa dea eroare:consumul mediu rezultat este de 3 ori mai mic decat consumul mediu total
       
    INSERT INTO incident (tip,data_incident,id_sofer,id_masina,descriere,`necesita reparatii`)
    VALUES
		("accident","2018-10-05",1,4,"Neacordare de prioritate",1),
        ("accident","2018-01-12",1,2,"Tamponare cu masina parcata",1),
        ("amenda","2020-03-03",4,1,"Depasire limita de viteza",0),
        ("accident","2017-12-12",3,5,"Pierdut control polei",1),
        ("accident","2020-02-10",2,6,"Depasire pe linie continua",1),
        ("accident","2018-04-23",5,4,"Consum alcool",1),
        ("dauna totala","2017-06-30",5,3,"Adormire la volan",1),
        ("reparatie","2018-07-20",3,5,"reparatie totala",0);
        
  
    INSERT INTO conturi(user_name,user_pass,tip,id_sofer) 
    VALUES
		("DumaAntonio","toni83","sofer",1),
        ("IonMihai","ionut90","sofer",2),
        ("PopVasile","vasp","sofer",3),
        ("PopaMarin","marinescu00","sofer",4),
        ("MarinOvidiu","ovim0123","sofer",5),
        ("admin","admin","admin",NULL);