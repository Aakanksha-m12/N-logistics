package operations;

import java.sql.SQLException;
import java.util.List;
import model.*;

public interface UserOperations {
	User login(String login) throws SQLException;

	LoginResult recordLoginFailure(int userId, String ip) throws SQLException;

	void recordLoginSuccess(int userId, String ip) throws SQLException;

	void recordLogout(int userId, String ip) throws SQLException;

	User getProfile(int userId) throws SQLException;

	void updateProfile(
	        int userId,
	        String email,
	        String phone,
	        String ip)
	        throws SQLException;

	List<User> getCompanyUsers(int actorUserId) throws SQLException;

	void resetPassword(int userId, String hash) throws SQLException;

	ResetAccount findResetAccount(String login) throws SQLException;
}
