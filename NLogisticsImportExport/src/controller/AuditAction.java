package controller;

import javax.servlet.http.*;

public class AuditAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		int uid = Authorization.requireRole(session(r), "Super Admin");
		r.setAttribute("logs", service.audit(uid));
		FrontController.forward(r, p, "audit.jsp");
	}
}
