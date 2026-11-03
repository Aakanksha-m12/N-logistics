package controller;

import controller.FrontController;
import model.Company;
import javax.servlet.http.*;

public class RegisterCompanyAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		if ("GET".equalsIgnoreCase(r.getMethod())) {
			FrontController.forward(r, p, "register-company.jsp");
			return;
		}
		Company c = new Company();
		c.setCompanyName(r.getParameter("companyName"));
		c.setLicenseNo(r.getParameter("licenseNo"));
		c.setGstNo(r.getParameter("gstNo"));
		c.setTinNo(r.getParameter("tinNo"));
		c.setAddress(r.getParameter("address"));
		c.setContactEmail(r.getParameter("contactEmail"));
		c.setContactPhone(r.getParameter("contactPhone"));
		c.setAdminUsername(r.getParameter("adminUsername"));
		c.setAdminEmail(r.getParameter("adminEmail"));
		c.setAdminPhone(r.getParameter("adminPhone"));
		service.registerCompany(c, r.getParameter("adminPassword"));
		r.setAttribute("message", "Company registration submitted. Status: Pending.");
		FrontController.forward(r, p, "login.jsp");
	}
}
