package controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CompanyUsersAction extends BaseAction {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session = session(request);

		Integer userId = Authorization.requireLogin(session);
		String role = (String) session.getAttribute("roleName");

		if (!"Super Admin".equals(role) && !"Company Admin".equals(role)) {

			throw new SecurityException("Only Super Admin or Company Admin can view company users.");
		}

		request.setAttribute("users", service.companyUsers(userId));

		FrontController.forward(request, response, "company-users.jsp");
	}
}