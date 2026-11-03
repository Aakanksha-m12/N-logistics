package controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/module3-sso")
public class Module3SSOController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * ============================================================
     * SSO TOKEN VALIDITY
     * ============================================================
     */

    private static final long TOKEN_VALIDITY_MILLIS =
            5L * 60L * 1000L;


    /*
     * ============================================================
     * GET
     * ============================================================
     */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processSSO(request, response);
    }


    /*
     * ============================================================
     * POST
     * ============================================================
     */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processSSO(request, response);
    }


    /*
     * ============================================================
     * PROCESS SSO
     * ============================================================
     */

    private void processSSO(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            /*
             * ====================================================
             * 1. READ TOKEN
             * ====================================================
             */

            String token =
                    request.getParameter("token");

            if (token == null ||
                    token.trim().isEmpty()) {

                throw new SecurityException(
                        "SSO token is missing.");
            }


            /*
             * ====================================================
             * 2. GET SHARED SECRET
             * ====================================================
             *
             * This is the same fallback secret used by
             * Module 1 Module3Action.
             */

            String sharedSecret =
                    getServletContext()
                            .getInitParameter(
                                    "module3SharedSecret");

            if (sharedSecret == null ||
                    sharedSecret.trim().isEmpty()) {

                sharedSecret =
                        "NLogistics_Module3_SSO_2026_SECRET_ChangeMe";
            }


            /*
             * ====================================================
             * 3. SPLIT TOKEN
             * ====================================================
             *
             * Format:
             *
             * encodedPayload.signature
             */

            String[] tokenParts =
                    token.split("\\.", 2);

            if (tokenParts.length != 2) {

                throw new SecurityException(
                        "Invalid SSO token format.");
            }


            String encodedPayload =
                    tokenParts[0];

            String encodedSignature =
                    tokenParts[1];


            /*
             * ====================================================
             * 4. VERIFY SIGNATURE
             * ====================================================
             */

            String expectedSignature =
                    createSignature(
                            encodedPayload,
                            sharedSecret);


            boolean signatureValid =
                    MessageDigest.isEqual(
                            expectedSignature.getBytes(
                                    StandardCharsets.UTF_8),
                            encodedSignature.getBytes(
                                    StandardCharsets.UTF_8)
                    );


            if (!signatureValid) {

                throw new SecurityException(
                        "Invalid SSO token signature.");
            }


            /*
             * ====================================================
             * 5. DECODE PAYLOAD
             * ====================================================
             */

            String payload;

            try {

                payload =
                        new String(
                                Base64.getUrlDecoder()
                                        .decode(
                                                encodedPayload),
                                StandardCharsets.UTF_8);

            } catch (IllegalArgumentException e) {

                throw new SecurityException(
                        "Invalid SSO payload encoding.");
            }


            /*
             * ====================================================
             * 6. SPLIT PAYLOAD
             * ====================================================
             *
             * Expected:
             *
             * userId|roleName|companyId|issuedAt|nonce
             */

            String[] values =
                    payload.split("\\|", -1);

            if (values.length != 5) {

                throw new SecurityException(
                        "Invalid SSO payload.");
            }


            String userIdText =
                    values[0];

            String roleName =
                    values[1];

            String companyIdText =
                    values[2];

            String issuedAtText =
                    values[3];

            String nonce =
                    values[4];


            /*
             * ====================================================
             * 7. VALIDATE NONCE
             * ====================================================
             */

            if (nonce == null ||
                    nonce.trim().isEmpty()) {

                throw new SecurityException(
                        "Invalid SSO nonce.");
            }


            /*
             * ====================================================
             * 8. USER ID
             * ====================================================
             */

            Integer userId;

            try {

                userId =
                        Integer.valueOf(
                                userIdText.trim());

            } catch (NumberFormatException e) {

                throw new SecurityException(
                        "Invalid user ID.");
            }


            if (userId <= 0) {

                throw new SecurityException(
                        "Invalid user ID.");
            }


            /*
             * ====================================================
             * 9. COMPANY ID
             * ====================================================
             *
             * Customers may have no company.
             */

            Long companyId =
                    null;

            if (companyIdText != null &&
                    !companyIdText.trim().isEmpty() &&
                    !"null".equalsIgnoreCase(
                            companyIdText.trim())) {

                try {

                    companyId =
                            Long.valueOf(
                                    companyIdText.trim());

                } catch (NumberFormatException e) {

                    throw new SecurityException(
                            "Invalid company ID.");
                }


                if (companyId <= 0) {

                    throw new SecurityException(
                            "Invalid company ID.");
                }
            }


            /*
             * ====================================================
             * 10. ISSUE TIME
             * ====================================================
             */

            long issuedAt;

            try {

                issuedAt =
                        Long.parseLong(
                                issuedAtText.trim());

            } catch (NumberFormatException e) {

                throw new SecurityException(
                        "Invalid SSO issue time.");
            }


            /*
             * ====================================================
             * 11. CHECK TOKEN EXPIRATION
             * ====================================================
             */

            long now =
                    System.currentTimeMillis();


            if (issuedAt > now) {

                throw new SecurityException(
                        "Invalid SSO issue time.");
            }


            if (now - issuedAt >
                    TOKEN_VALIDITY_MILLIS) {

                throw new SecurityException(
                        "SSO token has expired.");
            }


            /*
             * ====================================================
             * 12. NORMALIZE AND VALIDATE ROLE
             * ====================================================
             *
             * THIS IS THE IMPORTANT FIX.
             *
             * Module 1 may provide the role in a slightly
             * different format depending on the database value.
             *
             * We convert it to the exact Module 3 role constant.
             */

            String normalizedRole =
                    normalizeRole(roleName);


            if (normalizedRole == null) {

                /*
                 * Print the actual value in Eclipse Console.
                 *
                 * This is useful if the database contains a role
                 * name that is not one of the supported aliases.
                 */

                System.out.println(
                        "MODULE 3 SSO - RECEIVED ROLE = ["
                        + roleName
                        + "]"
                );


                throw new SecurityException(
                        "Invalid user role.");
            }


            /*
             * ====================================================
             * 13. CREATE NEW MODULE 3 SESSION
             * ====================================================
             */

            HttpSession oldSession =
                    request.getSession(false);


            if (oldSession != null) {

                try {

                    oldSession.invalidate();

                } catch (IllegalStateException e) {

                    /*
                     * Session was already invalidated.
                     */
                }
            }


            HttpSession session =
                    request.getSession(true);


            session.setMaxInactiveInterval(
                    30 * 60);


            /*
             * ====================================================
             * 14. STORE USER ID
             * ====================================================
             */

            session.setAttribute(
                    "userId",
                    userId);


            /*
             * ====================================================
             * 15. STORE NORMALIZED ROLE
             * ====================================================
             */

            session.setAttribute(
                    "roleName",
                    normalizedRole);


            /*
             * ====================================================
             * 16. STORE COMPANY ID
             * ====================================================
             */

            session.setAttribute(
                    "companyId",
                    companyId);


            /*
             * ====================================================
             * 17. CREATE CSRF TOKEN
             * ====================================================
             */

            String csrfToken =
                    Csrf.ensureToken(request);


            if (csrfToken == null ||
                    csrfToken.trim().isEmpty()) {

                throw new SecurityException(
                        "Unable to create CSRF token.");
            }


            /*
             * ====================================================
             * 18. DO NOT STORE SSO TOKEN
             * ====================================================
             *
             * The SSO token is used only for this authentication
             * request.
             */


            /*
             * ====================================================
             * 19. REDIRECT TO MODULE 3 HOME
             * ====================================================
             */

            response.sendRedirect(
                    request.getContextPath()
                            + "/app?action=home");


        } catch (SecurityException e) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "SSO authentication failed.");
        }
    }


    /*
     * ============================================================
     * CREATE HMAC-SHA256 SIGNATURE
     * ============================================================
     */

    private String createSignature(
            String payload,
            String sharedSecret)
            throws Exception {

        Mac mac =
                Mac.getInstance(
                        "HmacSHA256");


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
                .encodeToString(
                        signature);
    }


    /*
     * ============================================================
     * NORMALIZE ROLE
     * ============================================================
     *
     * Converts different possible representations into the
     * exact role names used by Module3Authorization.
     *
     * Examples:
     *
     * Customer
     * customer
     * CUSTOMER
     * customer_role
     *
     * -> Customer
     *
     *
     * Company Admin
     * company_admin
     * COMPANYADMIN
     *
     * -> Company Admin
     */

    private String normalizeRole(
            String roleName) {

        if (roleName == null) {

            return null;
        }


        String role =
                roleName.trim();


        if (role.isEmpty()) {

            return null;
        }


        /*
         * Convert to lowercase.
         */

        String normalized =
                role.toLowerCase();


        /*
         * Remove spaces, underscores, hyphens,
         * brackets and other punctuation.
         *
         * Examples:
         *
         * "Company Admin"
         * "company_admin"
         * "COMPANY-ADMIN"
         *
         * all become:
         *
         * companyadmin
         */

        normalized =
                normalized.replaceAll(
                        "[^a-z0-9]",
                        "");


        /*
         * ========================================================
         * SUPER ADMIN
         * ========================================================
         */

        if ("superadmin".equals(normalized)) {

            return Module3Authorization
                    .ROLE_SUPER_ADMIN;
        }


        /*
         * ========================================================
         * COMPANY ADMIN
         * ========================================================
         */

        if ("companyadmin".equals(normalized)) {

            return Module3Authorization
                    .ROLE_COMPANY_ADMIN;
        }


        /*
         * ========================================================
         * OPERATIONS
         * ========================================================
         *
         * Accept:
         *
         * Company Staff (Operations)
         * company_staff_operations
         * company staff operations
         * CompanyStaffOperations
         * operations
         */

        if ("companystaffoperations"
                .equals(normalized)
                ||
            "operations"
                .equals(normalized)
                ||
            "operationsstaff"
                .equals(normalized)) {

            return Module3Authorization
                    .ROLE_OPERATIONS;
        }


        /*
         * ========================================================
         * FINANCE
         * ========================================================
         *
         * Accept:
         *
         * Company Staff (Finance)
         * company_staff_finance
         * company staff finance
         * finance
         */

        if ("companystafffinance"
                .equals(normalized)
                ||
            "finance"
                .equals(normalized)
                ||
            "financestaff"
                .equals(normalized)) {

            return Module3Authorization
                    .ROLE_FINANCE;
        }


        /*
         * ========================================================
         * CUSTOMER
         * ========================================================
         */

        if ("customer".equals(normalized)
                || "customerconsumer".equals(normalized)
                || "consumer".equals(normalized)) {

            return Module3Authorization
                    .ROLE_CUSTOMER;
        }


        /*
         * ========================================================
         * UNKNOWN ROLE
         * ========================================================
         */

        return null;
    }
}