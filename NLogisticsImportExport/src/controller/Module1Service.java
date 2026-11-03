package controller;

import model.*;
import operations.*;
import implementors.*;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.SQLException;
import java.util.List;

public class Module1Service {
	private final RoleOperations roles = new Role_Operation_Implementor();
	private final CompanyOperations companies = new Company_Operation_Implementor();
	private final CustomerOperations customers = new Customer_Operation_Implementor();
	private final UserOperations users = new User_Operation_Implementor();
	private final AuditOperations audit = new Audit_Operation_Implementor();

	public List<String> getRoles() throws SQLException {
		return roles.getRoles();
	}

	public int registerCompany(Company c, String plain) throws SQLException {
		c.setAdminPasswordHash(hash(plain));
		return companies.registerCompany(c);
	}

	public int registerCustomer(Customer c) throws SQLException {
		c.setPassword(hash(c.getPassword()));
		return customers.registerCustomer(c);
	}

	public User authenticate(String login, String password, String ip) throws Exception {
		if (blank(login) || blank(password))
			throw new IllegalArgumentException("Username/email and password are required.");
		User u = users.login(login.trim());
		if (u == null)
			return null;
		if ("Locked".equalsIgnoreCase(u.getStatus()))
			return null;
		if (u.getCompanyStatus() != null && !"Active".equalsIgnoreCase(u.getCompanyStatus()))
			return null;
		boolean ok = BCrypt.checkpw(password, u.getPasswordHash());
		if (!ok) {
			users.recordLoginFailure(u.getUserId(), ip);
			return null;
		}
		users.recordLoginSuccess(u.getUserId(), ip);
		return u;
	}

	public LoginResult failedAttempt(int uid, String ip) throws SQLException {
		return users.recordLoginFailure(uid, ip);
	}

	public void logout(int uid, String ip) throws SQLException {
		users.recordLogout(uid, ip);
	}

	public List<Company> pendingCompanies(int uid) throws SQLException {
	    return companies.getCompaniesForManagement(uid);
	}

	public void approveCompany(int uid, int cid, String ip) throws SQLException {
		companies.approveCompany(uid, cid, ip);
	}

	public void suspendCompany(int uid, int cid, String ip) throws SQLException {
		companies.suspendCompany(uid, cid, ip);
	}

	public User profile(int uid) throws SQLException {
		return users.getProfile(uid);
	}

	public void updateProfile(
	        int uid,
	        String email,
	        String phone,
	        String ip) throws SQLException {

	    users.updateProfile(uid, email, phone, ip);
	}

	public List<User> companyUsers(int uid) throws SQLException {
		return users.getCompanyUsers(uid);
	}

	public List<AuditLog> audit(int uid) throws SQLException {
		return audit.getAuditLog(uid);
	}

	public void permissionDenied(int uid, String e, String eid, String a, String ip) throws SQLException {
		audit.logPermissionDenied(uid, e, eid, a, ip);
	}

	public void resetPassword(int uid, String plain) throws SQLException {
		users.resetPassword(uid, hash(plain));
	}

	public ResetAccount findResetAccount(String login) throws SQLException {
		return users.findResetAccount(login);
	}

	private static String hash(String p) {
		if (blank(p) || p.length() < 8)
			throw new IllegalArgumentException("Password must contain at least 8 characters.");
		return BCrypt.hashpw(p, BCrypt.gensalt(12));
	}

	private static boolean blank(String s) {
		return s == null || s.trim().isEmpty();
	}
}
