package controller;

import javax.servlet.http.*;

public class VerifyResetAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		if ("GET".equalsIgnoreCase(r.getMethod())) {
			FrontController.forward(r, p, "verify-reset.jsp");
			return;
		}
		String token = r.getParameter("token");
		PasswordResetStore.Token t = PasswordResetStore.consume(token == null ? "" : token.trim());
		if (t == null) {
			r.setAttribute("error", "Invalid, expired, or already used reset code.");
			FrontController.forward(r, p, "verify-reset.jsp");
			return;
		}
		HttpSession s = r.getSession(true);
		s.setAttribute("resetUserId", t.userId);
		s.setAttribute("resetVerified", Boolean.TRUE);
		FrontController.forward(r, p, "reset-password.jsp");
	}
}
