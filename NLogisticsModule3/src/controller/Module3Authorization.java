package controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class Module3Authorization {

    private Module3Authorization() {
    }

    public static final String ROLE_SUPER_ADMIN =
            "Super Admin";

    public static final String ROLE_COMPANY_ADMIN =
            "Company Admin";

    public static final String ROLE_OPERATIONS =
            "Company Staff (Operations)";

    public static final String ROLE_FINANCE =
            "Company Staff (Finance)";

    public static final String ROLE_CUSTOMER =
            "Customer";


    /*
     * ============================================================
     * LOGIN
     * ============================================================
     */

    public static Integer requireLogin(
            HttpSession session) {

        if (session == null ||
                session.getAttribute("userId") == null) {

            throw new SecurityException(
                    "Login required.");
        }

        Object userId =
                session.getAttribute("userId");

        if (userId instanceof Integer) {
            return (Integer) userId;
        }

        if (userId instanceof Long) {
            return ((Long) userId).intValue();
        }

        if (userId instanceof String) {

            try {
                return Integer.valueOf(
                        (String) userId);

            } catch (NumberFormatException e) {

                throw new SecurityException(
                        "Invalid login session.");
            }
        }

        throw new SecurityException(
                "Invalid login session.");
    }


    /*
     * ============================================================
     * CSRF
     * ============================================================
     */

    public static void requireCsrf(
            HttpServletRequest request) {

        if (request == null) {

            throw new SecurityException(
                    "Invalid request.");
        }

        if (!Csrf.isValid(request)) {

            throw new SecurityException(
                    "Invalid CSRF token.");
        }
    }


    /*
     * ============================================================
     * ROLE
     * ============================================================
     */

    public static String getRole(
            HttpSession session) {

        requireLogin(session);

        Object role =
                session.getAttribute("roleName");

        /*
         * Module 1 stores the authenticated role
         * in roleName.
         */
        if (role == null) {

            throw new SecurityException(
                    "User role is missing.");
        }

        String roleName =
                role.toString().trim();

        if (roleName.isEmpty()) {

            throw new SecurityException(
                    "User role is missing.");
        }

        return roleName;
    }


    /*
     * ============================================================
     * COMPANY ID
     * ============================================================
     */

    public static Long getCompanyId(
            HttpSession session) {

        requireLogin(session);

        Object companyId =
                session.getAttribute("companyId");

        if (companyId == null) {
            return null;
        }

        if (companyId instanceof Long) {
            return (Long) companyId;
        }

        if (companyId instanceof Integer) {

            return Long.valueOf(
                    ((Integer) companyId).longValue());
        }

        if (companyId instanceof String) {

            try {

                return Long.valueOf(
                        ((String) companyId).trim());

            } catch (NumberFormatException e) {

                throw new SecurityException(
                        "Invalid company context.");
            }
        }

        throw new SecurityException(
                "Invalid company context.");
    }


    /*
     * ============================================================
     * REQUIRE ROLE
     * ============================================================
     */

    public static void requireRole(
            HttpSession session,
            String requiredRole) {

        String actualRole =
                getRole(session);

        if (!requiredRole.equalsIgnoreCase(actualRole)) {

            throw new SecurityException(
                    "Access denied.");
        }
    }


    /*
     * ============================================================
     * REQUIRE ANY ROLE
     * ============================================================
     */

    public static void requireAnyRole(
            HttpSession session,
            String... allowedRoles) {

        String actualRole =
                getRole(session);

        for (String role : allowedRoles) {

            if (role != null &&
                    role.equalsIgnoreCase(actualRole)) {

                return;
            }
        }

        throw new SecurityException(
                "Access denied.");
    }


    /*
     * ============================================================
     * ROLE CHECK
     * ============================================================
     */

    public static boolean isRole(
            HttpSession session,
            String role) {

        if (session == null ||
                role == null) {

            return false;
        }

        Object actualRole =
                session.getAttribute("roleName");

        if (actualRole == null) {
            return false;
        }

        return role.equalsIgnoreCase(
                actualRole.toString().trim());
    }


    public static boolean isSuperAdmin(
            HttpSession session) {

        return isRole(
                session,
                ROLE_SUPER_ADMIN);
    }


    public static boolean isCompanyAdmin(
            HttpSession session) {

        return isRole(
                session,
                ROLE_COMPANY_ADMIN);
    }


    public static boolean isOperationsStaff(
            HttpSession session) {

        return isRole(
                session,
                ROLE_OPERATIONS);
    }


    public static boolean isFinanceStaff(
            HttpSession session) {

        return isRole(
                session,
                ROLE_FINANCE);
    }


    public static boolean isCustomer(
            HttpSession session) {

        return isRole(
                session,
                ROLE_CUSTOMER);
    }


    /*
     * ============================================================
     * CONTAINER MANAGEMENT
     * ============================================================
     */

    public static void requireContainerManagement(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN);
    }


    /*
     * ============================================================
     * CONTAINER OPERATIONS
     * ============================================================
     */

    public static void requireContainerOperations(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN,
                ROLE_OPERATIONS);
    }


    /*
     * ============================================================
     * ALLOCATION
     * ============================================================
     */

    public static void requireAllocation(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN,
                ROLE_OPERATIONS);
    }


    /*
     * ============================================================
     * PRICING MANAGEMENT
     * ============================================================
     */

    public static void requirePricingManagement(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN);
    }


    /*
     * ============================================================
     * PRICING VIEW
     * ============================================================
     */

    public static void requirePricingView(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN,
                ROLE_FINANCE);
    }


    /*
     * ============================================================
     * CUSTOMER FINAL PRICE
     * ============================================================
     */

    public static void requireCustomerFinalPrice(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN,
                ROLE_FINANCE,
                ROLE_CUSTOMER);
    }


    /*
     * ============================================================
     * PRICING AUDIT
     * ============================================================
     */

    public static void requirePricingAuditView(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN,
                ROLE_FINANCE);
    }


    /*
     * ============================================================
     * FORECAST
     * ============================================================
     */

    public static void requireForecastView(
            HttpSession session) {

        requireAnyRole(
                session,
                ROLE_SUPER_ADMIN,
                ROLE_COMPANY_ADMIN);
    }


    /*
     * ============================================================
     * CUSTOMER CONTAINER VIEW
     * ============================================================
     */

    public static void requireCustomerContainerView(
            HttpSession session) {

        requireRole(
                session,
                ROLE_CUSTOMER);
    }
}