package main;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.*;
import java.util.Scanner;

public class Menu {

    public int createMenuSofer()
    {
        int selection;
        Scanner input = new Scanner(System.in);

        System.out.println("Alegeti o optiune din meniu");
        System.out.println("-------------------------\n");
        System.out.println("1 - ADAUGA O CURSA");
        System.out.println("2 - ADAUGA UN INCIDENT");
        System.out.println("3 - ADAUGA O ALIMENTARE");
        System.out.println("4 - LOGOUT");

        selection = input.nextInt();
        return selection;
    }

    public int createMenuAdmin() {
        int selection;
        Scanner input = new Scanner(System.in);

        System.out.println("Alegeti o optiune din meniu");
        System.out.println("-------------------------\n");
        System.out.println("1 - STERGE O MASINA");
        System.out.println("2 - STERGE UN SOFER");
        System.out.println("3 - UPDATE PRET CARBURANT");
        System.out.println("4 - ADAUGA O MASINA");
        System.out.println("5 - ADAUGA UN SOFER");
        System.out.println("6 - RAPORT consum mediu al tuturor masinilor din parc");
        System.out.println("7 - RAPORT CONSUM dupa soferi");
        System.out.println("8 - RAPORT pentru soferii cu accidente");
        System.out.println("9 - INTEROGARE data de la tastatura");
        System.out.println("10 - LOGOUT");

        selection = input.nextInt();
        return selection;
    }

