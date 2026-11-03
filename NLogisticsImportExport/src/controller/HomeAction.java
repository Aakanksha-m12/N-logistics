package controller;

import javax.servlet.http.*;
import controller.FrontController;

public class HomeAction extends BaseAction {
	public void execute(HttpServletRequest r, HttpServletResponse p) throws Exception {
		FrontController.forward(r, p, "home.jsp");
	}
}
