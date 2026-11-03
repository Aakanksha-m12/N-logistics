package controller;

import javax.servlet.http.HttpSession;

public final class Authorization {
	private Authorization() {
	}

	public static Integer requireLogin(HttpSession s) {
		if (s == null || s.getAttribute("userId") == null)
			throw new SecurityException("Login required.");
		return (Integer) s.getAttribute("userId");
	}

	public static Integer requireRole(HttpSession s, String role) {
		Integer id = requireLogin(s);
		String actual = (String) s.getAttribute("roleName");
		if (!role.equals(actual))
			throw new SecurityException("Access denied for role: " + actual);
		return id;
	}

	public static boolean isRole(HttpSession s, String role) {
		return s != null && role.equals(s.getAttribute("roleName"));
	}
}
