package main;

import java.sql.*;
import java.util.Scanner;

public class Main {
	private final static String URL = "jdbc:mysql://localhost:3306/";
	private final static String DB_NAME = "parc_auto";
	private final static String USER = "administrator";
	private final static String PASSWORD = "5678";
	private static Authentication auth;
	private static Menu menu;

	

	public static void main(String[] args) {
		Connection c;
		
		try {

			c=DriverManager.getConnection(URL+DB_NAME, USER, PASSWORD);

			PreparedStatement authSt= c.prepareStatement("select * from conturi WHERE user_name=? AND user_pass=?");
			auth=new Authentication();

			while (true){
				do {
					auth.getUser(authSt);
					if (!auth.isSuccAuth())
						System.out.println("\nAUTENTIFICARE NEREUSITA:introduceti din nou");
				} while (!auth.isSuccAuth());


				menu = new Menu();
				if (!auth.isAdmin()) //userul este SOFER
					menu.executeSelectionSofer(c, auth.getIdSofer());
				else
					menu.executeSelectionAdmin(c);    //userul este ADMIN
			}
			
		}
		
		catch (Exception e) {
			System.out.println("SQLException: " + e.getMessage());
		    System.out.println("SQLState: " + ((SQLException) e).getSQLState());
		    System.out.println("VendorError: " + ((SQLException) e).getErrorCode());
		}
		
		

	}

}
