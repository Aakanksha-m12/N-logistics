package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Container;

@WebServlet("/allocation")
public class AllocationController extends HttpServlet {

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

        processRequest(request, response, false);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response, true);
    }

    /*
     * ============================================================
     * MAIN REQUEST PROCESSOR
     * ============================================================
     */
    private void processRequest(
            HttpServletRequest request,
            HttpServletResponse response,
            boolean postRequest)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        try {

            /*
             * ====================================================
             * LOGIN
             * ====================================================
             */
            Integer userId =
                    Module3Authorization.requireLogin(session);

            String role =
                    Module3Authorization.getRole(session);

            String action =
                    request.getParameter("action");

            if (action == null ||
                    action.trim().isEmpty()) {

                action = "view";
            }

            /*
             * ====================================================
             * CUSTOMER ALLOCATION INVENTORY
             * ====================================================
             *
             * Customer:
             *
             * 1. Selects an active company.
             * 2. Sees ONLY Available containers belonging to
             *    that company.
             */
            if ("customerView".equalsIgnoreCase(action)) {

                if (!Module3Authorization.ROLE_CUSTOMER.equals(role)) {

                    throw new SecurityException(
                            "Customer access required.");
                }

                /*
                 * Get active companies.
                 */
                List<model.Company> companies =
                        service.getActiveCompanies(userId);

                Long selectedCompanyId = null;

                String companyIdParameter =
                        request.getParameter("companyId");

                /*
                 * Company selected.
                 */
                if (companyIdParameter != null &&
                        !companyIdParameter.trim().isEmpty()) {

                    selectedCompanyId =
                            parseLong(
                                    companyIdParameter,
                                    "Company ID");

                    /*
                     * Verify that selected company exists
                     * and is active.
                     */
                    service.getCompany(
                            selectedCompanyId,
                            userId);
                }

                /*
                 * Initially no containers.
                 */
                List<Container> containers =
                        new ArrayList<Container>();

                /*
                 * Once company is selected,
                 * show ONLY Available containers of that company.
                 */
                if (selectedCompanyId != null) {

                    containers =
                            service.getAvailableContainersByCompany(
                                    selectedCompanyId,
                                    userId);
                }

                /*
                 * Get available route IDs for the
                 * allocation destination dropdown.
                 */
                List<Long> availableRouteIds =
                        service.getAvailableRouteIds(userId);

                request.setAttribute(
                        "companies",
                        companies);

                request.setAttribute(
                        "selectedCompanyId",
                        selectedCompanyId);

                request.setAttribute(
                        "containers",
                        containers);

                request.setAttribute(
                        "availableRouteIds",
                        availableRouteIds);

                request.setAttribute(
                        "role",
                        role);

                request.setAttribute(
                        "customerAllocation",
                        Boolean.TRUE);

                request.getRequestDispatcher(
                        "/WEB-INF/views/allocation.jsp")
                        .forward(
                                request,
                                response);

                return;
            }

            /*
             * ====================================================
             * 1. ALLOCATION INVENTORY
             * ====================================================
             */
            if ("view".equalsIgnoreCase(action)) {

                /*
                 * Customer uses the dedicated customer
                 * company-selection inventory.
                 */
                if (Module3Authorization.ROLE_CUSTOMER.equals(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/allocation?action=customerView");

                    return;
                }

                /*
                 * Existing staff allocation authorization.
                 */
                Module3Authorization.requireAllocation(session);

                List<Container> containers;

                /*
                 * ====================================================
                 * SUPER ADMIN
                 * ====================================================
                 */
                if (Module3Authorization
                        .ROLE_SUPER_ADMIN
                        .equals(role)) {

                    containers =
                            service.getAllContainers(userId);
                }

                /*
                 * ====================================================
                 * COMPANY ADMIN / OPERATIONS
                 * ====================================================
                 */
                else {

                    Long companyId =
                            Module3Authorization
                                    .getCompanyId(session);

                    if (companyId == null) {

                        throw new SecurityException(
                                "Company context is missing.");
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

                request.setAttribute(
                        "releaseOnly",
                        Boolean.FALSE);

                request.getRequestDispatcher(
                        "/WEB-INF/views/allocation.jsp")
                        .forward(
                                request,
                                response);

                return;
            }

            /*
             * ====================================================
             * 2. OPEN DEDICATED ALLOCATION PAGE
             * ====================================================
             *
             * Allowed:
             * - Super Admin
             * - Company Admin
             * - Operations
             * - Customer
             */
            if ("allocateView".equalsIgnoreCase(action)) {

                boolean customer =
                        Module3Authorization
                                .ROLE_CUSTOMER
                                .equals(role);

                boolean allowed =
                        Module3Authorization
                                .ROLE_SUPER_ADMIN
                                .equals(role)
                        || Module3Authorization
                                .ROLE_COMPANY_ADMIN
                                .equals(role)
                        || Module3Authorization
                                .ROLE_OPERATIONS
                                .equals(role)
                        || customer;

                if (!allowed) {

                    throw new SecurityException(
                            "You are not allowed to allocate containers.");
                }

                Long containerId =
                        parseLong(
                                request.getParameter("containerId"),
                                "Container ID");

                /*
                 * Load actual container from database.
                 */
                Container container =
                        service.getContainer(
                                containerId,
                                userId);

                if (container == null) {

                    throw new IllegalArgumentException(
                            "Container not found.");
                }

                /*
                 * Only Available containers can be allocated.
                 */
                if (!"Available".equalsIgnoreCase(
                        container.getStatus())) {

                    throw new IllegalArgumentException(
                            "Only Available containers can be allocated.");
                }

                /*
                 * ====================================================
                 * COMPANY SECURITY
                 * ====================================================
                 *
                 * Customer:
                 * Can select a container from any active company.
                 *
                 * Super Admin:
                 * Can allocate from any company.
                 *
                 * Company Admin / Operations:
                 * Only their own company's containers.
                 */
                if (!Module3Authorization
                        .ROLE_SUPER_ADMIN
                        .equals(role)
                        && !customer) {

                    Long sessionCompanyId =
                            Module3Authorization
                                    .getCompanyId(session);

                    if (sessionCompanyId == null) {

                        throw new SecurityException(
                                "Company context is missing.");
                    }

                    if (container.getOwnerCompanyId() == null ||
                            !sessionCompanyId.equals(
                                    container.getOwnerCompanyId())) {

                        throw new SecurityException(
                                "You cannot allocate another company's container.");
                    }
                }

                /*
                 * Get route IDs for the destination
                 * dropdown.
                 */
                List<Long> availableRouteIds =
                        service.getAvailableRouteIds(userId);

                request.setAttribute(
                        "container",
                        container);

                request.setAttribute(
                        "role",
                        role);

                request.setAttribute(
                        "customerAllocation",
                        Boolean.valueOf(customer));

                request.setAttribute(
                        "availableRouteIds",
                        availableRouteIds);

                request.getRequestDispatcher(
                        "/WEB-INF/views/container-allocation.jsp")
                        .forward(
                                request,
                                response);

                return;
            }

            /*
             * ====================================================
             * 3. ALLOCATE CONTAINER
             * ====================================================
             *
             * Allowed:
             * - Super Admin
             * - Company Admin
             * - Operations
             * - Customer
             */
            if ("allocate".equalsIgnoreCase(action)) {

                /*
                 * Allocation must always be POST.
                 */
                if (!postRequest) {

                    throw new SecurityException(
                            "Allocation requires POST.");
                }

                boolean customer =
                        Module3Authorization
                                .ROLE_CUSTOMER
                                .equals(role);

                boolean allowed =
                        Module3Authorization
                                .ROLE_SUPER_ADMIN
                                .equals(role)
                        || Module3Authorization
                                .ROLE_COMPANY_ADMIN
                                .equals(role)
                        || Module3Authorization
                                .ROLE_OPERATIONS
                                .equals(role)
                        || customer;

                if (!allowed) {

                    throw new SecurityException(
                            "You are not allowed to allocate containers.");
                }

                /*
                 * CSRF protection.
                 */
                Module3Authorization.requireCsrf(request);

                /*
                 * Read container ID.
                 */
                Long containerId =
                        parseLong(
                                request.getParameter("containerId"),
                                "Container ID");

                /*
                 * Read cargo weight.
                 */
                Double cargoWeightKg =
                        parseDouble(
                                request.getParameter("cargoWeightKg"),
                                "Cargo weight");

                /*
                 * Read cargo volume.
                 */
                Double cargoVolumeCbm =
                        parseDouble(
                                request.getParameter("cargoVolumeCbm"),
                                "Cargo volume");

                /*
                 * Read destination route.
                 */
                Long routeId =
                        parseLong(
                                request.getParameter("routeId"),
                                "Destination route");

                /*
                 * Verify that the selected route is available.
                 */
                List<Long> availableRouteIds =
                        service.getAvailableRouteIds(userId);

                if (availableRouteIds == null ||
                        !availableRouteIds.contains(routeId)) {

                    throw new IllegalArgumentException(
                            "Invalid destination route selected.");
                }

                /*
                 * ====================================================
                 * LOAD ACTUAL CONTAINER
                 * ====================================================
                 *
                 * Never trust company information coming
                 * from the browser.
                 */
                Container container =
                        service.getContainer(
                                containerId,
                                userId);

                if (container == null) {

                    throw new IllegalArgumentException(
                            "Container not found.");
                }

                /*
                 * Re-check availability on the server.
                 */
                if (!"Available".equalsIgnoreCase(
                        container.getStatus())) {

                    throw new IllegalArgumentException(
                            "Only Available containers can be allocated.");
                }

                Long companyId;

                /*
                 * ====================================================
                 * SUPER ADMIN
                 * ====================================================
                 *
                 * Super Admin can allocate a container
                 * belonging to any company.
                 */
                if (Module3Authorization
                        .ROLE_SUPER_ADMIN
                        .equals(role)) {

                    companyId =
                            container.getOwnerCompanyId();

                    if (companyId == null) {

                        throw new SecurityException(
                                "Container company information is missing.");
                    }
                }

                /*
                 * ====================================================
                 * CUSTOMER
                 * ====================================================
                 *
                 * Customer can choose any active company
                 * from the customer inventory.
                 *
                 * We DO NOT trust companyId from the browser.
                 *
                 * We get the company directly from the
                 * selected container in the database.
                 */
                else if (customer) {

                    companyId =
                            container.getOwnerCompanyId();

                    if (companyId == null) {

                        throw new SecurityException(
                                "Container company information is missing.");
                    }
                }

                /*
                 * ====================================================
                 * COMPANY ADMIN / OPERATIONS
                 * ====================================================
                 */
                else {

                    companyId =
                            Module3Authorization
                                    .getCompanyId(session);

                    if (companyId == null) {

                        throw new SecurityException(
                                "Company context is missing.");
                    }

                    /*
                     * Prevent allocating another company's
                     * container.
                     */
                    if (container.getOwnerCompanyId() == null ||
                            !companyId.equals(
                                    container.getOwnerCompanyId())) {

                        throw new SecurityException(
                                "You cannot allocate another company's container.");
                    }
                }

                /*
                 * ====================================================
                 * EXISTING MODULE 3 ALLOCATION
                 * ====================================================
                 *
                 * We are using the existing service method.
                 *
                 * No new table.
                 * No new field.
                 * No new interface.
                 */
                service.allocateContainer(
                        containerId,
                        cargoWeightKg,
                        cargoVolumeCbm,
                        userId,
                        companyId);

                /*
                 * ====================================================
                 * CUSTOMER SESSION TRACKING
                 * ====================================================
                 *
                 * The current database does not contain a
                 * customer-container allocation relationship.
                 *
                 * Therefore remember the successfully allocated
                 * container in the customer's current session.
                 */
                if (customer) {

                    Set<Long> allocatedContainerIds =
                            getCustomerAllocatedContainerIds(
                                    session);

                    allocatedContainerIds.add(
                            containerId);

                    session.setAttribute(
                            "customerAllocatedContainerIds",
                            allocatedContainerIds);
                }

                /*
                 * ====================================================
                 * SUCCESS
                 * ====================================================
                 */
                if (customer) {

                    /*
                     * Customer returns to the company-filtered
                     * available container list.
                     */
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/allocation?action=customerView"
                                    + "&companyId="
                                    + companyId
                                    + "&success=Container allocated successfully.");

                } else {

                    /*
                     * Existing staff flow remains unchanged.
                     */
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/allocation?action=view"
                                    + "&success=Container allocated successfully.");
                }

                return;
            }

            /*
             * ====================================================
             * 4. RELEASE INVENTORY
             * ====================================================
             */
            if ("releaseView".equalsIgnoreCase(action)) {

                boolean customer =
                        Module3Authorization
                                .ROLE_CUSTOMER
                                .equals(role);

                /*
                 * Customer can access release page.
                 *
                 * Staff still require normal container
                 * operations authorization.
                 */
                if (!customer) {

                    Module3Authorization
                            .requireContainerOperations(
                                    session);
                }

                List<Container> containers;

                /*
                 * ====================================================
                 * CUSTOMER
                 * ====================================================
                 *
                 * Customer sees ONLY containers allocated
                 * by this customer during the current session.
                 */
                if (customer) {

                    Set<Long> allocatedContainerIds =
                            getCustomerAllocatedContainerIds(
                                    session);

                    /*
                     * Get all containers from the existing
                     * Module 3 service.
                     *
                     * No database change is required.
                     */
                    List<Container> allContainers =
                            service.getAllContainers(userId);

                    containers =
                            new ArrayList<Container>();

                    for (Container container : allContainers) {

                        if (container == null ||
                                container.getContainerId() == null) {

                            continue;
                        }

                        /*
                         * Show only:
                         *
                         * 1. Container allocated by this customer
                         * 2. Container is currently Allocated
                         */
                        if (allocatedContainerIds.contains(
                                    container.getContainerId())
                                &&
                                "Allocated".equalsIgnoreCase(
                                    container.getStatus())) {

                            containers.add(container);
                        }
                    }
                }

                /*
                 * ====================================================
                 * SUPER ADMIN
                 * ====================================================
                 */
                else if (Module3Authorization
                        .ROLE_SUPER_ADMIN
                        .equals(role)) {

                    containers =
                            service.getAllContainers(userId);
                }

                /*
                 * ====================================================
                 * COMPANY ADMIN / OPERATIONS
                 * ====================================================
                 */
                else {

                    Long companyId =
                            Module3Authorization
                                    .getCompanyId(session);

                    if (companyId == null) {

                        throw new SecurityException(
                                "Company context is missing.");
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

                request.setAttribute(
                        "releaseOnly",
                        Boolean.TRUE);

                request.getRequestDispatcher(
                        "/WEB-INF/views/allocation.jsp")
                        .forward(
                                request,
                                response);

                return;
            }

            /*
             * ====================================================
             * 5. RELEASE CONTAINER
             * ====================================================
             */
            if ("release".equalsIgnoreCase(action)) {

                /*
                 * Release must always be POST.
                 */
                if (!postRequest) {

                    throw new SecurityException(
                            "Release requires POST.");
                }

                boolean customer =
                        Module3Authorization
                                .ROLE_CUSTOMER
                                .equals(role);

                /*
                 * Staff must have normal container
                 * operations authorization.
                 *
                 * Customer is checked separately below.
                 */
                if (!customer) {

                    Module3Authorization
                            .requireContainerOperations(
                                    session);
                }

                /*
                 * CSRF protection.
                 */
                Module3Authorization.requireCsrf(request);

                /*
                 * Read container ID.
                 */
                Long containerId =
                        parseLong(
                                request.getParameter("containerId"),
                                "Container ID");

                /*
                 * ====================================================
                 * CUSTOMER SECURITY CHECK
                 * ====================================================
                 *
                 * Customer can release ONLY a container that
                 * this customer's session remembers as allocated.
                 */
                if (customer) {

                    Set<Long> allocatedContainerIds =
                            getCustomerAllocatedContainerIds(
                                    session);

                    if (!allocatedContainerIds.contains(
                            containerId)) {

                        throw new SecurityException(
                                "You can release only containers you allocated.");
                    }
                }

                /*
                 * Load actual container from database.
                 */
                Container container =
                        service.getContainer(
                                containerId,
                                userId);

                if (container == null) {

                    throw new IllegalArgumentException(
                            "Container not found.");
                }

                /*
                 * Only Allocated containers can be released.
                 */
                if (!"Allocated".equalsIgnoreCase(
                        container.getStatus())) {

                    throw new IllegalArgumentException(
                            "Only Allocated containers can be released.");
                }

                Long companyId;

                /*
                 * ====================================================
                 * SUPER ADMIN
                 * ====================================================
                 */
                if (Module3Authorization
                        .ROLE_SUPER_ADMIN
                        .equals(role)) {

                    companyId =
                            container.getOwnerCompanyId();

                    if (companyId == null) {

                        throw new SecurityException(
                                "Container company information is missing.");
                    }
                }

                /*
                 * ====================================================
                 * CUSTOMER
                 * ====================================================
                 *
                 * Company is obtained directly from the
                 * actual database container.
                 */
                else if (customer) {

                    companyId =
                            container.getOwnerCompanyId();

                    if (companyId == null) {

                        throw new SecurityException(
                                "Container company information is missing.");
                    }
                }

                /*
                 * ====================================================
                 * COMPANY ADMIN / OPERATIONS
                 * ====================================================
                 */
                else {

                    companyId =
                            Module3Authorization
                                    .getCompanyId(session);

                    if (companyId == null) {

                        throw new SecurityException(
                                "Company context is missing.");
                    }

                    /*
                     * Prevent releasing another company's
                     * container.
                     */
                    if (container.getOwnerCompanyId() == null ||
                            !companyId.equals(
                                    container.getOwnerCompanyId())) {

                        throw new SecurityException(
                                "You cannot release another company's container.");
                    }
                }

                /*
                 * ====================================================
                 * EXISTING MODULE 3 RELEASE
                 * ====================================================
                 */
                service.releaseContainer(
                        containerId,
                        userId,
                        companyId);

                /*
                 * Remove successfully released container
                 * from customer's current session list.
                 */
                if (customer) {

                    Set<Long> allocatedContainerIds =
                            getCustomerAllocatedContainerIds(
                                    session);

                    allocatedContainerIds.remove(
                            containerId);

                    session.setAttribute(
                            "customerAllocatedContainerIds",
                            allocatedContainerIds);
                }

                /*
                 * ====================================================
                 * SUCCESS
                 * ====================================================
                 */
                response.sendRedirect(
                        request.getContextPath()
                                + "/allocation?action=releaseView"
                                + "&success=Container released successfully.");

                return;
            }

            /*
             * ====================================================
             * UNKNOWN ACTION
             * ====================================================
             */
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unknown allocation action.");

        } catch (SecurityException e) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage());

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process allocation request.");
        }
    }

    /*
     * ============================================================
     * CUSTOMER ALLOCATED CONTAINER SESSION
     * ============================================================
     *
     * The current database has no customer-container
     * allocation relationship.
     *
     * Therefore the current login session remembers the
     * containers allocated by that customer.
     */
    private Set<Long> getCustomerAllocatedContainerIds(
            HttpSession session) {

        Object existing =
                session.getAttribute(
                        "customerAllocatedContainerIds");

        if (existing instanceof Set<?>) {

            Set<?> existingSet =
                    (Set<?>) existing;

            Set<Long> result =
                    new HashSet<Long>();

            for (Object value : existingSet) {

                if (value instanceof Long) {

                    result.add(
                            (Long) value);
                }
            }

            return result;
        }

        return new HashSet<Long>();
    }

    /*
     * ============================================================
     * PARSE LONG
     * ============================================================
     */
    private Long parseLong(
            String value,
            String fieldName) {

        if (value == null ||
                value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName + " is required.");
        }

        try {

            return Long.valueOf(
                    value.trim());

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid " + fieldName + ".");
        }
    }

    /*
     * ============================================================
     * PARSE DOUBLE
     * ============================================================
     */
    private Double parseDouble(
            String value,
            String fieldName) {

        if (value == null ||
                value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName + " is required.");
        }

        try {

            Double number =
                    Double.valueOf(
                            value.trim());

            if (number.isNaN() ||
                    number.isInfinite()) {

                throw new IllegalArgumentException(
                        "Invalid " + fieldName + ".");
            }

            if (number < 0) {

                throw new IllegalArgumentException(
                        fieldName
                                + " cannot be negative.");
            }

            return number;

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid " + fieldName + ".");
        }
    }
}