package implementors;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.Company;
import operations.CompanyOperations;

public class Company_Operations_Implementor implements CompanyOperations {

    @Override
    public List<Company> showActiveCompanies() {

        List<Company> companies = new ArrayList<Company>();

        String sql =
            "SELECT company_id, company_name, license_no, gst_no, tin_no, " +
            "address, contact_email, contact_phone, approval_status, created_at " +
            "FROM companies " +
            "WHERE approval_status = 'Active' " +
            "ORDER BY company_name";

        try {
            Connection connection = GetConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                Company company = new Company();

                company.setCompanyId(resultSet.getLong("company_id"));
                company.setCompanyName(resultSet.getString("company_name"));
                company.setLicenseNo(resultSet.getString("license_no"));
                company.setGstNo(resultSet.getString("gst_no"));
                company.setTinNo(resultSet.getString("tin_no"));
                company.setAddress(resultSet.getString("address"));
                company.setContactEmail(resultSet.getString("contact_email"));
                company.setContactPhone(resultSet.getString("contact_phone"));
                company.setApprovalStatus(
                    resultSet.getString("approval_status")
                );
                company.setCreatedAt(
                    resultSet.getTimestamp("created_at")
                );

                companies.add(company);
            }

            resultSet.close();
            statement.close();
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return companies;
    }

    @Override
    public List<Company> searchCompanies(String keyword) {

        List<Company> companies = new ArrayList<Company>();

        String sql =
            "SELECT company_id, company_name, license_no, gst_no, tin_no, " +
            "address, contact_email, contact_phone, approval_status, created_at " +
            "FROM companies " +
            "WHERE approval_status = 'Active' " +
            "AND (" +
            "company_name LIKE ? " +
            "OR CAST(company_id AS CHAR) LIKE ? " +
            "OR license_no LIKE ? " +
            "OR gst_no LIKE ?" +
            ") " +
            "ORDER BY company_name";

        try {
            Connection connection = GetConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql);

            String searchValue = "%" + keyword + "%";

            statement.setString(1, searchValue);
            statement.setString(2, searchValue);
            statement.setString(3, searchValue);
            statement.setString(4, searchValue);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                Company company = new Company();

                company.setCompanyId(resultSet.getLong("company_id"));
                company.setCompanyName(resultSet.getString("company_name"));
                company.setLicenseNo(resultSet.getString("license_no"));
                company.setGstNo(resultSet.getString("gst_no"));
                company.setTinNo(resultSet.getString("tin_no"));
                company.setAddress(resultSet.getString("address"));
                company.setContactEmail(resultSet.getString("contact_email"));
                company.setContactPhone(resultSet.getString("contact_phone"));
                company.setApprovalStatus(
                    resultSet.getString("approval_status")
                );
                company.setCreatedAt(
                    resultSet.getTimestamp("created_at")
                );

                companies.add(company);
            }

            resultSet.close();
            statement.close();
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return companies;
    }

    @Override
    public Company findById(Long companyId) {

        if (companyId == null) {
            return null;
        }

        String sql =
            "SELECT company_id, company_name, license_no, gst_no, tin_no, " +
            "address, contact_email, contact_phone, approval_status, created_at " +
            "FROM companies " +
            "WHERE company_id = ? " +
            "LIMIT 1";

        try {
            Connection connection = GetConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql);

            statement.setLong(1, companyId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {

                Company company = new Company();

                company.setCompanyId(resultSet.getLong("company_id"));
                company.setCompanyName(resultSet.getString("company_name"));
                company.setLicenseNo(resultSet.getString("license_no"));
                company.setGstNo(resultSet.getString("gst_no"));
                company.setTinNo(resultSet.getString("tin_no"));
                company.setAddress(resultSet.getString("address"));
                company.setContactEmail(resultSet.getString("contact_email"));
                company.setContactPhone(resultSet.getString("contact_phone"));
                company.setApprovalStatus(
                    resultSet.getString("approval_status")
                );
                company.setCreatedAt(
                    resultSet.getTimestamp("created_at")
                );

                resultSet.close();
                statement.close();
                connection.close();

                return company;
            }

            resultSet.close();
            statement.close();
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}