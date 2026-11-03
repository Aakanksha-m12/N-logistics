package implementors;

import db_config.GetConnection;
import operations.UserOperations;
import model.*;
import java.sql.*;
import java.util.*;

public class User_Operation_Implementor implements UserOperations {
	public User login(String login) throws SQLException {
		try (Connection c = GetConnection.getConnection(); CallableStatement s = c.prepareCall("{call sp_login(?)}")) {
			s.setString(1, login);
			try (ResultSet r = s.executeQuery()) {
				if (!r.next())
					return null;
				ResultSetMetaData md = r.getMetaData();
				boolean hasResult = false;
				for (int i = 1; i <= md.getColumnCount(); i++) {
					if ("result".equalsIgnoreCase(md.getColumnLabel(i))
							|| "result".equalsIgnoreCase(md.getColumnName(i))) {
						hasResult = true;
						break;
					}
				}
				if (hasResult && "INVALID_CREDENTIALS".equalsIgnoreCase(r.getString("result")))
					return null;
				return readLogin(r);
			}
		}
	}

	private User readLogin(ResultSet r) throws SQLException {
		User u = new User();
		u.setUserId(r.getInt("user_id"));
		u.setUsername(r.getString("username"));
		u.setEmail(r.getString("email"));
		u.setPasswordHash(r.getString("password_hash"));
		u.setPhone(r.getString("phone"));
		u.setRoleId(r.getInt("role_id"));
		u.setRoleName(r.getString("role_name"));
		int cid = r.getInt("company_id");
		u.setCompanyId(r.wasNull() ? null : cid);
		u.setCompanyName(r.getString("company_name"));
		u.setCompanyStatus(r.getString("company_status"));
		u.setStatus(r.getString("status"));
		u.setFailedLoginCount(r.getInt("failed_login_count"));
		u.setLockedUntil(str(r.getTimestamp("locked_until")));
		u.setLastLoginAt(str(r.getTimestamp("last_login_at")));
		return u;
	}

	public LoginResult recordLoginFailure(int uid, String ip) throws SQLException {
		try (Connection c = GetConnection.getConnection();
				CallableStatement s = c.prepareCall("{call sp_record_login_failure(?,?)}")) {
			s.setInt(1, uid);
			s.setString(2, ip);
			try (ResultSet r = s.executeQuery()) {
				LoginResult x = new LoginResult();
				if (r.next()) {
					x.setResult(r.getString("result"));
					x.setMessage(r.getString("message"));
					try {
						x.setAttemptsRemaining(r.getInt("attempts_remaining"));
					} catch (SQLException ignored) {
					}
					try {
						x.setLockoutMinutes(r.getInt("lockout_minutes"));
					} catch (SQLException ignored) {
					}
				}
				return x;
			}
		}
	}

	public void recordLoginSuccess(int uid, String ip) throws SQLException {
		call2("{call sp_record_login_success(?,?)}", uid, ip);
	}

	public void recordLogout(int uid, String ip) throws SQLException {
		call2("{call sp_record_logout(?,?)}", uid, ip);
	}

	private void call2(String call, int uid, String ip) throws SQLException {
		try (Connection c = GetConnection.getConnection(); CallableStatement s = c.prepareCall(call)) {
			s.setInt(1, uid);
			s.setString(2, ip);
			s.execute();
		}
	}

	public User getProfile(int uid) throws SQLException {
		try (Connection c = GetConnection.getConnection();
				CallableStatement s = c.prepareCall("{call sp_get_user_profile(?)}")) {
			s.setInt(1, uid);
			try (ResultSet r = s.executeQuery()) {
				if (!r.next())
					return null;
				User u = new User();
				u.setUserId(r.getInt("user_id"));
				u.setUsername(r.getString("username"));
				u.setEmail(r.getString("email"));
				u.setPhone(r.getString("phone"));
				u.setRoleName(r.getString("role_name"));
				int cid = r.getInt("company_id");
				u.setCompanyId(r.wasNull() ? null : cid);
				u.setCompanyName(r.getString("company_name"));
				u.setStatus(r.getString("status"));
				u.setLastLoginAt(str(r.getTimestamp("last_login_at")));
				u.setCreatedAt(str(r.getTimestamp("created_at")));
				u.setUpdatedAt(str(r.getTimestamp("updated_at")));
				return u;
			}
		}
	}

	@Override
	public void updateProfile(
	        int userId,
	        String email,
	        String phone,
	        String ip) throws SQLException {

	    try (
	        Connection c = GetConnection.getConnection();
	        CallableStatement s =
	            c.prepareCall("{call sp_update_user_profile(?,?,?,?)}")
	    ) {

	        s.setInt(1, userId);
	        s.setString(2, email);
	        s.setString(3, phone);
	        s.setString(4, ip);

	        s.execute();
	    }
	}

	public List<User> getCompanyUsers(int actor) throws SQLException {
		List<User> out = new ArrayList<>();
		try (Connection c = GetConnection.getConnection();
				CallableStatement s = c.prepareCall("{call sp_get_company_users(?)}")) {
			s.setInt(1, actor);
			try (ResultSet r = s.executeQuery()) {
				while (r.next()) {
					User u = new User();
					u.setUserId(r.getInt("user_id"));
					u.setUsername(r.getString("username"));
					u.setEmail(r.getString("email"));
					u.setPhone(r.getString("phone"));
					u.setRoleName(r.getString("role_name"));
					int cid = r.getInt("company_id");
					u.setCompanyId(r.wasNull() ? null : cid);
					u.setCompanyName(r.getString("company_name"));
					u.setStatus(r.getString("status"));
					u.setLastLoginAt(str(r.getTimestamp("last_login_at")));
					u.setCreatedAt(str(r.getTimestamp("created_at")));
					out.add(u);
				}
			}
		}
		return out;
	}

	public void resetPassword(int uid, String hash) throws SQLException {
		try (Connection c = GetConnection.getConnection();
				CallableStatement s = c.prepareCall("{call sp_reset_password(?,?)}")) {
			s.setInt(1, uid);
			s.setString(2, hash);
			s.execute();
		}
	}

	public ResetAccount findResetAccount(String login) throws SQLException {
		if (login == null || login.trim().isEmpty())
			return null;
		try (Connection c = GetConnection.getConnection();
				PreparedStatement s = c
						.prepareStatement("SELECT user_id,email FROM users WHERE username=? OR email=? LIMIT 1")) {
			s.setString(1, login.trim());
			s.setString(2, login.trim());
			try (ResultSet r = s.executeQuery()) {
				if (r.next())
					return new ResetAccount(r.getInt("user_id"), r.getString("email"));
			}
		}
		return null;
	}

	private static String str(Timestamp t) {
		return t == null ? null : t.toString();
	}
}
