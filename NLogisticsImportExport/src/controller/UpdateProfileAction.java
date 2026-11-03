package controller;

import javax.servlet.http.*;

public class UpdateProfileAction extends BaseAction {

    public void execute(
            HttpServletRequest r,
            HttpServletResponse p) throws Exception {

        int uid = Authorization.requireLogin(session(r));

        service.updateProfile(
            uid,
            r.getParameter("email"),
            r.getParameter("phone"),
            ip(r)
        );

        p.sendRedirect(
            r.getContextPath() + "/app?action=profile"
        );
    }
}