package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Container;

@WebServlet("/app")
public class Module3FrontController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Module3Service service;

    @Override
    public void init() throws ServletException {

        service = new Module3Service();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        handleRequest(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        handleRequest(request, response);
    }


    private void handleRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Do not create a new session here.
         *
         * If there is no existing authenticated
         * Module 3 session, access is denied.
         */
        HttpSession session =
                request.getSession(false);

        try {

            String action =
                    request.getParameter("action");


            /*
             * An expired Module 3 session must return the user to
             * the Module 1 sign-in flow instead of showing a raw 403.
             */
            if (session == null &&
                    !"logout".equalsIgnoreCase(action)) {

                String module1LogoutUrl =
                        getServletContext()
                                .getInitParameter(
                                        "module1LogoutUrl");

                if (module1LogoutUrl == null ||
                        module1LogoutUrl.trim().isEmpty()) {

                    module1LogoutUrl =
                            "http://localhost:8080/"
                            + "NLogisticsImportExport/"
                            + "app?action=logout";
                }

                response.sendRedirect(
                        module1LogoutUrl);

                return;
            }


            /*
             * ====================================================
             * LOGOUT
             * ====================================================
             *
             * Module 3 invalidates its own session first, then
             * sends the browser to Module 1's existing logout
             * endpoint so the SSO session is also closed.
             */

            if ("logout".equalsIgnoreCase(action)) {

                if (session != null) {

                    if ("POST".equalsIgnoreCase(
                            request.getMethod())) {

                        Module3Authorization.requireCsrf(
                                request);
                    }

                    try {

                        session.invalidate();

                    } catch (IllegalStateException ignored) {

                        // Session already invalidated.
                    }
                }


                String module1LogoutUrl =
                        getServletContext()
                                .getInitParameter(
                                        "module1LogoutUrl");


                if (module1LogoutUrl == null ||
                        module1LogoutUrl.trim().isEmpty()) {

                    module1LogoutUrl =
                            "http://localhost:8080/"
                            + "NLogisticsImportExport/"
                            + "app?action=logout";
                }


                response.sendRedirect(
                        module1LogoutUrl);

                return;
            }


            /*
             * ====================================================
             * LOGIN CHECK
             * ====================================================
             */

            Integer userId =
                    Module3Authorization.requireLogin(
                            session);


            /*
             * ====================================================
             * ACTION
             * ====================================================
             */

            if (action == null ||
                    action.trim().isEmpty()) {

                action = "home";
            }


            /*
             * ====================================================
             * HOME
             * ====================================================
             */

            if ("home".equals(action)) {

                request.setAttribute(
                        "role",
                        Module3Authorization.getRole(
                                session));

                request.getRequestDispatcher(
                        "/WEB-INF/views/home.jsp")
                        .forward(
                                request,
                                response);

                return;
            }


            /*
             * ====================================================
             * HOME ALLOCATION
             * ====================================================
             *
             * Compatibility route.
             *
             * Some existing Module 1 / dashboard navigation may
             * send:
             *
             *     /app?action=homeallocation
             *
             * Allocation itself is handled by AllocationController
             * at:
             *
             *     /allocation?action=view
             *
             * Therefore redirect to the real allocation controller.
             */

            if ("homeallocation".equalsIgnoreCase(action)) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/allocation?action=view");

                return;
            }


            /*
             * ====================================================
             * CONTAINER VIEW
             * ====================================================
             *
             * Role-based behavior:
             *
             * Super Admin
             *     -> ALL companies
             *
             * Company Admin
             *     -> OWN company
             *
             * Operations Staff
             *     -> OWN company
             *
             * Customer
             *     -> SAFE AVAILABLE containers
             *
             * Finance Staff
             *     -> DENIED
             */

            if ("containers".equals(action)) {

                String role =
                        Module3Authorization.getRole(
                                session);

                List<Container> containers;


                /*
                 * =================================================
                 * SUPER ADMIN
                 * =================================================
                 */

                if (Module3Authorization
                        .ROLE_SUPER_ADMIN
                        .equals(role)) {

                    containers =
                            service.getAllContainers(
                                    userId);
                }


                /*
                 * =================================================
                 * CUSTOMER
                 * =================================================
                 */

                else if (Module3Authorization
                        .ROLE_CUSTOMER
                        .equals(role)) {

                    /*
                     * Customer container access is handled by the
                     * dedicated no-allocation flow.
                     */
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/containers?action=view");

                    return;
                }


                /*
                 * =================================================
                 * COMPANY ADMIN
                 * =================================================
                 */

                else if (Module3Authorization
                        .ROLE_COMPANY_ADMIN
                        .equals(role)) {

                    Long companyId =
                            Module3Authorization
                                    .getCompanyId(
                                            session);

                    if (companyId == null) {

                        throw new SecurityException(
                                "Company context is required.");
                    }

                    containers =
                            service.getContainersByCompany(
                                    companyId,
                                    userId);
                }


                /*
                 * =================================================
                 * OPERATIONS STAFF
                 * =================================================
                 */

                else if (Module3Authorization
                        .ROLE_OPERATIONS
                        .equals(role)) {

                    Long companyId =
                            Module3Authorization
                                    .getCompanyId(
                                            session);

                    if (companyId == null) {

                        throw new SecurityException(
                                "Company context is required.");
                    }

                    containers =
                            service.getContainersByCompany(
                                    companyId,
                                    userId);
                }


                /*
                 * =================================================
                 * ALL OTHER ROLES
                 * =================================================
                 */

                else {

                    throw new SecurityException(
                            "You do not have permission to view containers.");
                }


                /*
                 * =================================================
                 * SEND DATA TO JSP
                 * =================================================
                 */

                request.setAttribute(
                        "containers",
                        containers);

                request.setAttribute(
                        "role",
                        role);

                request.getRequestDispatcher(
                        "/WEB-INF/views/containers.jsp")
                        .forward(
                                request,
                                response);

                return;
            }


            /*
             * ====================================================
             * MANAGE CONTAINERS
             * ====================================================
             *
             * Only:
             *
             * Super Admin
             * Company Admin
             *
             * are allowed.
             */

            if ("manageContainers".equals(action)) {

                Module3Authorization
                        .requireContainerManagement(
                                session);

                String role =
                        Module3Authorization.getRole(
                                session);


                List<Container> containers;


                /*
                 * Super Admin can manage/view across
                 * all companies.
                 *
                 * Company Admin is restricted to
                 * their own company.
                 */

                if (Module3Authorization
                        .ROLE_SUPER_ADMIN
                        .equals(role)) {

                    containers =
                            service.getAllContainers(
                                    userId);

                } else {

                    Long companyId =
                            Module3Authorization
                                    .getCompanyId(
                                            session);

                    if (companyId == null) {

                        throw new SecurityException(
                                "Company context is required.");
                    }

                    containers =
                            service.getContainersByCompany(
                                    companyId,
                                    userId);
                }


                request.setAttribute(
                        "containers",
                        containers);

                request.setAttribute(
                        "role",
                        role);

                request.getRequestDispatcher(
                        "/WEB-INF/views/containers.jsp")
                        .forward(
                                request,
                                response);

                return;
            }


            /*
             * ====================================================
             * UNKNOWN ACTION
             * ====================================================
             */

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unknown Module 3 action.");


        } catch (SecurityException e) {

            /*
             * Unauthorized requests are blocked
             * server-side.
             */

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage());


        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "An internal error occurred.");
        }
    }
}