package controller;

import javax.servlet.http.*;

public class ProfileAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		int uid = Authorization.requireLogin(session(r));
		r.setAttribute("user", service.profile(uid));
		FrontController.forward(r, p, "profile.jsp");
	}
}
