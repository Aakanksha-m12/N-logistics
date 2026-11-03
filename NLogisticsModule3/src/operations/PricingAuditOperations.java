package operations;

import java.util.List;
import model.PricingAudit;

public interface PricingAuditOperations {

    void add(PricingAudit audit);

    List<PricingAudit> showAll();

    List<PricingAudit> showByCompany(Long companyId);
}