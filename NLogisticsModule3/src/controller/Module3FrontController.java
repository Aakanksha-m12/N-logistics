package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.List;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
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

    private static final SecureRandom RANDOM =
            new SecureRandom();

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

                /*
                 * The Module 3 session has expired. Send the browser
                 * back through Module 1 with a signed one-time token
                 * so any remaining Module 1 session is also cleared.
                 */

                response.sendRedirect(
                        buildModule1LogoutUrl(null));

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

                /*
                 * With no Module 3 session there is nothing left to
                 * protect, so the request is forwarded to Module 1
                 * with a signed token. This preserves the old
                 * "expired session still logs out" behaviour.
                 */

                if (session == null) {

                    response.sendRedirect(
                            buildModule1LogoutUrl(null));

                    return;
                }


                /*
                 * A live session must be ended with POST + CSRF.
                 * A plain GET link can no longer log the user out.
                 */

                if (!"POST".equalsIgnoreCase(
                        request.getMethod())) {

                    response.sendError(
                            HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                            "Logout requires a POST request.");

                    return;
                }


                Module3Authorization.requireCsrf(
                        request);


                Integer logoutUserId = null;

                Object userIdValue =
                        session.getAttribute("userId");

                if (userIdValue instanceof Integer) {

                    logoutUserId =
                            (Integer) userIdValue;
                }


                try {

                    session.invalidate();

                } catch (IllegalStateException ignored) {

                    // Session already invalidated.
                }


                response.sendRedirect(
                        buildModule1LogoutUrl(logoutUserId));

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


    /*
     * ============================================================
     * BUILD MODULE 1 LOGOUT REDIRECT
     * ============================================================
     *
     * Module 1 now requires a POST + CSRF for its own logout form,
     * but it also accepts a signed one-time token on GET. That is
     * what keeps cross-module logout working.
     */

    private String buildModule1LogoutUrl(
            Integer userId)
            throws IOException {

        String url =
                getServletContext()
                        .getInitParameter(
                                "module1LogoutUrl");

        if (url == null ||
                url.trim().isEmpty()) {

            url =
                    "http://localhost:8081/"
                    + "NLogisticsImportExport/"
                    + "app?action=logout";
        }


        String token;

        try {

            token = createLogoutToken(userId);

        } catch (SecurityException e) {

            throw e;

        } catch (Exception e) {

            throw new IOException(
                    "Unable to create logout token.",
                    e);
        }


        return url
                + (url.indexOf('?') >= 0 ? "&" : "?")
                + "logoutToken="
                + URLEncoder.encode(token, "UTF-8");
    }


    /*
     * ============================================================
     * CREATE CROSS-MODULE LOGOUT TOKEN
     * ============================================================
     *
     * Format: base64url(userId|issuedAt|nonce).signature
     */

    private String createLogoutToken(
            Integer userId)
            throws Exception {

        long issuedAt =
                System.currentTimeMillis();


        byte[] nonceBytes =
                new byte[16];

        RANDOM.nextBytes(nonceBytes);

        String nonce =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(nonceBytes);


        String payload =
                (userId == null
                        ? "0"
                        : String.valueOf(userId))
                + "|"
                + issuedAt
                + "|"
                + nonce;


        String encodedPayload =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(
                                payload.getBytes(
                                        StandardCharsets.UTF_8));


        return encodedPayload
                + "."
                + createSignature(encodedPayload);
    }


    private String createSignature(
            String payload)
            throws Exception {

        String sharedSecret =
                System.getenv("NLOGISTICS_SSO_SECRET");

        if (sharedSecret == null ||
                sharedSecret.trim().isEmpty()) {

            sharedSecret =
                    getServletContext()
                            .getInitParameter(
                                    "module3SharedSecret");
        }


        if (sharedSecret == null ||
                sharedSecret.trim().isEmpty()) {

            throw new SecurityException(
                    "SSO shared secret is not configured.");
        }


        Mac mac =
                Mac.getInstance("HmacSHA256");

        SecretKeySpec key =
                new SecretKeySpec(
                        sharedSecret.getBytes(
                                StandardCharsets.UTF_8),
                        "HmacSHA256");

        mac.init(key);


        byte[] signature =
                mac.doFinal(
                        payload.getBytes(
                                StandardCharsets.UTF_8));


        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(signature);
    }
}