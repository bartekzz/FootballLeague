package database;


import java.sql.*;
import java.util.Properties;

/**
 * Created by bartek on 2017-10-02.
 */

public class MySQLDriverSupport {

    Connection connection;

    public MySQLDriverSupport() throws ClassNotFoundException, SQLException, DatabaseNameMissingException {
        Properties mySQLProps = getMySQLProperties();

        Class.forName(mySQLProps.getProperty("driver"));

        connection = DriverManager.getConnection(mySQLProps.getProperty("url"), mySQLProps);
        System.out.println("Connected to MySQL database");

        /*
        DatabaseMetaData meta = connection.getMetaData();

        System.out.println("JDBC DRIVER VERSION: " + meta.getJDBCMajorVersion());

        System.out.println("---------TYPE SUPPORT---------");
        System.out.println("FORWARD ONLY: " + meta.supportsResultSetType(ResultSet.TYPE_FORWARD_ONLY));
        System.out.println("SENSITIVE: " + meta.supportsResultSetType(ResultSet.TYPE_SCROLL_SENSITIVE));
        System.out.println("INSENITIVE: " + meta.supportsResultSetType(ResultSet.TYPE_SCROLL_INSENSITIVE));

        System.out.println("\n---------CURSOR SUPPORT---------");
        System.out.println("UPDATE-ABLE: " + meta.supportsResultSetConcurrency(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE));
        System.out.println("READ ONLY: " + meta.supportsResultSetConcurrency(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY));

        System.out.println("\n---------HOLD SUPPORT---------");
        System.out.println("CLOSE AT COMMIT: " + meta.supportsResultSetHoldability(ResultSet.CLOSE_CURSORS_AT_COMMIT));
        System.out.println("HOLD OVER COMMIT: " + meta.supportsResultSetHoldability(ResultSet.HOLD_CURSORS_OVER_COMMIT));
        */
    }

    public static class DatabaseNameMissingException extends Exception{
        public DatabaseNameMissingException(String message) {
            super(message);
        }
    }

    //Fill in your database name
    private static final String DATABASE_NAME = "league";

    private static Properties getMySQLProperties() throws DatabaseNameMissingException {
        Properties properties = new Properties();

        properties.setProperty("user", "root");
        properties.setProperty("password", "Bartek82");

        if(DATABASE_NAME.equals("")) {
            throw new DatabaseNameMissingException("Set the DATABASE_NAME variabel first!");
        }
        properties.setProperty("url", "jdbc:mysql://localhost:3306/" + DATABASE_NAME + "?useSSL=false&serverTimezone=UTC");
        properties.setProperty("driver", "com.mysql.jdbc.Driver");

        return properties;
    }

