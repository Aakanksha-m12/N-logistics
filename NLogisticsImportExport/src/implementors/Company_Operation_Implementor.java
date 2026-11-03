package implementors;

import db_config.GetConnection;
import operations.CompanyOperations;
import model.Company;

import java.sql.*;
import java.util.*;

public class Company_Operation_Implementor implements CompanyOperations {

    @Override
    public int registerCompany(Company c) throws SQLException {

        try (
            Connection con = GetConnection.getConnection();
            CallableStatement s =
                con.prepareCall("{call sp_register_company(?,?,?,?,?,?,?,?,?,?,?)}")
        ) {

            s.setString(1, c.getCompanyName());
            s.setString(2, c.getLicenseNo());
            s.setString(3, c.getGstNo());
            s.setString(4, c.getTinNo());
            s.setString(5, c.getAddress());
            s.setString(6, c.getContactEmail());
            s.setString(7, c.getContactPhone());
            s.setString(8, c.getAdminUsername());
            s.setString(9, c.getAdminEmail());
            s.setString(10, c.getAdminPasswordHash());
            s.setString(11, c.getAdminPhone());

            try (ResultSet r = s.executeQuery()) {
                if (r.next()) {
                    return r.getInt("company_id");
                }
            }
        }

        throw new SQLException("Company registration returned no result.");
    }

    @Override
    public List<Company> getPendingCompanies(int actor) throws SQLException {

        List<Company> out = new ArrayList<>();

        try (
            Connection c = GetConnection.getConnection();
            CallableStatement s =
                c.prepareCall("{call sp_get_pending_companies(?)}")
        ) {

            s.setInt(1, actor);

            try (ResultSet r = s.executeQuery()) {

                while (r.next()) {
                    out.add(mapCompany(r));
                }
            }
        }

        return out;
    }

    @Override
    public List<Company> getCompaniesForManagement(int actor)
            throws SQLException {

        List<Company> out = new ArrayList<>();

        try (
            Connection c = GetConnection.getConnection();
            CallableStatement s =
                c.prepareCall("{call sp_get_companies_for_management(?)}")
        ) {

            s.setInt(1, actor);

            try (ResultSet r = s.executeQuery()) {

                while (r.next()) {
                    out.add(mapCompany(r));
                }
            }
        }

        return out;
    }

    private Company mapCompany(ResultSet r) throws SQLException {

        Company x = new Company();

        x.setCompanyId(r.getInt("company_id"));
        x.setCompanyName(r.getString("company_name"));
        x.setLicenseNo(r.getString("license_no"));
        x.setGstNo(r.getString("gst_no"));
        x.setTinNo(r.getString("tin_no"));
        x.setAddress(r.getString("address"));
        x.setContactEmail(r.getString("contact_email"));
        x.setContactPhone(r.getString("contact_phone"));
        x.setApprovalStatus(r.getString("approval_status"));
        x.setCreatedAt(String.valueOf(r.getTimestamp("created_at")));

        return x;
    }

    @Override
    public void approveCompany(
            int actor,
            int companyId,
            String ip) throws SQLException {

        exec(
            actor,
            companyId,
            ip,
            "{call sp_approve_company(?,?,?)}"
        );
    }

    @Override
    public void suspendCompany(
            int actor,
            int companyId,
            String ip) throws SQLException {

        exec(
            actor,
            companyId,
            ip,
            "{call sp_suspend_company(?,?,?)}"
        );
    }

    private void exec(
            int actor,
            int companyId,
            String ip,
            String call) throws SQLException {

        try (
            Connection c = GetConnection.getConnection();
            CallableStatement s = c.prepareCall(call)
        ) {

            s.setInt(1, actor);
            s.setInt(2, companyId);
            s.setString(3, ip);

            s.execute();
        }
    }
}