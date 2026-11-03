package controller;

import javax.servlet.http.*;

public class SuspendCompanyAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		int uid = Authorization.requireRole(session(r), "Super Admin");
		int cid = Integer.parseInt(r.getParameter("companyId"));
		if (cid <= 0)
			throw new IllegalArgumentException("Invalid company ID.");
		service.suspendCompany(uid, cid, ip(r));
		p.sendRedirect(r.getContextPath() + "/app?action=home");
	}
}