    // CRUD - Read (Prepare Statement)
    public void showPlayers() throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {

            Statement stmt = connection.createStatement();

            String strSelect = "SELECT fname, lname, position.type FROM player JOIN position ON position_id=position.id" +
                    " ORDER BY lname asc;";
            // System.out.println("The SQL query is: " + strSelect);  // Echo For debugging
            rs = stmt.executeQuery(strSelect);

            System.out.println("PLAYERS - name, position");

            // Process result set
            while (rs.next()) {
                String firstName = rs.getString("fname");
                String lastName = rs.getString("lname");
                String position = rs.getString("type");

                System.out.println(firstName + " " + lastName + ", " + position);
            }
        } catch (Exception exc) {
            exc.printStackTrace();
        } finally {
            connection.close();
            rs.close();
        }
    }

    // CRUD - Create (Stored Procedure)
    public void createPlayer(String fname, String lname, int position) throws SQLException {
        String playerStats = "{ call createPlayer(?,?,?) }";
        // Step-3: prepare the callable statement
        CallableStatement cs = connection.prepareCall(playerStats);

        cs.setString(1, fname);
        cs.setString(2, lname);
        cs.setInt(3, position);

        // Step-5: execute the stored procedures: proc3

        cs.execute();

        cs.close();
        connection.close();
    }

    // CRUD - Update (Stored Procedure)
    public void updatePlayer(String lname, int position) throws SQLException {
        String playerStats = "{ call updatePlayer(?,?) }";
        // Step-3: prepare the callable statement
        CallableStatement cs = connection.prepareCall(playerStats);

        cs.setString(1, lname);
        cs.setInt(2, position);

        // Step-5: execute the stored procedures: proc3

        cs.execute();

        cs.close();
        connection.close();
    }

    // CRUD - Delete (Stored Procedure)
    public void deletePlayer(String lname) throws SQLException {
        String deletePlayer = "{ call deletePlayer(?) }";
        // Step-3: prepare the callable statement
        CallableStatement cs = connection.prepareCall(deletePlayer);

        cs.setString(1, lname);

        // Step-5: execute the stored procedures: proc3

        cs.execute();

        cs.close();
        connection.close();
    }


    // Sökfunction via PS
    public void playerStats(String playerName) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {

            Statement stmt = connection.createStatement();

            String strSelect = "SELECT fname, lname, COUNT(gtime) as goals, team.name as team"
                    + " FROM player"
                    + " JOIN goal ON player.id=goal.player_id"
                    + " JOIN transfer ON player.id=transfer.player_id"
                    + " JOIN team ON team.id=transfer.team_id"
                    + " WHERE fname LIKE ('%" + playerName + "%') OR lname LIKE ('%" + playerName + "%')"
                    + " GROUP BY fname, lname, team.name";
            // System.out.println("The SQL query is: " + strSelect);  // Echo For debugging
            rs = stmt.executeQuery(strSelect);

            // Process result set
            while (rs.next()) {
                String firstName = rs.getString("fname");
                String lastName = rs.getString("lname");
                String team = rs.getString("team");
                int goals = rs.getInt("goals");

                System.out.println(firstName + " " + lastName + ", " + team + ", " + goals);
            }
        } catch (Exception exc) {
            exc.printStackTrace();
        } finally {
            connection.close();
            rs.close();
        }
    }

    // Urval via PS - steg 1
    public void showPositions() throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {

            Statement stmt = connection.createStatement();

            String strSelect = "SELECT id, type as positions FROM position ORDER BY id asc";

            // System.out.println("The SQL query is: " + strSelect);  // Echo For debugging
            rs = stmt.executeQuery(strSelect);

            // Process result set
            while (rs.next()) {
                int id = rs.getInt("id");
                String positions = rs.getString("positions");

                System.out.println(id + ". " + positions);
            }
        } catch (Exception exc) {
            exc.printStackTrace();
        } finally {
            connection.close();
            rs.close();
        }
    }

    // Urval via PS - steg 2
    public void showPlayersInPosition(String position) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {

            Statement stmt = connection.createStatement();

            String strSelect = "SELECT fname, lname, position.type as position FROM player"
            + " JOIN position ON player.position_id=position.id"
            + " WHERE position.type LIKE ('" + position + "')"
            + " ORDER BY lname asc";

            // System.out.println("The SQL query is: " + strSelect);  // Echo For debugging
            rs = stmt.executeQuery(strSelect);

            // Process result set
            while (rs.next()) {
                String firstName = rs.getString("fname");
                String lastName = rs.getString("lname");
                String positioned = rs.getString("position");

                System.out.println(firstName + " " + lastName + ", " + positioned);
            }
        } catch (Exception exc) {
            exc.printStackTrace();
        } finally {
            connection.close();
            rs.close();
        }
    }










    /*public void showPlayers() throws SQLException {
        String showPlayers = "{ call showPlayers(?,?) }";
        // Step-3: prepare the callable statement
        CallableStatement cs = connection.prepareCall(showPlayers);
        // Step-4: register output parameters ...
        cs.registerOutParameter(1, Types.VARCHAR);
        // Step-5: execute the stored procedures: proc3
        cs.execute();
        // Step-6: extract the output parameters
        String param1 = cs.getString(1);
        System.out.println("param1=" + param1);
    }

    public void playerStats() throws SQLException {
        String playerStats = "{ call playerStats(?,?,?,?,?) }";
        // Step-3: prepare the callable statement
        CallableStatement cs = connection.prepareCall(playerStats);

        cs.setString(1, "Messi");
        // Step-4: register output parameters ...
        cs.registerOutParameter(2, Types.VARCHAR);
        cs.registerOutParameter(3, Types.VARCHAR);
        cs.registerOutParameter(4, Types.INTEGER);
        cs.registerOutParameter(5, Types.VARCHAR);
        // Step-5: execute the stored procedures: proc3

        boolean results = cs.execute();
        System.out.println("Result: " + results);
        while (results) {
            ResultSet rs = cs.getResultSet();
            System.out.println(rs);
            while (rs.next()) {
                System.out.println("fname=" + rs.getString("fname"));
                System.out.println("lname=" + rs.getString("lname"));
                System.out.println("goals=" + rs.getInt("goals"));
                System.out.println("team=" + rs.getString("team"));
            }
            rs.close();
            results = cs.getMoreResults();
        }
        cs.close();
    }
    */


    public static void main(String[] args)  {

    }

}