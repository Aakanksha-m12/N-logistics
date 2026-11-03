package controller;

import controller.FrontController;
import model.User;
import javax.servlet.http.*;

public class LoginAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		if ("GET".equalsIgnoreCase(r.getMethod())) {
			FrontController.forward(r, p, "login.jsp");
			return;
		}
		User u = service.authenticate(r.getParameter("login"), r.getParameter("password"), ip(r));
		if (u == null) {
			r.setAttribute("error", "Invalid credentials, locked account, or inactive company.");
			FrontController.forward(r, p, "login.jsp");
			return;
		}
		HttpSession old = r.getSession(false);
		if (old != null)
			old.invalidate();
		HttpSession s = r.getSession(true);
		s.setMaxInactiveInterval(30 * 60);
		Csrf.ensureToken(r);
		s.setAttribute("userId", u.getUserId());
		s.setAttribute("username", u.getUsername());
		s.setAttribute("roleName", u.getRoleName());
		s.setAttribute("companyId", u.getCompanyId());
		p.sendRedirect(r.getContextPath() + "/app?action=home");
	}
}
