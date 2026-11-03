package implementors;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import db_config.GetConnection;
import model.Container;
import operations.ContainerOperations;

public class Container_Operations_Implementor
        implements ContainerOperations {

    @Override
    public void add(Container container) {

        String sql = "INSERT INTO containers "
                + "(container_number, type, size, image_url, "
                + "tare_weight_kg, max_gross_weight_kg, "
                + "goods_capacity_kg, goods_capacity_cbm, "
                + "status, current_port_id, owner_company_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Available', ?, ?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     sql,
                     PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, container.getContainerNumber());
            ps.setString(2, container.getType());
            ps.setString(3, container.getSize());
            ps.setString(4, container.getImageUrl());

            ps.setDouble(5, container.getTareWeightKg());
            ps.setDouble(6, container.getMaxGrossWeightKg());
            ps.setDouble(7, container.getGoodsCapacityKg());
            ps.setDouble(8, container.getGoodsCapacityCbm());

            if (container.getCurrentPortId() == null) {
                ps.setNull(9, java.sql.Types.BIGINT);
            } else {
                ps.setLong(9, container.getCurrentPortId());
            }

            ps.setLong(10, container.getOwnerCompanyId());

            ps.executeUpdate();

            /*
             * container_id is generated automatically
             * by the database.
             */
            try (ResultSet rs = ps.getGeneratedKeys()) {

                if (rs.next()) {
                    container.setContainerId(rs.getLong(1));
                }
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Unable to add container: "
                            + e.getMessage(), e);
        }
    }


    @Override
    public void update(Container container) {

        String sql = "UPDATE containers SET "
                + "type = ?, "
                + "size = ?, "
                + "image_url = ?, "
                + "tare_weight_kg = ?, "
                + "max_gross_weight_kg = ?, "
                + "goods_capacity_kg = ?, "
                + "goods_capacity_cbm = ?, "
                + "current_port_id = ? "
                + "WHERE container_id = ? "
                + "AND owner_company_id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, container.getType());
            ps.setString(2, container.getSize());
            ps.setString(3, container.getImageUrl());

            ps.setDouble(4, container.getTareWeightKg());
            ps.setDouble(5, container.getMaxGrossWeightKg());
            ps.setDouble(6, container.getGoodsCapacityKg());
            ps.setDouble(7, container.getGoodsCapacityCbm());

            if (container.getCurrentPortId() == null) {
                ps.setNull(8, java.sql.Types.BIGINT);
            } else {
                ps.setLong(8, container.getCurrentPortId());
            }

            ps.setLong(9, container.getContainerId());
            ps.setLong(10, container.getOwnerCompanyId());

            int rows = ps.executeUpdate();

            if (rows == 0) {
                throw new RuntimeException(
                        "Container does not exist "
                                + "or does not belong to this company.");
            }

        } catch (Exception e) {

            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }

            throw new RuntimeException(
                    "Unable to update container: "
                            + e.getMessage(), e);
        }
    }


    @Override
    public void delete(Container container) {

        String sql = "DELETE FROM containers "
                + "WHERE container_id = ? "
                + "AND owner_company_id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, container.getContainerId());
            ps.setLong(2, container.getOwnerCompanyId());

            int rows = ps.executeUpdate();

            if (rows == 0) {

                throw new RuntimeException(
                        "Container cannot be deleted because it does not exist "
                                + "or does not belong to this company.");
            }

        } catch (Exception e) {

            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }

            throw new RuntimeException(
                    "Unable to delete container: "
                            + e.getMessage(), e);
        }
    }


    @Override
    public List<Container> showAll() {

        List<Container> containers =
                new ArrayList<Container>();

        String sql = "SELECT "
                + "container_id, "
                + "container_number, "
                + "type, "
                + "size, "
                + "image_url, "
                + "tare_weight_kg, "
                + "max_gross_weight_kg, "
                + "goods_capacity_kg, "
                + "goods_capacity_cbm, "
                + "status, "
                + "current_port_id, "
                + "owner_company_id "
                + "FROM containers "
                + "ORDER BY owner_company_id ASC, "
                + "container_number ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Container c = new Container();

                c.setContainerId(
                        rs.getLong("container_id"));

                c.setContainerNumber(
                        rs.getString("container_number"));

                c.setType(
                        rs.getString("type"));

                c.setSize(
                        rs.getString("size"));

                c.setImageUrl(
                        rs.getString("image_url"));

                c.setTareWeightKg(
                        rs.getDouble("tare_weight_kg"));

                c.setMaxGrossWeightKg(
                        rs.getDouble("max_gross_weight_kg"));

                c.setGoodsCapacityKg(
                        rs.getDouble("goods_capacity_kg"));

                c.setGoodsCapacityCbm(
                        rs.getDouble("goods_capacity_cbm"));

                c.setStatus(
                        rs.getString("status"));

                long portId =
                        rs.getLong("current_port_id");

                if (rs.wasNull()) {
                    c.setCurrentPortId(null);
                } else {
                    c.setCurrentPortId(portId);
                }

                c.setOwnerCompanyId(
                        rs.getLong("owner_company_id"));

                containers.add(c);
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Unable to retrieve containers: "
                            + e.getMessage(), e);
        }

        return containers;
    }


    @Override
    public List<Container> showByCompany(Long companyId) {

        List<Container> containers =
                new ArrayList<Container>();

        if (companyId == null) {
            return containers;
        }

        String sql = "SELECT "
                + "container_id, "
                + "container_number, "
                + "type, "
                + "size, "
                + "image_url, "
                + "tare_weight_kg, "
                + "max_gross_weight_kg, "
                + "goods_capacity_kg, "
                + "goods_capacity_cbm, "
                + "status, "
                + "current_port_id, "
                + "owner_company_id "
                + "FROM containers "
                + "WHERE owner_company_id = ? "
                + "ORDER BY container_number ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setLong(1, companyId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Container c = new Container();

                    c.setContainerId(
                            rs.getLong("container_id"));

                    c.setContainerNumber(
                            rs.getString("container_number"));

                    c.setType(
                            rs.getString("type"));

                    c.setSize(
                            rs.getString("size"));

                    c.setImageUrl(
                            rs.getString("image_url"));

                    c.setTareWeightKg(
                            rs.getDouble("tare_weight_kg"));

                    c.setMaxGrossWeightKg(
                            rs.getDouble(
                                    "max_gross_weight_kg"));

                    c.setGoodsCapacityKg(
                            rs.getDouble(
                                    "goods_capacity_kg"));

                    c.setGoodsCapacityCbm(
                            rs.getDouble(
                                    "goods_capacity_cbm"));

                    c.setStatus(
                            rs.getString("status"));

                    long portId =
                            rs.getLong("current_port_id");

                    if (rs.wasNull()) {
                        c.setCurrentPortId(null);
                    } else {
                        c.setCurrentPortId(portId);
                    }

                    c.setOwnerCompanyId(
                            rs.getLong("owner_company_id"));

                    containers.add(c);
                }
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Unable to retrieve company containers: "
                            + e.getMessage(), e);
        }

        return containers;
    }


    @Override
    public List<Container> showAvailableByCompany(
            Long companyId) {

        List<Container> containers =
                new ArrayList<Container>();

        if (companyId == null) {
            return containers;
        }

        /*
         * Only safe customer/allocation fields
         * are selected.
         *
         * Sensitive fields are NOT selected:
         * - tare_weight_kg
         * - max_gross_weight_kg
         * - owner_company_id
         */

        String sql = "SELECT "
                + "container_id, "
                + "container_number, "
                + "type, "
                + "size, "
                + "image_url, "
                + "goods_capacity_kg, "
                + "goods_capacity_cbm, "
                + "status, "
                + "current_port_id "
                + "FROM containers "
                + "WHERE owner_company_id = ? "
                + "AND status = 'Available' "
                + "ORDER BY container_number ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setLong(1, companyId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Container c = new Container();

                    c.setContainerId(
                            rs.getLong("container_id"));

                    c.setContainerNumber(
                            rs.getString("container_number"));

                    c.setType(
                            rs.getString("type"));

                    c.setSize(
                            rs.getString("size"));

                    c.setImageUrl(
                            rs.getString("image_url"));

                    c.setGoodsCapacityKg(
                            rs.getDouble(
                                    "goods_capacity_kg"));

                    c.setGoodsCapacityCbm(
                            rs.getDouble(
                                    "goods_capacity_cbm"));

                    c.setStatus(
                            rs.getString("status"));

                    long portId =
                            rs.getLong("current_port_id");

                    if (rs.wasNull()) {
                        c.setCurrentPortId(null);
                    } else {
                        c.setCurrentPortId(portId);
                    }

                    containers.add(c);
                }
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Unable to retrieve available company "
                            + "containers: "
                            + e.getMessage(), e);
        }

        return containers;
    }


    /*
     * ============================================================
     * ALLOCATED CONTAINERS BY COMPANY
     * ============================================================
     *
     * Added because Module3Service uses:
     *
     * showAllocatedByCompany(companyId)
     *
     * This returns only containers whose current status
     * is Allocated and which belong to the specified company.
     */
    public List<Container> showAllocatedByCompany(
            Long companyId) {

        List<Container> containers =
                new ArrayList<Container>();

        if (companyId == null) {
            return containers;
        }

        String sql = "SELECT "
                + "container_id, "
                + "container_number, "
                + "type, "
                + "size, "
                + "image_url, "
                + "tare_weight_kg, "
                + "max_gross_weight_kg, "
                + "goods_capacity_kg, "
                + "goods_capacity_cbm, "
                + "status, "
                + "current_port_id, "
                + "owner_company_id "
                + "FROM containers "
                + "WHERE owner_company_id = ? "
                + "AND status = 'Allocated' "
                + "ORDER BY container_number ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setLong(1, companyId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Container c = new Container();

                    c.setContainerId(
                            rs.getLong("container_id"));

                    c.setContainerNumber(
                            rs.getString("container_number"));

                    c.setType(
                            rs.getString("type"));

                    c.setSize(
                            rs.getString("size"));

                    c.setImageUrl(
                            rs.getString("image_url"));

                    c.setTareWeightKg(
                            rs.getDouble("tare_weight_kg"));

                    c.setMaxGrossWeightKg(
                            rs.getDouble(
                                    "max_gross_weight_kg"));

                    c.setGoodsCapacityKg(
                            rs.getDouble(
                                    "goods_capacity_kg"));

                    c.setGoodsCapacityCbm(
                            rs.getDouble(
                                    "goods_capacity_cbm"));

                    c.setStatus(
                            rs.getString("status"));

                    long portId =
                            rs.getLong("current_port_id");

                    if (rs.wasNull()) {
                        c.setCurrentPortId(null);
                    } else {
                        c.setCurrentPortId(portId);
                    }

                    c.setOwnerCompanyId(
                            rs.getLong("owner_company_id"));

                    containers.add(c);
                }
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Unable to retrieve allocated company "
                            + "containers: "
                            + e.getMessage(), e);
        }

        return containers;
    }


    @Override
    public List<Container> showAvailable() {

        List<Container> containers =
                new ArrayList<Container>();

        /*
         * Safe allocation/customer view.
         *
         * Sensitive administrative fields such as
         * tare weight and owner company are not selected.
         */

        String sql = "SELECT "
                + "container_id, "
                + "container_number, "
                + "type, "
                + "size, "
                + "image_url, "
                + "goods_capacity_kg, "
                + "goods_capacity_cbm, "
                + "status, "
                + "current_port_id "
                + "FROM containers "
                + "WHERE status = 'Available' "
                + "ORDER BY container_number ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Container c = new Container();

                c.setContainerId(
                        rs.getLong("container_id"));

                c.setContainerNumber(
                        rs.getString("container_number"));

                c.setType(
                        rs.getString("type"));

                c.setSize(
                        rs.getString("size"));

                c.setImageUrl(
                        rs.getString("image_url"));

                c.setGoodsCapacityKg(
                        rs.getDouble(
                                "goods_capacity_kg"));

                c.setGoodsCapacityCbm(
                        rs.getDouble(
                                "goods_capacity_cbm"));

                c.setStatus(
                        rs.getString("status"));

                long portId =
                        rs.getLong("current_port_id");

                if (rs.wasNull()) {
                    c.setCurrentPortId(null);
                } else {
                    c.setCurrentPortId(portId);
                }

                containers.add(c);
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Unable to retrieve available containers: "
                            + e.getMessage(), e);
        }

        return containers;
    }


    @Override
    public Container findById(Long containerId) {

        if (containerId == null) {
            return null;
        }

        String sql = "SELECT "
                + "container_id, "
                + "container_number, "
                + "type, "
                + "size, "
                + "image_url, "
                + "tare_weight_kg, "
                + "max_gross_weight_kg, "
                + "goods_capacity_kg, "
                + "goods_capacity_cbm, "
                + "status, "
                + "current_port_id, "
                + "owner_company_id "
                + "FROM containers "
                + "WHERE container_id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setLong(1, containerId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Container c = new Container();

                    c.setContainerId(
                            rs.getLong("container_id"));

                    c.setContainerNumber(
                            rs.getString("container_number"));

                    c.setType(
                            rs.getString("type"));

                    c.setSize(
                            rs.getString("size"));

                    c.setImageUrl(
                            rs.getString("image_url"));

                    c.setTareWeightKg(
                            rs.getDouble("tare_weight_kg"));

                    c.setMaxGrossWeightKg(
                            rs.getDouble(
                                    "max_gross_weight_kg"));

                    c.setGoodsCapacityKg(
                            rs.getDouble(
                                    "goods_capacity_kg"));

                    c.setGoodsCapacityCbm(
                            rs.getDouble(
                                    "goods_capacity_cbm"));

                    c.setStatus(
                            rs.getString("status"));

                    long portId =
                            rs.getLong("current_port_id");

                    if (rs.wasNull()) {
                        c.setCurrentPortId(null);
                    } else {
                        c.setCurrentPortId(portId);
                    }

                    c.setOwnerCompanyId(
                            rs.getLong("owner_company_id"));

                    return c;
                }
            }

        } catch (Exception e) {

            throw new RuntimeException(
                    "Unable to find container: "
                            + e.getMessage(), e);
        }

        return null;
    }


    @Override
    public void allocate(
            Long containerId,
            Double cargoWeightKg,
            Double cargoVolumeCbm,
            Long companyId) {

        /*
         * Validate required IDs.
         */
        if (containerId == null) {
            throw new IllegalArgumentException(
                    "Container ID is required.");
        }

        if (companyId == null) {
            throw new IllegalArgumentException(
                    "Company ID is required.");
        }

        /*
         * Lock the container while checking and
         * allocating it.
         *
         * This prevents two users from allocating
         * the same container simultaneously.
         */
        String selectSql = "SELECT "
                + "status, "
                + "goods_capacity_kg, "
                + "goods_capacity_cbm "
                + "FROM containers "
                + "WHERE container_id = ? "
                + "AND owner_company_id = ? "
                + "FOR UPDATE";

        String updateSql = "UPDATE containers "
                + "SET status = 'Allocated' "
                + "WHERE container_id = ? "
                + "AND owner_company_id = ? "
                + "AND status = 'Available'";

        try (Connection con = GetConnection.getConnection()) {

            if (con == null) {
                throw new RuntimeException(
                        "Database connection could not be established.");
            }

            con.setAutoCommit(false);

            try {

                double capacityKg;
                double capacityCbm;
                String status;

                /*
                 * Lock the container and verify ownership.
                 */
                try (PreparedStatement ps =
                             con.prepareStatement(selectSql)) {

                    ps.setLong(1, containerId);
                    ps.setLong(2, companyId);

                    try (ResultSet rs =
                                 ps.executeQuery()) {

                        if (!rs.next()) {

                            throw new IllegalArgumentException(
                                    "Container does not exist "
                                            + "or does not belong "
                                            + "to this company.");
                        }

                        status =
                                rs.getString("status");

                        capacityKg =
                                rs.getDouble(
                                        "goods_capacity_kg");

                        capacityCbm =
                                rs.getDouble(
                                        "goods_capacity_cbm");
                    }
                }

                /*
                 * Only Available containers can be allocated.
                 */
                if (!"Available".equals(status)) {

                    throw new IllegalArgumentException(
                            "Only Available containers "
                                    + "can be allocated.");
                }

                /*
                 * Validate cargo weight.
                 */
                if (cargoWeightKg == null ||
                        cargoWeightKg < 0) {

                    throw new IllegalArgumentException(
                            "Cargo weight cannot be negative.");
                }

                /*
                 * Validate cargo volume.
                 */
                if (cargoVolumeCbm == null ||
                        cargoVolumeCbm < 0) {

                    throw new IllegalArgumentException(
                            "Cargo volume cannot be negative.");
                }

                /*
                 * Validate cargo weight against
                 * container capacity.
                 */
                if (cargoWeightKg > capacityKg) {

                    throw new IllegalArgumentException(
                            "Cargo weight exceeds "
                                    + "container capacity.");
                }

                /*
                 * Validate cargo volume against
                 * container capacity.
                 */
                if (cargoVolumeCbm > capacityCbm) {

                    throw new IllegalArgumentException(
                            "Cargo volume exceeds "
                                    + "container capacity.");
                }

                /*
                 * Allocate only when the container still
                 * belongs to this company and is Available.
                 */
                try (PreparedStatement ps =
                             con.prepareStatement(updateSql)) {

                    ps.setLong(1, containerId);
                    ps.setLong(2, companyId);

                    int rows =
                            ps.executeUpdate();

                    if (rows != 1) {

                        throw new IllegalArgumentException(
                                "Container could not be allocated.");
                    }
                }

                con.commit();

            } catch (Exception e) {

                try {
                    con.rollback();
                } catch (Exception ignored) {
                }

                throw e;
            }

        } catch (Exception e) {

            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }

            throw new RuntimeException(
                    "Unable to allocate container: "
                            + e.getMessage(), e);
        }
    }


    @Override
    public void release(
            Long containerId,
            Long companyId) {

        if (containerId == null) {
            throw new IllegalArgumentException(
                    "Container ID is required.");
        }

        if (companyId == null) {
            throw new IllegalArgumentException(
                    "Company ID is required.");
        }

        String sql = "UPDATE containers "
                + "SET status = 'Available' "
                + "WHERE container_id = ? "
                + "AND owner_company_id = ? "
                + "AND status = 'Allocated'";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setLong(1, containerId);
            ps.setLong(2, companyId);

            int rows =
                    ps.executeUpdate();

            if (rows == 0) {

                throw new RuntimeException(
                        "Container cannot be released. "
                                + "It may not belong to this "
                                + "company or may not be Allocated.");
            }

        } catch (Exception e) {

            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }

            throw new RuntimeException(
                    "Unable to release container: "
                            + e.getMessage(), e);
        }
    }


    /*
     * ============================================================
     * CUSTOMER PRICING
     * ============================================================
     *
     * Added only for customer price display.
     *
     * Uses the existing database procedure:
     * CALL show_pricing_rules()
     *
     * No database table or field is added.
     */
    @Override
    public List<Map<String, Object>> getCustomerPricing()
            throws SQLException {

        List<Map<String, Object>> pricingList =
                new ArrayList<Map<String, Object>>();

        String sql = "{CALL show_pricing_rules()}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> pricing =
                        new LinkedHashMap<String, Object>();

                pricing.put(
                        "container_type",
                        rs.getString("container_type"));

                pricing.put(
                        "container_size",
                        rs.getString("container_size"));

                pricing.put(
                        "route_id",
                        rs.getLong("route_id"));

                pricing.put(
                        "final_price",
                        rs.getBigDecimal("final_price"));

                pricing.put(
                        "valid_from",
                        rs.getDate("valid_from"));

                pricing.put(
                        "valid_to",
                        rs.getDate("valid_to"));

                pricingList.add(pricing);
            }

        } catch (SQLException e) {

            throw new SQLException(
                    "Unable to retrieve customer pricing: "
                            + e.getMessage(), e);
        }

        return pricingList;
    }

}