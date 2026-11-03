package controller;

import controller.FrontController;
import model.Customer;
import javax.servlet.http.*;

public class RegisterCustomerAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		if ("GET".equalsIgnoreCase(r.getMethod())) {
			FrontController.forward(r, p, "register-customer.jsp");
			return;
		}
		Customer c = new Customer();
		c.setUsername(r.getParameter("username"));
		c.setEmail(r.getParameter("email"));
		c.setPassword(r.getParameter("password"));
		c.setPhone(r.getParameter("phone"));
		c.setCustomerName(r.getParameter("customerName"));
		c.setAddress(r.getParameter("address"));
		c.setKycDocPath(r.getParameter("kycDocPath"));
		service.registerCustomer(c);
		r.setAttribute("message", "Customer registration successful. You can log in.");
		FrontController.forward(r, p, "login.jsp");
	}
}
