package controller;

import javax.servlet.http.*;

public class ResetPasswordAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		HttpSession s = r.getSession(false);
		if (s == null || !Boolean.TRUE.equals(s.getAttribute("resetVerified")) || s.getAttribute("resetUserId") == null)
			throw new SecurityException("Reset verification required.");
		String a = r.getParameter("newPassword"), b = r.getParameter("confirmPassword");
		if (a == null || !a.equals(b))
			throw new IllegalArgumentException("Passwords do not match.");
		service.resetPassword((Integer) s.getAttribute("resetUserId"), a);
		s.removeAttribute("resetUserId");
		s.removeAttribute("resetVerified");
		r.setAttribute("message", "Password reset successful. You can now log in.");
		FrontController.forward(r, p, "login.jsp");
	}
}