    public void executeSelectionSofer(Connection c,int idSofer) throws SQLException {


        String nume="",prenume="";
        Statement getInfoSofer = c.createStatement();
        ResultSet selectieSofer = getInfoSofer.executeQuery("SELECT * from sofer WHERE ID_sofer = "+ idSofer);
        if(selectieSofer.next()){
                nume=selectieSofer.getString("nume");
                prenume=selectieSofer.getString("prenume");
        }

        boolean repeatLoop=true;
        while(repeatLoop) {
            int selection = createMenuSofer();
            switch (selection) {
                case 1:
                    try {
                        System.out.println("Introduceti NUMARUL DE INMATRICULARE: ");
                        Scanner in = new Scanner(System.in);
                        String nr_inmatriculare = in.nextLine();

                        System.out.println("Introduceti numarul de km: ");
                        int nrKm = in.nextInt();

                        System.out.println("Introduceti consumul(numarul de litri consumati): ");
                        int consum = in.nextInt();
                        in.nextLine();
                        System.out.println("Introduceti data de inceput a cursei in format AN-LUNA-ZI: ");
                        String data_inceput = in.nextLine();

                        System.out.println("Introduceti data de final a cursei in format AN-LUNA-ZI: ");
                        String data_final = in.nextLine();

                        CallableStatement adaugaCursa = c.prepareCall("call InserareCursa(?,?,?,?,?,?,?)");

                        adaugaCursa.setString(1, nume);
                        adaugaCursa.setString(2, prenume);
                        adaugaCursa.setString(3, nr_inmatriculare);
                        adaugaCursa.setInt(4, nrKm);
                        adaugaCursa.setInt(5, consum);
                        adaugaCursa.setString(6, data_inceput);
                        adaugaCursa.setString(7, data_final);
                        adaugaCursa.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;
                case 2:
                    try {
                        System.out.println("Introduceti tipul incidentului:amenda,reparatie,accident sau dauna totala: ");
                        Scanner in = new Scanner(System.in);
                        String tip = in.nextLine();

                        System.out.println("Introduceti data incidentului in format AN-LUNA-ZI: ");
                        String data = in.nextLine();

                        System.out.println("Introduceti NUMARUL DE INMATRICULARE: ");
                        String nr_inmatriculare = in.nextLine();

                        System.out.println("Introduceti descrierea incidentului: ");
                        String descriere = in.nextLine();

                        System.out.println("Introduceti daca masina necesita reparatii(1 pentru true 0 pentru false): ");
                        String nec_rep = in.nextLine();

                        CallableStatement adaugaIncident = c.prepareCall("call InserareIncident(?,?,?,?,?,?,?)");

                        adaugaIncident.setString(1, tip);
                        adaugaIncident.setString(2, data);
                        adaugaIncident.setString(3, nume);
                        adaugaIncident.setString(4, prenume);
                        adaugaIncident.setString(5, nr_inmatriculare);
                        adaugaIncident.setString(6, descriere);
                        adaugaIncident.setString(7, nec_rep);
                        adaugaIncident.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 3:
                    try {Scanner in = new Scanner(System.in);
                        System.out.println("Introduceti NUMARUL DE INMATRICULARE: ");
                        String nr_inmatriculare = in.nextLine();

                        System.out.println("Introduceti data alimentarii in format AN-LUNA-ZI: ");
                        String data = in.nextLine();

                        System.out.println("Introduceti nume benzinarie: ");
                        String nume_benzinarie = in.nextLine();

                        CallableStatement adaugaAlimentare = c.prepareCall("call AlimentareMasina(?,?,?,?,?)");

                        adaugaAlimentare.setString(1, nr_inmatriculare );
                        adaugaAlimentare.setString(2, data);
                        adaugaAlimentare.setString(3, nume);
                        adaugaAlimentare.setString(4, prenume);
                        adaugaAlimentare.setString(5, nume_benzinarie);
                        adaugaAlimentare.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;






                case 4: repeatLoop = false;
            }

        }
    }

    public void executeSelectionAdmin(Connection c) throws SQLException {
        boolean repeatLoop=true;
        while(repeatLoop) {
            int selection = createMenuAdmin();
            switch (selection) {
                case 1:
                    try {
                        System.out.println("Introduceti NUMARUL DE INMATRICULARE: ");
                        Scanner in = new Scanner(System.in);
                        String nr_inmatriculare = in.nextLine();

                        CallableStatement stergeMasina = c.prepareCall("call DeleteMasina(?)");

                        stergeMasina.setString(1,nr_inmatriculare);
                        stergeMasina.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;
                case 2:
                    try {
                        System.out.println("Introduceti numele soferului: ");
                        Scanner in = new Scanner(System.in);
                        String nume = in.nextLine();

                        System.out.println("Introduceti prenumele soferului: ");
                        String prenume = in.nextLine();

                        CallableStatement stergeSofer = c.prepareCall("call DeleteSofer(?,?)");

                        stergeSofer.setString(1, nume);
                        stergeSofer.setString(2, prenume);
                        stergeSofer.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 3:
                    try {Scanner in = new Scanner(System.in);
                        System.out.println("Introduceti tipul carburantului(benzina,motorina,GPL): ");
                        String tip = in.nextLine();

                        System.out.println("Introduceti noul pret pentru carburantul ales: ");
                        double pret = in.nextDouble();

                        CallableStatement UpdatePretCarburant = c.prepareCall("call UpdatePretCarburant(?,?)");

                        UpdatePretCarburant.setString(1, tip);
                        UpdatePretCarburant.setDouble(2, pret);
                        UpdatePretCarburant.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 4:
                    try {Scanner in = new Scanner(System.in);
                        System.out.println("Introduceti NUMARUL DE INMATRICULARE: ");
                        String nr_inmatriculare = in.nextLine();

                        System.out.println("Introduceti marca masinii: ");
                        String marca = in.nextLine();

                        System.out.println("Introduceti anul fabricatiei: ");
                        String an_fabr = in.nextLine();

                        System.out.println("Introduceti id-ul carburantului: ");
                        int id_carb = in.nextInt();

                        System.out.println("Introduceti kilometrajul masinii: ");
                        int km = in.nextInt();

                        System.out.println("Introduceti cantitatea rezervorului: ");
                        int cant_rez = in.nextInt();

                        CallableStatement adaugaMasina = c.prepareCall("call InserareMasina(?,?,?,?,?,?)");

                        adaugaMasina.setString(1,nr_inmatriculare );
                        adaugaMasina.setString(2, marca);
                        adaugaMasina.setString(3, an_fabr);
                        adaugaMasina.setInt(4, id_carb);
                        adaugaMasina.setInt(5, km);
                        adaugaMasina.setInt(6, cant_rez);
                        adaugaMasina.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 5:
                    try {Scanner in = new Scanner(System.in);
                        System.out.println("Introduceti numele soferului: ");
                        String nume = in.nextLine();

                        System.out.println("Introduceti prenumele soferului: ");
                        String prenume = in.nextLine();

                        System.out.println("Introduceti parola pentru noul cont: ");
                        String pass=in.nextLine();

                        CallableStatement adaugaSofer = c.prepareCall("call InserareSofer(?,?,?)");

                        adaugaSofer.setString(1,nume );
                        adaugaSofer.setString(2, prenume);
                        adaugaSofer.setString(3,pass);
                        adaugaSofer.execute();
                    } catch (Exception e) {
                        System.out.print("Date incorecte");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 6:
                    try {
                        CallableStatement raport_consum_mediu_masini = c.prepareCall("call raport_consum_mediu_masini()");
                        ResultSet rez = raport_consum_mediu_masini.executeQuery();
                        String coloane = "Numar inmatriculare,An fabricatie,Consum mediu (litri /100 km)\n";

                        try {
                            FileWriter myWriter = new FileWriter("raport_consum_masini"+".csv");
                            myWriter.write(coloane);
                            while(rez.next()){
                                myWriter.write(rez.getString(1)+","+
                                        rez.getInt(2)+","+
                                        rez.getBigDecimal(3)+"\n"
                                        );

                            }
                            myWriter.close();
                            System.out.println("Successfully wrote to the file.");

                        } catch (IOException e) {
                            System.out.println("An error occurred.");
                            e.printStackTrace();
                        }



                    } catch (Exception e) {
                        System.out.print("Generare raport nereusita");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 7:
                    try {
                        CallableStatement raport_consum_sofer = c.prepareCall("call raport_consum_sofer()");
                        ResultSet rez = raport_consum_sofer.executeQuery();
                        String coloane = "numar_inmatriculare,an_fabricatie ,data_inceput ,data_final,nume_sofer," +
                                "prenume_sofer,consum_mediu\n";

                        try {
                            FileWriter myWriter = new FileWriter("raport_consum_sofer"+".csv");
                            myWriter.write(coloane);
                            while(rez.next()){
                                myWriter.write(rez.getString(1)+","+
                                        rez.getInt(2)+","+
                                        rez.getDate(3)+ ","+
                                        rez.getDate(4)+","+
                                        rez.getString(5)+","+
                                        rez.getString(6)+","+
                                        rez.getBigDecimal(7)+","+
                                        "\n"
                                );

                            }
                            myWriter.close();
                            System.out.println("Successfully wrote to the file.");

                        } catch (IOException e) {
                            System.out.println("An error occurred.");
                            e.printStackTrace();
                        }



                    } catch (Exception e) {
                        System.out.print("Generare raport nereusita");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 8:
                    try {
                        CallableStatement raport_accidente = c.prepareCall("call raport_accidente()");
                        ResultSet rez = raport_accidente.executeQuery();
                        String coloane = "sofer_nume,sofer_prenume,numar accidente\n";

                        try {
                            FileWriter myWriter = new FileWriter("raport_accidente"+".csv");
                            myWriter.write(coloane);
                            while(rez.next()){
                                myWriter.write(rez.getString(1)+","+
                                        rez.getString(2)+","+
                                        rez.getInt(3)+","+
                                        "\n"
                                );

                            }
                            myWriter.close();
                            System.out.println("Successfully wrote to the file.");

                        } catch (IOException e) {
                            System.out.println("An error occurred.");
                            e.printStackTrace();
                        }



                    } catch (Exception e) {
                        System.out.print("Generare raport nereusita");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 9:
                    try {
                        Scanner in = new Scanner(System.in);
                        System.out.println("Introduceti interogarea dorita:");
                        String comanda = in.nextLine();

                        Statement s = c.createStatement();
                        ResultSet rez = s.executeQuery(comanda);

                        ResultSetMetaData data = rez.getMetaData();
                        int nrColoane = data.getColumnCount();
                        int[] spatiere = new int[nrColoane];
                        for(int i=0;i<nrColoane;i++){
                            System.out.printf("%s ; ",data.getColumnLabel(i+1).toUpperCase());
                            spatiere[i]=data.getColumnLabel(i+1).length();
                        }

                        System.out.println("\n");

                        while (rez.next()){
                            for(int i=0;i<nrColoane;i++){
                                String format = "%-"+spatiere[i]+"s ; ";
                                System.out.printf(format,rez.getString(i+1));
                            }
                            System.out.println();
                        }

                        System.out.println("\n");

                    } catch (Exception e) {
                        System.out.print("Statementul introdus este incorect");
                        if (e.getMessage() != null)
                            System.out.println(": " + e.getMessage());
                    }
                    break;

                case 10: repeatLoop = false;
            }

        }
    }


}
