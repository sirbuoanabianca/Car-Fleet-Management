package main;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Authentication {

    private boolean succAuth;
    private boolean isAdmin;
    private int idSofer;


    public void getUser(PreparedStatement authSt) throws SQLException {
        System.out.println("Introduceti username: ");
        Scanner in1 = new Scanner(System.in);
        String USERNAME = in1.nextLine();

        System.out.println("Introduceti password: ");
        Scanner in2 = new Scanner(System.in);
        String PASS = in2.nextLine();

        authSt.setString(1,USERNAME);
        authSt.setString(2,PASS);

        ResultSet rez=authSt.executeQuery();

            if(rez.next())
            {
                succAuth=true;

                if(rez.getString("tip").equals("admin"))
                    isAdmin=true;
                else
                    isAdmin=false;

                idSofer=rez.getInt("id_sofer");
            }

        else
            succAuth=false;


    }

    public boolean isSuccAuth() {
        return succAuth;
    }

    public int getIdSofer() {
        return idSofer;
    }

    public boolean isAdmin() {
        return isAdmin;
    }
}
