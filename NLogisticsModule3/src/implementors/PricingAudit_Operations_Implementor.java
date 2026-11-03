package implementors;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.PricingAudit;
import operations.PricingAuditOperations;

public class PricingAudit_Operations_Implementor
        implements PricingAuditOperations {


    /*
     * ============================================================
     * ADD PRICING AUDIT
     * ============================================================
     */

    @Override
    public void add(
            PricingAudit audit) {

        if (audit == null) {

            throw new IllegalArgumentException(
                    "Pricing audit is required.");
        }


        if (audit.getPricingId() == null) {

            throw new IllegalArgumentException(
                    "Pricing ID is required.");
        }


        if (audit.getChangedBy() == null) {

            throw new SecurityException(
                    "Authenticated user is required.");
        }


        if (audit.getReason() == null ||
                audit.getReason().trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Audit reason is required.");
        }


        String sql =
                "INSERT INTO pricing_audit "
                + "(pricing_id, old_price, new_price, "
                + "changed_by, reason) "
                + "VALUES (?, ?, ?, ?, ?)";


        Connection con = null;
        PreparedStatement ps = null;


        try {

            con =
                    GetConnection.getConnection();


            if (con == null) {

                throw new RuntimeException(
                        "Database connection failed.");
            }


            ps =
                    con.prepareStatement(
                            sql);


            /*
             * Pricing ID comes from the server-side
             * pricing operation.
             */
            ps.setLong(
                    1,
                    audit.getPricingId());


            /*
             * Old price.
             */
            if (audit.getOldPrice() == null) {

                ps.setNull(
                        2,
                        java.sql.Types.DECIMAL);

            } else {

                ps.setDouble(
                        2,
                        audit.getOldPrice());
            }


            /*
             * New price.
             */
            if (audit.getNewPrice() == null) {

                ps.setNull(
                        3,
                        java.sql.Types.DECIMAL);

            } else {

                ps.setDouble(
                        3,
                        audit.getNewPrice());
            }


            /*
             * IMPORTANT:
             *
             * changedBy is supplied by Module3Service
             * from the authenticated session.
             *
             * It is NOT taken directly from the JSP.
             */
            ps.setLong(
                    4,
                    audit.getChangedBy());


            /*
             * Audit reason.
             */
            ps.setString(
                    5,
                    audit.getReason().trim());


            ps.executeUpdate();


        } catch (Exception e) {

            if (e instanceof RuntimeException) {

                throw (RuntimeException) e;
            }


            throw new RuntimeException(
                    "Error while adding pricing audit.",
                    e);


        } finally {

            close(ps);
            close(con);
        }
    }


    /*
     * ============================================================
     * SHOW ALL AUDITS
     * ============================================================
     *
     * Internal administrative/finance view.
     *
     * Customer must never be authorized to call this.
     */

    @Override
    public List<PricingAudit> showAll() {

        List<PricingAudit> list =
                new ArrayList<PricingAudit>();


        String sql =
                "SELECT audit_id, "
                + "pricing_id, "
                + "old_price, "
                + "new_price, "
                + "changed_by, "
                + "reason, "
                + "changed_at "
                + "FROM pricing_audit "
                + "ORDER BY audit_id DESC";


        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;


        try {

            con =
                    GetConnection.getConnection();


            if (con == null) {

                throw new RuntimeException(
                        "Database connection failed.");
            }


            ps =
                    con.prepareStatement(
                            sql);


            rs =
                    ps.executeQuery();


            while (rs.next()) {

                PricingAudit audit =
                        new PricingAudit();


                audit.setAuditId(
                        rs.getLong(
                                "audit_id"));


                audit.setPricingId(
                        rs.getLong(
                                "pricing_id"));


                /*
                 * Old price.
                 */
                double oldPrice =
                        rs.getDouble(
                                "old_price");


                if (rs.wasNull()) {

                    audit.setOldPrice(
                            null);

                } else {

                    audit.setOldPrice(
                            oldPrice);
                }


                /*
                 * New price.
                 */
                double newPrice =
                        rs.getDouble(
                                "new_price");


                if (rs.wasNull()) {

                    audit.setNewPrice(
                            null);

                } else {

                    audit.setNewPrice(
                            newPrice);
                }


                /*
                 * User who changed the price.
                 */
                audit.setChangedBy(
                        rs.getLong(
                                "changed_by"));


                /*
                 * Reason.
                 */
                audit.setReason(
                        rs.getString(
                                "reason"));


                /*
                 * Database-generated timestamp.
                 */
                audit.setChangedAt(
                        rs.getTimestamp(
                                "changed_at"));


                list.add(
                        audit);
            }


        } catch (Exception e) {

            throw new RuntimeException(
                    "Error while displaying pricing audit.",
                    e);


        } finally {

            close(rs);
            close(ps);
            close(con);
        }


        return list;
    }


    /*
     * ============================================================
     * SHOW AUDITS BY COMPANY
     * ============================================================
     *
     * IMPORTANT:
     *
     * pricing_audit itself does not contain
     * owner_company_id.
     *
     * Therefore we cannot safely claim that:
     *
     *     WHERE owner_company_id = ?
     *
     * exists.
     *
     * We do NOT invent a database column.
     */

    @Override
    public List<PricingAudit> showByCompany(
            Long companyId) {

        if (companyId == null) {

            return new ArrayList<PricingAudit>();
        }


        /*
         * No valid company relationship exists directly
         * in pricing_audit.
         *
         * Therefore this method is not used to claim
         * company-level isolation.
         */
        return showAll();
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