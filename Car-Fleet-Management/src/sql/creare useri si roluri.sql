#crearea de roluri si useri pentru baza de date
#userii:administrator(are toate privilegiile) si sofer

CREATE USER IF NOT EXISTS 'administrator'@'localhost' IDENTIFIED BY '5678';
CREATE USER IF NOT EXISTS 'sofer'@'localhost' IDENTIFIED BY '1234';

GRANT ALL ON `parc_auto`.* TO 'administrator'@'localhost';
GRANT EXECUTE ON PROCEDURE InserareCursa TO 'sofer'@'localhost';
GRANT EXECUTE ON PROCEDURE InserareIncident TO 'sofer'@'localhost';
GRANT EXECUTE ON PROCEDURE AlimentareMasina TO 'sofer'@'localhost'; 
