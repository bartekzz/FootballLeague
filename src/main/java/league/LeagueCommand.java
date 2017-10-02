package league;

import database.MySQLDriverSupport;

import java.io.BufferedReader;
import java.io.Console;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;

/**
 * Created by bartek on 2017-10-02.
 */
public class LeagueCommand {

    MySQLDriverSupport mySQLDriverSupport;

    public LeagueCommand() throws MySQLDriverSupport.DatabaseNameMissingException, SQLException, ClassNotFoundException {

        //mySQLDriverSupport.createPlayer("Bartek", "Szkurlat", 1);

        printMenu();
        //prepShowPlayer();
        //prepCreatePlayer();
        //prepUpdatePlayer();
        //prepDeletePlayer();
        //prepPlayerStats();
        //prepShowPostions();
        //prepShowPlayersInPosition();

    }


    private void goToMenu() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("");
        System.out.print("Go back to menu (yes/no)? :");
        String input = null;
        try {
            input = reader.readLine();
            if(input.contains("y")) {
                printMenu();
            } else {
                System.exit(0);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void prepShowPlayers() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {

        mySQLDriverSupport.showPlayers();

        goToMenu();

    }

    public void prepCreatePlayer() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Player's first name : ");
        String fname = null;
        try {
            fname = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.print("Player's last name : ");
        String lname = null;
        try {
            lname = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.print("Player's last position (number 1-4) : ");
        String position;
        int intPosition = 0;
        try {
            position = reader.readLine();
            intPosition = Integer.parseInt(position);
        } catch (IOException e) {
            e.printStackTrace();
        }

        mySQLDriverSupport.createPlayer(fname, lname, intPosition);

        goToMenu();

    }

    public void prepUpdatePlayer() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Player's last name : ");
        String lname = null;
        try {
            lname = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.print("Player's last position (number 1-4) : ");
        String position;
        int intPosition = 0;
        try {
            position = reader.readLine();
            intPosition = Integer.parseInt(position);
        } catch (IOException e) {
            e.printStackTrace();
        }

            mySQLDriverSupport.updatePlayer(lname, intPosition);

            goToMenu();
    }


    public void prepDeletePlayer() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Player's last name : ");
        String lname = null;
        try {
            lname = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

            mySQLDriverSupport.deletePlayer(lname);

            goToMenu();
    }

    private void prepPlayerStats() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Player's last name : ");
        String lname = null;
        try {
            lname = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        mySQLDriverSupport.playerStats(lname);

        goToMenu();
    }

    private void prepShowPostions() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {
        mySQLDriverSupport.showPositions();

        goToMenu();
    }

    private void prepShowPlayersInPosition() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Position (forward, midfielder, defender, goalkeeper) : ");
        String position = null;
        try {
            position = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("PLAYERS in position: " + position);
        mySQLDriverSupport.showPlayersInPosition(position);

        goToMenu();
    }

    private void printMenu() throws SQLException, MySQLDriverSupport.DatabaseNameMissingException, ClassNotFoundException {

        mySQLDriverSupport = new MySQLDriverSupport();

        System.out.println("CRUD");
        System.out.println("1. CREATE - create player");
        System.out.println("2. READ - show players");
        System.out.println("3. UPDATE - update player");
        System.out.println("4. DELETE - delete player");
        System.out.println("SEARCH");
        System.out.println("5. Show player's stats (Tip: Run #2 first - show players)");
        System.out.println("SELECTION");
        System.out.println("6. Show all player positions");
        System.out.println("7. Show players for given position");
        System.out.println("");

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        String number = null;
        int intNumber = 0;
        while (true) {
            System.out.print("Enter number : ");
            try {
                number = reader.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
            intNumber = Integer.parseInt(number);
                if(intNumber > 0 && intNumber < 8) {
                    break;
                } else {
                    System.out.println("You entered invalid number.");
                    continue;
                }
            } catch (NumberFormatException e) {
            //e.printStackTrace();
            System.out.println("Input is not a number, try again");
            }
        }

        if(intNumber == 1) {
            prepCreatePlayer();
        }
        else if(intNumber == 2) {
            prepShowPlayers();
        }
        else if(intNumber == 3) {
            prepUpdatePlayer();
        }
        else if(intNumber == 4) {
            prepDeletePlayer();
        }
        else if(intNumber == 5) {
            prepPlayerStats();
        }
        else if(intNumber == 6) {
            prepShowPostions();
        }
        else if(intNumber == 7) {
            prepShowPlayersInPosition();
        }

    }

    public static void main(String[] args) throws MySQLDriverSupport.DatabaseNameMissingException, SQLException, ClassNotFoundException {
        LeagueCommand leagueCommand = new LeagueCommand();
    }
}
