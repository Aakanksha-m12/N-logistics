package operations;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import model.Container;

public interface ContainerOperations {

    void add(Container container);

    void update(Container container);

    void delete(Container container);

    List<Container> showAll();

    List<Container> showAvailable();

    List<Container> showByCompany(Long companyId);

    List<Container> showAvailableByCompany(Long companyId);
    
    List<Map<String, Object>> getCustomerPricing() throws SQLException;

    Container findById(Long containerId);

    void allocate(Long containerId,
                  Double cargoWeightKg,
                  Double cargoVolumeCbm,
                  Long companyId);

    void release(Long containerId,
                 Long companyId);
}