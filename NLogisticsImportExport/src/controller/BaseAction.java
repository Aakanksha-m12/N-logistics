package controller;

import controller.Action;
import controller.Module1Service;
import javax.servlet.http.*;

public abstract class BaseAction implements Action {
	protected final Module1Service service = new Module1Service();

	protected HttpSession session(HttpServletRequest r) {
		return r.getSession(false);
	}

	protected String ip(HttpServletRequest r) {
		return r.getRemoteAddr();
	}
}
