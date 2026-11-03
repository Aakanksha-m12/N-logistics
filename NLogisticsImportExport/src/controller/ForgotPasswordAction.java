package controller;

import model.ResetAccount;
import javax.servlet.http.*;

public class ForgotPasswordAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		if ("GET".equalsIgnoreCase(r.getMethod())) {
			FrontController.forward(r, p, "forgot-password.jsp");
			return;
		}
		String login = r.getParameter("login");
		if (login == null || login.trim().isEmpty())
			throw new IllegalArgumentException("Username or email is required.");
		ResetAccount a = service.findResetAccount(login);
		if (a == null) {
			r.setAttribute("message", "If the account exists, a reset code has been issued.");
			FrontController.forward(r, p, "forgot-password.jsp");
			return;
		}
		String token = PasswordResetStore.create(a.getUserId());
		ResetMailer.send(a.getEmail(), token);
		r.setAttribute("message",
				"A reset code has been issued to the registered email. In development, the code is also printed in the Eclipse/Tomcat console.");
		FrontController.forward(r, p, "verify-reset.jsp");
	}
}
