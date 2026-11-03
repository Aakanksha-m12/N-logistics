package operations;

import java.util.List;
import model.PricingRule;

public interface PricingRuleOperations {

    void add(PricingRule pricingRule);

    void update(PricingRule pricingRule);

    List<PricingRule> showAll();

    List<PricingRule> showByCompany(Long companyId);

    List<Long> getAvailableRouteIds();

    PricingRule findById(Long pricingId);

    PricingRule calculateFinalPrice(
            String containerType,
            String containerSize,
            Long routeId);
}