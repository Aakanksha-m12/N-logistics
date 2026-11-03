package implementors;
import db_config.GetConnection; import operations.CustomerOperations; import model.Customer; import java.sql.*;
public class Customer_Operation_Implementor implements CustomerOperations {
 public int registerCustomer(Customer c)throws SQLException{try(Connection con=GetConnection.getConnection();CallableStatement s=con.prepareCall("{call sp_register_customer(?,?,?,?,?,?,?)}")){s.setString(1,c.getUsername());s.setString(2,c.getEmail());s.setString(3,c.getPassword());s.setString(4,c.getPhone());s.setString(5,c.getCustomerName());s.setString(6,c.getAddress());s.setString(7,c.getKycDocPath());try(ResultSet r=s.executeQuery()){if(r.next())return r.getInt("customer_id");}}throw new SQLException("Customer registration returned no result.");}
}
