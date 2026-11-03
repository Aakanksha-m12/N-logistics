package operations;
import java.sql.SQLException; import model.Customer;
public interface CustomerOperations { int registerCustomer(Customer c) throws SQLException; }
