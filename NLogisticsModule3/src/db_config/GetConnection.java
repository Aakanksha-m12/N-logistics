package db_config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GetConnection {

    /*
     * Connection settings come from the environment so that credentials
     * are never stored in the repository. The fallbacks keep local
     * development working with a default MySQL install.
     */

    private static String env(String key, String fallback) {

        String value = System.getenv(key);

        return (value == null || value.trim().isEmpty())
                ? fallback
                : value.trim();
    }

    public static Connection getConnection() {

        String url = env(
                "NLOGISTICS_DB_URL",
                "jdbc:mysql://localhost:3306/logistics_db");

        String user = env(
                "NLOGISTICS_DB_USER",
                "root");

        String pass = env(
                "NLOGISTICS_DB_PASSWORD",
                "");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(
                    url,
                    user,
                    pass);

        } catch (ClassNotFoundException e) {

            e.printStackTrace();

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
}
