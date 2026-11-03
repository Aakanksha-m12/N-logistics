package operations;
import java.sql.SQLException; import java.util.List;
public interface RoleOperations { List<String> getRoles() throws SQLException; }
