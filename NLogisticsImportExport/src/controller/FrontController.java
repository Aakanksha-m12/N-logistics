package controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/app")
public class FrontController extends HttpServlet {
	private Action action(String name) {
		switch (name) {
		case "login":
			return new LoginAction();
		case "logout":
			return new LogoutAction();
		case "register-company":
			return new RegisterCompanyAction();
		case "register-customer":
			return new RegisterCustomerAction();
		case "profile":
			return new ProfileAction();
		case "update-profile":
			return new UpdateProfileAction();
		case "pending-companies":
			return new PendingCompaniesAction();
		case "approve-company":
			return new ApproveCompanyAction();
		case "suspend-company":
			return new SuspendCompanyAction();
		case "company-users":
			return new CompanyUsersAction();
		case "audit":
			return new AuditAction();
		case "module3":
		    return new Module3Action();
		case "forgot-password":
			return new ForgotPasswordAction();
		case "verify-reset":
			return new VerifyResetAction();
		case "reset-password":
			return new ResetPasswordAction();
			
		default:
			return new HomeAction();
		}
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dispatch(req, resp);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dispatch(req, resp);
	}

	private void dispatch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			Csrf.ensureToken(req);

			if ("POST".equalsIgnoreCase(req.getMethod()) && !Csrf.isValid(req)) {
				throw new SecurityException("Invalid or missing security token. Please refresh the page and try again.");
			}

			action(param(req, "action", "home")).execute(req, resp);
		} catch (SecurityException e) {
			HttpSession s = req.getSession(false);
			if (s != null && s.getAttribute("userId") instanceof Integer) {
				try {
					new Module1Service().permissionDenied(
							(Integer) s.getAttribute("userId"),
							"request",
							param(req, "action", "home"),
							"DENIED",
							req.getRemoteAddr());
				} catch (Exception ignored) {
					// Do not hide the original authorization/security error.
				}
			}
			req.setAttribute("error", e.getMessage());
			forward(req, resp, "error.jsp");
		} catch (Exception e) {
			Throwable t = e;
			while (t.getCause() != null)
				t = t.getCause();
			req.setAttribute("error", t.getMessage() == null ? "Unexpected server error." : t.getMessage());
			forward(req, resp, "error.jsp");
		}
	}

	static String param(HttpServletRequest r, String n, String d) {
		String v = r.getParameter(n);
		return v == null || v.trim().isEmpty() ? d : v;
	}

	public static void forward(HttpServletRequest r, HttpServletResponse p, String jsp)
			throws ServletException, IOException {
		r.getRequestDispatcher("/WEB-INF/views/" + jsp).forward(r, p);
	}
}
