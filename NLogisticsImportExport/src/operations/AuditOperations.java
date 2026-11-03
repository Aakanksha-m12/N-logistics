package operations;
import java.sql.SQLException; import java.util.List; import model.AuditLog;
public interface AuditOperations { List<AuditLog> getAuditLog(int actor) throws SQLException; void logPermissionDenied(int userId,String entity,String entityId,String action,String ip) throws SQLException; }
