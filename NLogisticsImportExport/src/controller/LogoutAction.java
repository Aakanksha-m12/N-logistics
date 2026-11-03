package controller;

import controller.FrontController;
import controller.Authorization;
import javax.servlet.http.*;

public class LogoutAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		HttpSession s = r.getSession(false);
		if (s != null && s.getAttribute("userId") != null) {
			service.logout((Integer) s.getAttribute("userId"), ip(r));
			s.invalidate();
		}
		p.sendRedirect(r.getContextPath() + "/app?action=login");
	}
}
