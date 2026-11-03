package implementors;
import db_config.GetConnection; import operations.RoleOperations; import java.sql.*; import java.util.*;
public class Role_Operation_Implementor implements RoleOperations {
 public List<String> getRoles() throws SQLException { List<String> out=new ArrayList<>(); try(Connection c=GetConnection.getConnection(); CallableStatement s=c.prepareCall("{call sp_get_roles()}")){try(ResultSet r=s.executeQuery()){while(r.next())out.add(r.getString("role_name"));}} return out;}
}
