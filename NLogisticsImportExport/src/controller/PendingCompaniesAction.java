package controller;

import javax.servlet.http.*;

public class PendingCompaniesAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		int uid = Authorization.requireRole(session(r), "Super Admin");
		r.setAttribute("companies", service.pendingCompanies(uid));
		FrontController.forward(r, p, "pending-companies.jsp");
	}
}
