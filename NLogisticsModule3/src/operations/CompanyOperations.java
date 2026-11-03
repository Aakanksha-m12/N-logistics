package operations;

import java.util.List;
import model.Company;

public interface CompanyOperations {

    List<Company> showActiveCompanies();

    List<Company> searchCompanies(String keyword);

    Company findById(Long companyId);
}