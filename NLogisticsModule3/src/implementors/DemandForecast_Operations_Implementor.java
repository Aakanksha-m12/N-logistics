
package implementors;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.DemandForecast;
import operations.DemandForecastOperations;

public class DemandForecast_Operations_Implementor
        implements DemandForecastOperations {

    /*
     * ============================================================
     * ADD DEMAND FORECAST
     * ============================================================
     */

    @Override
    public void add(DemandForecast forecast) {

        if (forecast == null) {
            throw new IllegalArgumentException(
                    "Demand forecast is required."
            );
        }

        if (forecast.getContainerType() == null
                || forecast.getContainerType().trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required."
            );
        }

        if (forecast.getRouteId() == null) {

            throw new IllegalArgumentException(
                    "Route ID is required."
            );
        }

        if (forecast.getForecastPeriod() == null) {

            throw new IllegalArgumentException(
                    "Forecast period is required."
            );
        }

        if (forecast.getForecastedDemand() == null) {

            throw new IllegalArgumentException(
                    "Forecasted demand is required."
            );
        }

        if (forecast.getForecastedPrice() == null) {

            throw new IllegalArgumentException(
                    "Forecasted price is required."
            );
        }

        if (forecast.getAlgorithmVersion() == null
                || forecast.getAlgorithmVersion().trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Algorithm version is required."
            );
        }

        if (forecast.getForecastedDemand() < 0) {

            throw new IllegalArgumentException(
                    "Forecasted demand cannot be negative."
            );
        }

        if (forecast.getForecastedPrice() < 0) {

            throw new IllegalArgumentException(
                    "Forecasted price cannot be negative."
            );
        }

        String sql =
                "INSERT INTO demand_forecast "
                + "(container_type, route_id, forecast_period, "
                + "forecasted_demand, forecasted_price, "
                + "algorithm_version) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = GetConnection.getConnection();

            if (con == null) {
                throw new RuntimeException(
                        "Database connection failed."
                );
            }

            ps = con.prepareStatement(sql);

            ps.setString(
                    1,
                    forecast.getContainerType().trim()
            );

            ps.setLong(
                    2,
                    forecast.getRouteId()
            );

            ps.setDate(
                    3,
                    forecast.getForecastPeriod()
            );

            ps.setInt(
                    4,
                    forecast.getForecastedDemand()
            );

            ps.setDouble(
                    5,
                    forecast.getForecastedPrice()
            );

            ps.setString(
                    6,
                    forecast.getAlgorithmVersion().trim()
            );

            ps.executeUpdate();

        } catch (Exception e) {

            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }

            throw new RuntimeException(
                    "Error while adding demand forecast.",
                    e
            );

        } finally {

            close(ps);
            close(con);
        }
    }


    /*
     * ============================================================
     * GENERATE FORECAST FOR ONE FUTURE PERIOD
     * ============================================================
     *
     * The forecasting service supplies:
     *
     *     forecastedDemand
     *     demandMultiplier
     *     algorithmVersion
     *
     * The database procedure then:
     *
     *     1. Validates the values.
     *     2. Finds the valid pricing rule.
     *     3. Calculates forecasted price.
     *     4. Inserts the forecast.
     *
     * The database session variables are connection-specific,
     * therefore they MUST be set using the same Connection that
     * calls generate_demand_forecast().
     */

    @Override
    public void generateForecast(
            String containerType,
            Long routeId,
            Date forecastPeriod,
            Integer forecastedDemand,
            Double demandMultiplier,
            String algorithmVersion) {

        if (containerType == null
                || containerType.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required."
            );
        }

        if (routeId == null || routeId <= 0) {

            throw new IllegalArgumentException(
                    "Route ID must be positive."
            );
        }

        if (forecastPeriod == null) {

            throw new IllegalArgumentException(
                    "Forecast period is required."
            );
        }

        if (forecastPeriod.compareTo(
                new Date(System.currentTimeMillis())) <= 0) {

            throw new IllegalArgumentException(
                    "Forecast period must be a future date."
            );
        }

        if (forecastedDemand == null
                || forecastedDemand < 0) {

            throw new IllegalArgumentException(
                    "Forecasted demand cannot be negative."
            );
        }

        if (demandMultiplier == null
                || demandMultiplier <= 0) {

            throw new IllegalArgumentException(
                    "Demand multiplier must be greater than zero."
            );
        }

        if (algorithmVersion == null
                || algorithmVersion.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Algorithm version is required."
            );
        }

        Connection con = null;
        PreparedStatement ps = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {

            con = GetConnection.getConnection();

            if (con == null) {

                throw new RuntimeException(
                        "Database connection failed."
                );
            }

            /*
             * IMPORTANT:
             *
             * These variables are MySQL session variables.
             *
             * They must be set on THIS SAME connection before
             * calling generate_demand_forecast().
             */

            ps = con.prepareStatement(
                    "SET @forecasted_demand = ?, "
                    + "@demand_multiplier = ?, "
                    + "@algorithm_version = ?, "
                    + "@pricing_surcharge = ?"
            );

            ps.setInt(
                    1,
                    forecastedDemand
            );

            ps.setDouble(
                    2,
                    demandMultiplier
            );

            ps.setString(
                    3,
                    algorithmVersion.trim()
            );

            ps.setDouble(
                    4,
                    getConfiguredSurcharge()
            );

            ps.executeUpdate();

            close(ps);
            ps = null;


            /*
             * Call the existing Module 3 database procedure.
             */

            cs = con.prepareCall(
                    "{CALL generate_demand_forecast(?, ?, ?)}"
            );

            cs.setString(
                    1,
                    containerType.trim()
            );

            cs.setLong(
                    2,
                    routeId
            );

            cs.setDate(
                    3,
                    forecastPeriod
            );

            cs.execute();

            /*
             * The procedure returns a result set containing:
             *
             * forecast_id
             * container_type
             * route_id
             * forecast_period
             * forecasted_demand
             * forecasted_price
             * algorithm_version
             * generated_at
             * message
             *
             * We don't need to return anything from this method,
             * so simply consume the result if JDBC exposes it.
             */

            rs = cs.getResultSet();

            if (rs != null) {

                while (rs.next()) {
                    // Result consumed intentionally.
                }
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while generating demand forecast.",
                    e
            );

        } finally {

            close(rs);
            close(cs);
            close(ps);
            close(con);
        }
    }


    /*
     * ============================================================
     * SHOW ALL DEMAND FORECASTS
     * ============================================================
     */

    @Override
    public List<DemandForecast> showAll() {

        List<DemandForecast> list =
                new ArrayList<DemandForecast>();

        String sql =
                "SELECT forecast_id, "
                + "container_type, "
                + "route_id, "
                + "forecast_period, "
                + "forecasted_demand, "
                + "forecasted_price, "
                + "algorithm_version, "
                + "generated_at "
                + "FROM demand_forecast "
                + "ORDER BY forecast_period ASC";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = GetConnection.getConnection();

            if (con == null) {

                throw new RuntimeException(
                        "Database connection failed."
                );
            }

            ps = con.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {

                list.add(
                        mapForecast(rs)
                );
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while displaying demand forecasts.",
                    e
            );

        } finally {

            close(rs);
            close(ps);
            close(con);
        }

        return list;
    }


    /*
     * ============================================================
     * SHOW BY COMPANY
     * ============================================================
     *
     * demand_forecast does not contain company_id.
     *
     * Therefore we do not invent company filtering.
     */

    @Override
    public List<DemandForecast> showByCompany(
            Long companyId) {

        if (companyId == null) {

            return new ArrayList<DemandForecast>();
        }

        return showAll();
    }


    /*
     * ============================================================
     * GET NEXT FORECAST PERIODS
     * ============================================================
     */

    @Override
    public List<DemandForecast> getNextPeriods(
            String containerType,
            Long routeId,
            int numberOfPeriods) {

        List<DemandForecast> list =
                new ArrayList<DemandForecast>();

        if (containerType == null
                || containerType.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required."
            );
        }

        if (routeId == null) {

            throw new IllegalArgumentException(
                    "Route ID is required."
            );
        }

        if (numberOfPeriods <= 0) {

            return list;
        }

        if (numberOfPeriods > 100) {

            numberOfPeriods = 100;
        }

        String sql =
                "SELECT forecast_id, "
                + "container_type, "
                + "route_id, "
                + "forecast_period, "
                + "forecasted_demand, "
                + "forecasted_price, "
                + "algorithm_version, "
                + "generated_at "
                + "FROM demand_forecast "
                + "WHERE container_type = ? "
                + "AND route_id = ? "
                + "AND forecast_period >= CURDATE() "
                + "ORDER BY forecast_period ASC "
                + "LIMIT ?";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = GetConnection.getConnection();

            if (con == null) {

                throw new RuntimeException(
                        "Database connection failed."
                );
            }

            ps = con.prepareStatement(sql);

            ps.setString(
                    1,
                    containerType.trim()
            );

            ps.setLong(
                    2,
                    routeId
            );

            ps.setInt(
                    3,
                    numberOfPeriods
            );

            rs = ps.executeQuery();

            while (rs.next()) {

                list.add(
                        mapForecast(rs)
                );
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while getting forecast periods.",
                    e
            );

        } finally {

            close(rs);
            close(ps);
            close(con);
        }

        return list;
    }


    /*
     * ============================================================
     * GET PRICE TREND
     * ============================================================
     *
     * Uses the existing database procedure:
     *
     *     get_price_trend(...)
     */

    @Override
    public List<DemandForecast> getPriceTrend(
            String containerType,
            Long routeId,
            int numberOfPeriods) {

        List<DemandForecast> list =
                new ArrayList<DemandForecast>();

        if (containerType == null
                || containerType.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required."
            );
        }

        if (routeId == null) {

            throw new IllegalArgumentException(
                    "Route ID is required."
            );
        }

        if (numberOfPeriods <= 0) {

            numberOfPeriods = 6;
        }

        if (numberOfPeriods > 24) {

            numberOfPeriods = 24;
        }

        Connection con = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {

            con = GetConnection.getConnection();

            if (con == null) {

                throw new RuntimeException(
                        "Database connection failed."
                );
            }

            cs = con.prepareCall(
                    "{CALL get_price_trend(?, ?, ?)}"
            );

            cs.setString(
                    1,
                    containerType.trim()
            );

            cs.setLong(
                    2,
                    routeId
            );

            cs.setInt(
                    3,
                    numberOfPeriods
            );

            rs = cs.executeQuery();

            while (rs.next()) {

                DemandForecast forecast =
                        new DemandForecast();

                forecast.setContainerType(
                        containerType.trim()
                );

                forecast.setRouteId(
                        routeId
                );

                forecast.setForecastPeriod(
                        rs.getDate(
                                "forecast_period"
                        )
                );

                forecast.setForecastedDemand(
                        rs.getInt(
                                "forecasted_demand"
                        )
                );

                forecast.setForecastedPrice(
                        rs.getDouble(
                                "forecasted_price"
                        )
                );

                forecast.setAlgorithmVersion(
                        rs.getString(
                                "algorithm_version"
                        )
                );

                forecast.setGeneratedAt(
                        rs.getTimestamp(
                                "generated_at"
                        )
                );

                list.add(forecast);
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while getting price trend.",
                    e
            );

        } finally {

            close(rs);
            close(cs);
            close(con);
        }

        return list;
    }


    /*
     * ============================================================
     * MAP DATABASE RESULT
     * ============================================================
     */

    private DemandForecast mapForecast(
            ResultSet rs)
            throws Exception {

        DemandForecast forecast =
                new DemandForecast();

        forecast.setForecastId(
                rs.getLong(
                        "forecast_id"
                )
        );

        forecast.setContainerType(
                rs.getString(
                        "container_type"
                )
        );

        forecast.setRouteId(
                rs.getLong(
                        "route_id"
                )
        );

        forecast.setForecastPeriod(
                rs.getDate(
                        "forecast_period"
                )
        );

        forecast.setForecastedDemand(
                rs.getInt(
                        "forecasted_demand"
                )
        );

        forecast.setForecastedPrice(
                rs.getDouble(
                        "forecasted_price"
                )
        );

        forecast.setAlgorithmVersion(
                rs.getString(
                        "algorithm_version"
                )
        );

        forecast.setGeneratedAt(
                rs.getTimestamp(
                        "generated_at"
                )
        );

        return forecast;
    }


    /*
     * ============================================================
     * CLOSE RESULT SET
     * ============================================================
     */

    private void close(
            ResultSet rs) {

        if (rs != null) {

            try {
                rs.close();
            } catch (Exception e) {
                // Ignore closing error
            }
        }
    }


    /*
     * ============================================================
     * CLOSE PREPARED STATEMENT
     * ============================================================
     */

    private void close(
            PreparedStatement ps) {

        if (ps != null) {

            try {
                ps.close();
            } catch (Exception e) {
                // Ignore closing error
            }
        }
    }


    /*
     * ============================================================
     * CLOSE CALLABLE STATEMENT
     * ============================================================
     */

    private void close(
            CallableStatement cs) {

        if (cs != null) {

            try {
                cs.close();
            } catch (Exception e) {
                // Ignore closing error
            }
        }
    }


    /*
     * ============================================================
     * CLOSE CONNECTION
     * ============================================================
     */

    private double getConfiguredSurcharge() {

        String value =
                System.getProperty(
                        "nlogistics.pricing.surcharge",
                        "0.00"
                );

        try {

            double surcharge =
                    Double.parseDouble(value);

            if (surcharge < 0) {

                throw new IllegalArgumentException(
                        "Configured surcharge cannot be negative."
                );
            }

            return Math.round(
                    surcharge * 100.0
            ) / 100.0;

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Configured surcharge must be a valid number."
            );
        }
    }

    private void close(
            Connection con) {

        if (con != null) {

            try {
                con.close();
            } catch (Exception e) {
                // Ignore closing error
            }
        }
    }
}

