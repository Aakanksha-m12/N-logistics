package controller;

import javax.servlet.http.*;

public interface Action {
	void execute(HttpServletRequest req, HttpServletResponse resp) throws Exception;
}
