package db_config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Central database connection factory.
 *
 * Connection settings come from environment variables so credentials
 * are never stored in the repository:
 *
 *   NLOGISTICS_DB_URL
 *   NLOGISTICS_DB_USER
 *   NLOGISTICS_DB_PASSWORD
 *
 * The fallbacks keep a default local MySQL install working.
 */
public final class GetConnection {

    private static final Logger LOGGER =
            Logger.getLogger(GetConnection.class.getName());

    private static final String DRIVER =
            "com.mysql.cj.jdbc.Driver";

    private static final int CONNECT_TIMEOUT_MILLIS = 5000;

    private static final int SOCKET_TIMEOUT_MILLIS = 15000;

    private static volatile boolean driverLoaded = false;

    private static volatile boolean warnedAboutDefaults = false;

    private GetConnection() {
    }

    private static String env(String key, String fallback) {

        String value = System.getenv(key);

        return (value == null || value.trim().isEmpty())
                ? fallback
                : value.trim();
    }

    private static synchronized void loadDriver()
            throws SQLException {

        if (driverLoaded) {
            return;
        }

        try {

            Class.forName(DRIVER);
            driverLoaded = true;

        } catch (ClassNotFoundException e) {

            throw new SQLException(
                    "MySQL JDBC driver is missing from the classpath: "
                    + DRIVER,
                    e);
        }
    }

    private static void warnAboutDefaultsIfNeeded() {

        if (warnedAboutDefaults) {
            return;
        }

        warnedAboutDefaults = true;

        if (env("NLOGISTICS_DB_USER", "").isEmpty()) {

            LOGGER.warning(
                    "NLOGISTICS_DB_USER is not set. Falling back to "
                    + "the local development account 'root' with an "
                    + "empty password.");
        }
    }

    private static String redactUrl(String url) {

        if (url == null) {
            return "";
        }

        return url.replaceAll(
                "(?i)(password=)[^&;]*",
                "$1***");
    }

    /**
     * Opens a new connection.
     *
     * Returns null when the connection cannot be established. The
     * failure is logged with its full cause so the server log shows
     * the real reason instead of a silent null.
     */
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

        warnAboutDefaultsIfNeeded();

        try {

            loadDriver();

            Properties properties = new Properties();
            properties.setProperty("user", user);
            properties.setProperty("password", pass);
            properties.setProperty(
                    "connectTimeout",
                    String.valueOf(CONNECT_TIMEOUT_MILLIS));
            properties.setProperty(
                    "socketTimeout",
                    String.valueOf(SOCKET_TIMEOUT_MILLIS));

            return DriverManager.getConnection(url, properties);

        } catch (SQLException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "Database connection failed for user '"
                    + user
                    + "' at "
                    + redactUrl(url)
                    + " (SQLState "
                    + e.getSQLState()
                    + ", error "
                    + e.getErrorCode()
                    + ")",
                    e);

        } catch (RuntimeException e) {

            LOGGER.log(
                    Level.SEVERE,
                    "Unexpected error while opening a database "
                    + "connection for user '"
                    + user
                    + "' at "
                    + redactUrl(url),
                    e);
        }

        return null;
    }
}
