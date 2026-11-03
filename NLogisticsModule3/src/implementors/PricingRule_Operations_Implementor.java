
package implementors;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.PricingRule;
import operations.PricingRuleOperations;

public class PricingRule_Operations_Implementor
        implements PricingRuleOperations {

    /*
     * ============================================================
     * ADD PRICING RULE
     * ============================================================
     */

    @Override
    public void add(PricingRule pricingRule) {

        validatePricingRule(pricingRule);

        double surcharge = getConfiguredSurcharge();

        double finalPrice = calculatePrice(
                pricingRule.getBasePrice(),
                pricingRule.getSeasonalMultiplier(),
                pricingRule.getDemandMultiplier(),
                surcharge
        );

        String sql =
                "INSERT INTO pricing_rules "
                + "(container_type, container_size, route_id, "
                + "base_price, seasonal_multiplier, "
                + "demand_multiplier, final_price, "
                + "valid_from, valid_to) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet keys = null;

        try {

            con = GetConnection.getConnection();

            if (con == null) {
                throw new RuntimeException(
                        "Database connection failed."
                );
            }

            ps = con.prepareStatement(
                    sql,
                    java.sql.Statement.RETURN_GENERATED_KEYS
            );

            setSurchargeSessionVariable(con);

            ps.setString(
                    1,
                    pricingRule.getContainerType()
            );

            ps.setString(
                    2,
                    pricingRule.getContainerSize()
            );

            ps.setLong(
                    3,
                    pricingRule.getRouteId()
            );

            ps.setDouble(
                    4,
                    pricingRule.getBasePrice()
            );

            ps.setDouble(
                    5,
                    pricingRule.getSeasonalMultiplier()
            );

            ps.setDouble(
                    6,
                    pricingRule.getDemandMultiplier()
            );

            /*
             * Final price is calculated by the server.
             * It is NOT taken from the browser.
             */
            ps.setDouble(
                    7,
                    finalPrice
            );

            ps.setDate(
                    8,
                    pricingRule.getValidFrom()
            );

            ps.setDate(
                    9,
                    pricingRule.getValidTo()
            );

            ps.executeUpdate();

            keys = ps.getGeneratedKeys();

            if (keys.next()) {

                pricingRule.setPricingId(
                        keys.getLong(1)
                );
            }

            pricingRule.setFinalPrice(
                    finalPrice
            );

        } catch (Exception e) {

            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }

            throw new RuntimeException(
                    "Error while adding pricing rule.",
                    e
            );

        } finally {

            close(keys);
            close(ps);
            close(con);
        }
    }


    /*
     * ============================================================
     * UPDATE PRICING RULE
     * ============================================================
     */

    @Override
    public void update(PricingRule pricingRule) {

        validatePricingRule(pricingRule);

        if (pricingRule.getPricingId() == null) {

            throw new IllegalArgumentException(
                    "Pricing ID is required for update."
            );
        }

        /*
         * Calculate the new final price on the server.
         */
        double surcharge = getConfiguredSurcharge();

        double newFinalPrice = calculatePrice(
                pricingRule.getBasePrice(),
                pricingRule.getSeasonalMultiplier(),
                pricingRule.getDemandMultiplier(),
                surcharge
        );

        String sql =
                "UPDATE pricing_rules "
                + "SET container_type = ?, "
                + "container_size = ?, "
                + "route_id = ?, "
                + "base_price = ?, "
                + "seasonal_multiplier = ?, "
                + "demand_multiplier = ?, "
                + "final_price = ?, "
                + "valid_from = ?, "
                + "valid_to = ? "
                + "WHERE pricing_id = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = GetConnection.getConnection();

            if (con == null) {
                throw new RuntimeException(
                        "Database connection failed."
                );
            }

            setSurchargeSessionVariable(con);

            ps = con.prepareStatement(sql);

            ps.setString(
                    1,
                    pricingRule.getContainerType()
            );

            ps.setString(
                    2,
                    pricingRule.getContainerSize()
            );

            ps.setLong(
                    3,
                    pricingRule.getRouteId()
            );

            ps.setDouble(
                    4,
                    pricingRule.getBasePrice()
            );

            ps.setDouble(
                    5,
                    pricingRule.getSeasonalMultiplier()
            );

            ps.setDouble(
                    6,
                    pricingRule.getDemandMultiplier()
            );

            /*
             * Final price is always calculated here.
             */
            ps.setDouble(
                    7,
                    newFinalPrice
            );

            ps.setDate(
                    8,
                    pricingRule.getValidFrom()
            );

            ps.setDate(
                    9,
                    pricingRule.getValidTo()
            );

            /*
             * Existing generated pricing ID.
             */
            ps.setLong(
                    10,
                    pricingRule.getPricingId()
            );

            int rows = ps.executeUpdate();

            if (rows == 0) {

                throw new IllegalArgumentException(
                        "Pricing rule not found."
                );
            }

            /*
             * Put the calculated final price back into
             * the model.
             */
            pricingRule.setFinalPrice(
                    newFinalPrice
            );

        } catch (Exception e) {

            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }

            throw new RuntimeException(
                    "Error while updating pricing rule.",
                    e
            );

        } finally {

            close(ps);
            close(con);
        }
    }


    /*
     * ============================================================
     * SHOW ALL PRICING RULES
     * ============================================================
     *
     * This method returns the complete pricing information.
     *
     * It must ONLY be called after authorization by the
     * controller/security layer.
     *
     * Customer must never call this method.
     */

    @Override
    public List<PricingRule> showAll() {

        List<PricingRule> list =
                new ArrayList<PricingRule>();

        String sql =
                "SELECT pricing_id, "
                + "container_type, "
                + "container_size, "
                + "route_id, "
                + "base_price, "
                + "seasonal_multiplier, "
                + "demand_multiplier, "
                + "final_price, "
                + "valid_from, "
                + "valid_to "
                + "FROM pricing_rules "
                + "ORDER BY pricing_id DESC";

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
                        mapPricingRule(rs)
                );
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while displaying pricing rules.",
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
     * SHOW PRICING RULES BY COMPANY
     * ============================================================
     *
     * IMPORTANT:
     *
     * pricing_rules does NOT contain owner_company_id.
     *
     * Therefore we cannot write a fake:
     *
     * WHERE owner_company_id = ?
     *
     * No database field is invented.
     */

    @Override
    public List<PricingRule> showByCompany(
            Long companyId) {

        if (companyId == null) {

            return new ArrayList<PricingRule>();
        }

        /*
         * There is no company relationship in the
         * pricing_rules table.
         *
         * Authorization is therefore handled before this
         * method is called.
         */
        return showAll();
    }


    /*
     * ============================================================
     * AVAILABLE ROUTE IDS
     * ============================================================
     *
     * The supplied schema has no routes table.
     * Route IDs already used by pricing/forecast records are
     * therefore the only legitimate route choices available to
     * the application.
     */ 

    @Override
    public List<Long> getAvailableRouteIds() {

        List<Long> routeIds =
                new ArrayList<Long>();

        String sql =
                "SELECT route_id FROM pricing_rules "
                + "UNION "
                + "SELECT route_id FROM demand_forecast "
                + "ORDER BY route_id";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                routeIds.add(
                        rs.getLong("route_id")
                );
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while loading route IDs.",
                    e
            );
        }

        return routeIds;
    }


    /*
     * ============================================================
     * FIND PRICING RULE BY ID
     * ============================================================
     */

    @Override
    public PricingRule findById(
            Long pricingId) {

        if (pricingId == null) {

            throw new IllegalArgumentException(
                    "Pricing ID is required."
            );
        }

        String sql =
                "SELECT pricing_id, "
                + "container_type, "
                + "container_size, "
                + "route_id, "
                + "base_price, "
                + "seasonal_multiplier, "
                + "demand_multiplier, "
                + "final_price, "
                + "valid_from, "
                + "valid_to "
                + "FROM pricing_rules "
                + "WHERE pricing_id = ?";

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

            ps.setLong(
                    1,
                    pricingId
            );

            rs = ps.executeQuery();

            if (rs.next()) {

                return mapPricingRule(rs);
            }

            return null;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while finding pricing rule.",
                    e
            );

        } finally {

            close(rs);
            close(ps);
            close(con);
        }
    }


    /*
     * ============================================================
     * CALCULATE FINAL PRICE
     * ============================================================
     *
     * Finds the currently valid pricing rule for:
     *
     * container type
     * container size
     * route
     *
     * The service layer must expose ONLY finalPrice to Customer.
     */

    @Override
    public PricingRule calculateFinalPrice(
            String containerType,
            String containerSize,
            Long routeId) {

        if (containerType == null ||
                containerType.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required."
            );
        }

        if (containerSize == null ||
                containerSize.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container size is required."
            );
        }

        if (routeId == null) {

            throw new IllegalArgumentException(
                    "Route ID is required."
            );
        }

        String sql =
                "SELECT pricing_id, "
                + "container_type, "
                + "container_size, "
                + "route_id, "
                + "base_price, "
                + "seasonal_multiplier, "
                + "demand_multiplier, "
                + "final_price, "
                + "valid_from, "
                + "valid_to "
                + "FROM pricing_rules "
                + "WHERE container_type = ? "
                + "AND container_size = ? "
                + "AND route_id = ? "
                + "AND valid_from <= CURDATE() "
                + "AND valid_to >= CURDATE() "
                + "ORDER BY pricing_id DESC "
                + "LIMIT 1";

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

            ps.setString(
                    2,
                    containerSize.trim()
            );

            ps.setLong(
                    3,
                    routeId
            );

            rs = ps.executeQuery();

            if (rs.next()) {

                return mapPricingRule(rs);
            }

            return null;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while calculating final price.",
                    e
            );

        } finally {

            close(rs);
            close(ps);
            close(con);
        }
    }


    /*
     * ============================================================
     * VALIDATE PRICING RULE
     * ============================================================
     */

    private void validatePricingRule(
            PricingRule pricingRule) {

        if (pricingRule == null) {

            throw new IllegalArgumentException(
                    "Pricing rule is required."
            );
        }

        if (pricingRule.getContainerType() == null ||
                pricingRule.getContainerType()
                        .trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required."
            );
        }

        if (pricingRule.getContainerSize() == null ||
                pricingRule.getContainerSize()
                        .trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container size is required."
            );
        }

        if (pricingRule.getRouteId() == null) {

            throw new IllegalArgumentException(
                    "Route ID is required."
            );
        }

        if (pricingRule.getBasePrice() == null ||
                pricingRule.getBasePrice() < 0) {

            throw new IllegalArgumentException(
                    "Base price cannot be negative."
            );
        }

        if (pricingRule.getSeasonalMultiplier() == null ||
                pricingRule.getSeasonalMultiplier() < 0) {

            throw new IllegalArgumentException(
                    "Seasonal multiplier cannot be negative."
            );
        }

        if (pricingRule.getDemandMultiplier() == null ||
                pricingRule.getDemandMultiplier() < 0) {

            throw new IllegalArgumentException(
                    "Demand multiplier cannot be negative."
            );
        }

        if (pricingRule.getValidFrom() == null) {

            throw new IllegalArgumentException(
                    "Valid-from date is required."
            );
        }

        if (pricingRule.getValidTo() == null) {

            throw new IllegalArgumentException(
                    "Valid-to date is required."
            );
        }

        if (pricingRule.getValidTo()
                .before(pricingRule.getValidFrom())) {

            throw new IllegalArgumentException(
                    "Valid-to date cannot be before valid-from date."
            );
        }
    }


    /*
     * ============================================================
     * CALCULATE FINAL PRICE
     * ============================================================
     *
     * Formula:
     *
     * Final Price =
     * Base Price
     * × Seasonal Multiplier
     * × Demand Multiplier
     * + Configured Surcharge
     *
     * The surcharge is application configuration because the
     * existing database has no surcharge column.
     */

    private double calculatePrice(
            Double basePrice,
            Double seasonalMultiplier,
            Double demandMultiplier,
            double surcharge) {

        double result =
                basePrice
                * seasonalMultiplier
                * demandMultiplier
                + surcharge;

        return Math.round(
                result * 100.0
        ) / 100.0;
    }

    /*
     * Surcharge is application configuration, not a database field.
     *
     * The supplied SRS mentions surcharges but does not specify
     * a numeric surcharge value. Therefore the safe default is 0.00.
     * A deployment can set:
     *
     * -Dnlogistics.pricing.surcharge=VALUE
     *
     * without changing any table or model field.
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

    private void setSurchargeSessionVariable(
            Connection con)
            throws Exception {

        PreparedStatement surchargePs =
                null;

        try {

            surchargePs =
                    con.prepareStatement(
                            "SET @pricing_surcharge = ?"
                    );

            surchargePs.setDouble(
                    1,
                    getConfiguredSurcharge()
            );

            surchargePs.executeUpdate();

        } finally {

            close(surchargePs);
        }
    }


    /*
     * ============================================================
     * MAP DATABASE RESULT TO MODEL
     * ============================================================
     */

    private PricingRule mapPricingRule(
            ResultSet rs)
            throws Exception {

        PricingRule rule =
                new PricingRule();

        rule.setPricingId(
                rs.getLong(
                        "pricing_id")
        );

        rule.setContainerType(
                rs.getString(
                        "container_type")
        );

        rule.setContainerSize(
                rs.getString(
                        "container_size")
        );

        rule.setRouteId(
                rs.getLong(
                        "route_id")
        );

        rule.setBasePrice(
                rs.getDouble(
                        "base_price")
        );

        rule.setSeasonalMultiplier(
                rs.getDouble(
                        "seasonal_multiplier")
        );

        rule.setDemandMultiplier(
                rs.getDouble(
                        "demand_multiplier")
        );

        rule.setFinalPrice(
                rs.getDouble(
                        "final_price")
        );

        rule.setValidFrom(
                rs.getDate(
                        "valid_from")
        );

        rule.setValidTo(
                rs.getDate(
                        "valid_to")
        );

        return rule;
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
     * CLOSE CONNECTION
     * ============================================================
     */

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

