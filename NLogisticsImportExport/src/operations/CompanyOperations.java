package operations;

import java.sql.SQLException;
import java.util.List;
import model.Company;

public interface CompanyOperations {

    int registerCompany(Company c) throws SQLException;

    List<Company> getPendingCompanies(int actor) throws SQLException;

    List<Company> getCompaniesForManagement(int actor) throws SQLException;

    void approveCompany(int actor, int companyId, String ip) throws SQLException;

    void suspendCompany(int actor, int companyId, String ip) throws SQLException;
}