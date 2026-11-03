package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.Company;
import model.Container;

@WebServlet("/containers")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class ContainerController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Module3Service service = new Module3Service();

    /* ============================================================
     * INIT
     * ============================================================ */

    @Override
    public void init() throws ServletException {
        super.init();
    }

    /* ============================================================
     * GET
     * ============================================================ */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        handleRequest(request, response, false);
    }

    /* ============================================================
     * POST
     * ============================================================ */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        handleRequest(request, response, true);
    }

    /* ============================================================
     * HANDLE REQUEST
     * ============================================================ */

    private void handleRequest(
            HttpServletRequest request,
            HttpServletResponse response,
            boolean postRequest)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        try {

            Module3Authorization.requireLogin(session);

            /*
             * CSRF protection for POST requests.
             */
            if (postRequest) {
                Module3Authorization.requireCsrf(request);
            }

            String action = request.getParameter("action");

            if (action == null || action.trim().isEmpty()) {
                action = "view";
            }

            /* =====================================================
             * VIEW ALL CONTAINERS
             * ===================================================== */

            if ("view".equals(action)) {

                viewContainers(request, response, session);
                return;
            }

            /* =====================================================
             * VIEW ONE CONTAINER
             * ===================================================== */

            if ("viewOne".equals(action)) {

                viewOneContainer(request, response, session);
                return;
            }

            /* =====================================================
             * MANAGE CONTAINERS
             * ===================================================== */

            if ("manage".equals(action)) {

                manageContainers(request, response, session);
                return;
            }

            /* =====================================================
             * ADD FORM
             * ===================================================== */

            if ("addForm".equals(action)) {

                showAddForm(request, response, session);
                return;
            }

            /* =====================================================
             * ADD CONTAINER
             * ===================================================== */

            if ("add".equals(action)) {

                requirePost(postRequest);

                addContainer(request, response, session);
                return;
            }

            /* =====================================================
             * EDIT FORM
             * ===================================================== */

            if ("edit".equals(action)) {

                showEditForm(request, response, session);
                return;
            }

            /* =====================================================
             * UPDATE CONTAINER
             * ===================================================== */

            if ("update".equals(action)) {

                requirePost(postRequest);

                updateContainer(request, response, session);
                return;
            }

            /* =====================================================
             * DELETE CONTAINER
             * ===================================================== */

            if ("delete".equals(action)) {

                requirePost(postRequest);

                deleteContainer(request, response, session);
                return;
            }

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unknown container action."
            );

        } catch (SecurityException e) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage()
            );

        } catch (IllegalArgumentException e) {

            /*
             * Validation error while adding.
             */
            if (postRequest
                    && "add".equals(
                            request.getParameter("action"))) {

                request.setAttribute(
                        "errorMessage",
                        e.getMessage()
                );

                try {

                    request.getRequestDispatcher(
                            "/WEB-INF/views/container-add.jsp"
                    ).forward(
                            request,
                            response
                    );

                } catch (Exception reloadException) {

                    reloadException.printStackTrace();

                    response.sendError(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Unable to reload Add Container page."
                    );
                }

                return;
            }

            /*
             * Validation error while updating.
             */
            if (postRequest
                    && "update".equals(
                            request.getParameter("action"))) {

                request.setAttribute(
                        "errorMessage",
                        e.getMessage()
                );

                try {

                    Long containerId =
                            parseLong(
                                    request.getParameter(
                                            "containerId"
                                    )
                            );

                    if (containerId != null) {

                        Integer userId =
                                Module3Authorization
                                        .requireLogin(session);

                        Container existing =
                                service.getContainer(
                                        containerId,
                                        userId
                                );

                        request.setAttribute(
                                "container",
                                existing
                        );
                    }

                    request.getRequestDispatcher(
                            "/WEB-INF/views/container-update.jsp"
                    ).forward(
                            request,
                            response
                    );

                } catch (Exception reloadException) {

                    reloadException.printStackTrace();

                    response.sendError(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Unable to reload Update Container page."
                    );
                }

                return;
            }

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process container request."
            );
        }
    }

    /* ============================================================
     * VIEW CONTAINERS
     * ============================================================ */

    private void viewContainers(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        Module3Authorization.requireAnyRole(
                session,
                Module3Authorization.ROLE_SUPER_ADMIN,
                Module3Authorization.ROLE_COMPANY_ADMIN,
                Module3Authorization.ROLE_OPERATIONS,
                Module3Authorization.ROLE_CUSTOMER
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        String role =
                Module3Authorization.getRole(session);

        List<Container> containers =
                new ArrayList<Container>();

        /*
         * CUSTOMER
         */
        if (Module3Authorization.ROLE_CUSTOMER
                .equals(role)) {

            request.setAttribute(
                    "role",
                    role
            );

            Csrf.ensureToken(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/no-allocated-container.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        /*
         * SUPER ADMIN
         */
        if (Module3Authorization.ROLE_SUPER_ADMIN
                .equals(role)) {

            containers =
                    service.getAllContainers(userId);
        }

        /*
         * COMPANY ADMIN / OPERATIONS
         */
        else {

            Long companyId =
                    Module3Authorization.getCompanyId(session);

            if (companyId == null) {

                throw new SecurityException(
                        "Company information not found."
                );
            }

            Company selectedCompany =
                    service.getCompany(
                            companyId,
                            userId
                    );

            if (selectedCompany == null) {

                throw new SecurityException(
                        "Company not found."
                );
            }

            request.setAttribute(
                    "selectedCompanyId",
                    companyId
            );

            request.setAttribute(
                    "selectedCompany",
                    selectedCompany
            );

            containers =
                    service.getContainersByCompany(
                            companyId,
                            userId
                    );
        }

        if (containers == null) {

            containers =
                    new ArrayList<Container>();
        }

        request.setAttribute(
                "containers",
                containers
        );

        request.setAttribute(
                "role",
                role
        );

        Csrf.ensureToken(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/containers.jsp"
        ).forward(
                request,
                response
        );
    }

    /* ============================================================
     * VIEW ONE CONTAINER
     * ============================================================ */

    private void viewOneContainer(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        Long containerId =
                parseRequiredLong(
                        request.getParameter("containerId"),
                        "containerId"
                );

        Module3Authorization.requireAnyRole(
                session,
                Module3Authorization.ROLE_SUPER_ADMIN,
                Module3Authorization.ROLE_COMPANY_ADMIN,
                Module3Authorization.ROLE_OPERATIONS,
                Module3Authorization.ROLE_CUSTOMER
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        Container container =
                service.getContainer(
                        containerId,
                        userId
                );

        if (container == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Container not found."
            );

            return;
        }

        request.setAttribute(
                "container",
                container
        );

        /*
         * Container currentPortId is already loaded by the
         * Container implementor from containers.current_port_id.
         *
         * We do not invent a port name here because the current
         * Java project does not contain a Port module.
         */
        if (container.getOwnerCompanyId() != null) {

            try {

                Company ownerCompany =
                        service.getCompany(
                                container.getOwnerCompanyId(),
                                userId
                        );

                if (ownerCompany != null) {

                    request.setAttribute(
                            "companyName",
                            ownerCompany.getCompanyName()
                    );
                }

            } catch (Exception ignored) {
                // Supplementary display information.
            }
        }

        request.setAttribute(
                "role",
                Module3Authorization.getRole(session)
        );

        Csrf.ensureToken(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/container-view.jsp"
        ).forward(
                request,
                response
        );
    }

    /* ============================================================
     * MANAGE CONTAINERS
     * ============================================================ */

    private void manageContainers(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        Module3Authorization.requireContainerManagement(
                session
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        String role =
                Module3Authorization.getRole(session);

        List<Container> containers;

        if (Module3Authorization.ROLE_SUPER_ADMIN
                .equals(role)) {

            containers =
                    service.getAllContainers(userId);

        } else {

            Long companyId =
                    Module3Authorization.getCompanyId(session);

            if (companyId == null) {

                throw new SecurityException(
                        "Company information not found."
                );
            }

            containers =
                    service.getContainersByCompany(
                            companyId,
                            userId
                    );
        }

        if (containers == null) {

            containers =
                    new ArrayList<Container>();
        }

        request.setAttribute(
                "containers",
                containers
        );

        request.setAttribute(
                "role",
                role
        );

        Csrf.ensureToken(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/containers.jsp"
        ).forward(
                request,
                response
        );
    }

    /* ============================================================
     * SHOW ADD FORM
     * ============================================================ */

    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        Module3Authorization.requireContainerManagement(
                session
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        String role =
                Module3Authorization.getRole(session);

        request.setAttribute(
                "role",
                role
        );

        /*
         * SUPER ADMIN
         *
         * Load active companies.
         */
        if (Module3Authorization.ROLE_SUPER_ADMIN
                .equals(role)) {

            List<Company> companies =
                    service.getActiveCompanies(userId);

            if (companies == null) {

                companies =
                        new ArrayList<Company>();
            }

            request.setAttribute(
                    "companies",
                    companies
            );

        } else {

            /*
             * COMPANY ADMIN
             *
             * Company comes from authenticated session.
             */
            Long companyId =
                    Module3Authorization.getCompanyId(session);

            if (companyId != null) {

                Company company =
                        service.getCompany(
                                companyId,
                                userId
                        );

                request.setAttribute(
                        "selectedCompanyId",
                        companyId
                );

                request.setAttribute(
                        "selectedCompany",
                        company
                );
            }
        }

        Csrf.ensureToken(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/container-add.jsp"
        ).forward(
                request,
                response
        );
    }

    /* ============================================================
     * ADD CONTAINER
     * ============================================================ */

    private void addContainer(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws Exception {

        Module3Authorization.requireContainerManagement(
                session
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        Company company =
                getAuthorizedCompany(
                        request,
                        session,
                        userId
                );

        if (company == null
                || company.getCompanyId() == null) {

            throw new SecurityException(
                    "Authorized company not found."
            );
        }

        Container container =
                buildContainer(request);

        container.setOwnerCompanyId(
                company.getCompanyId()
        );

        /*
         * Default current port for every new container.
         */
        container.setCurrentPortId(1L);

        /*
         * New containers start as Available.
         */
        container.setStatus(
                "Available"
        );

        service.addContainer(
                container,
                userId,
                company.getCompanyId()
        );

        response.sendRedirect(
                request.getContextPath()
                + "/containers?action=view"
        );
    }

    /* ============================================================
     * SAVE CONTAINER IMAGE
     * ============================================================ */

    private String saveContainerImage(
            HttpServletRequest request)
            throws IOException, ServletException {

        Part imagePart =
                request.getPart("imageFile");

        if (imagePart == null
                || imagePart.getSize() == 0) {

            return null;
        }

        if (imagePart.getSize()
                > 5L * 1024L * 1024L) {

            throw new IllegalArgumentException(
                    "Image size cannot exceed 5 MB."
            );
        }

        String submittedFileName =
                imagePart.getSubmittedFileName();

        if (submittedFileName == null
                || submittedFileName.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Invalid image file."
            );
        }

        String lowerName =
                submittedFileName.toLowerCase(
                        Locale.ENGLISH
                );

        String extension =
                getImageExtension(lowerName);

        if (extension == null) {

            throw new IllegalArgumentException(
                    "Only JPG, JPEG, PNG, WEBP and GIF images are allowed."
            );
        }

        String contentType =
                imagePart.getContentType();

        if (contentType == null) {

            throw new IllegalArgumentException(
                    "Invalid image type."
            );
        }

        String lowerContentType =
                contentType.toLowerCase(
                        Locale.ENGLISH
                );

        if (!lowerContentType.equals("image/jpeg")
                && !lowerContentType.equals("image/png")
                && !lowerContentType.equals("image/webp")
                && !lowerContentType.equals("image/gif")) {

            throw new IllegalArgumentException(
                    "Only JPG, JPEG, PNG, WEBP and GIF images are allowed."
            );
        }

        String fileName =
                UUID.randomUUID()
                        .toString()
                + extension;

        String applicationPath =
                request.getServletContext()
                        .getRealPath("");

        if (applicationPath == null) {

            throw new IOException(
                    "Unable to determine application path."
            );
        }

        File uploadDirectory =
                new File(
                        applicationPath,
                        "uploads"
                                + File.separator
                                + "containers"
                );

        if (!uploadDirectory.exists()) {

            if (!uploadDirectory.mkdirs()) {

                throw new IOException(
                        "Unable to create image upload directory."
                );
            }
        }

        File destination =
                new File(
                        uploadDirectory,
                        fileName
                );

        try (
                InputStream input =
                        imagePart.getInputStream();

                java.io.OutputStream output =
                        new java.io.FileOutputStream(
                                destination
                        )
        ) {

            byte[] buffer =
                    new byte[8192];

            int length;

            while (
                    (length =
                            input.read(buffer))
                    != -1
            ) {

                output.write(
                        buffer,
                        0,
                        length
                );
            }
        }

        return "uploads/containers/"
                + fileName;
    }

    /* ============================================================
     * GET IMAGE EXTENSION
     * ============================================================ */

    private String getImageExtension(
            String fileName) {

        if (fileName.endsWith(".jpg")) {
            return ".jpg";
        }

        if (fileName.endsWith(".jpeg")) {
            return ".jpeg";
        }

        if (fileName.endsWith(".png")) {
            return ".png";
        }

        if (fileName.endsWith(".webp")) {
            return ".webp";
        }

        if (fileName.endsWith(".gif")) {
            return ".gif";
        }

        return null;
    }

    /* ============================================================
     * SHOW EDIT FORM
     * ============================================================ */

    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        Module3Authorization.requireContainerManagement(
                session
        );

        Long containerId =
                parseRequiredLong(
                        request.getParameter("containerId"),
                        "containerId"
                );

        Integer userId =
                Module3Authorization.requireLogin(session);

        Container container =
                service.getContainer(
                        containerId,
                        userId
                );

        if (container == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Container not found."
            );

            return;
        }

        String role =
                Module3Authorization.getRole(session);

        if (!Module3Authorization.ROLE_SUPER_ADMIN
                .equals(role)) {

            Long companyId =
                    Module3Authorization.getCompanyId(session);

            if (companyId == null) {

                throw new SecurityException(
                        "Company information not found."
                );
            }

            if (container.getOwnerCompanyId() == null
                    || !companyId.equals(
                            container.getOwnerCompanyId()
                    )) {

                throw new SecurityException(
                        "You cannot edit another company's container."
                );
            }
        }

        request.setAttribute(
                "container",
                container
        );

        request.setAttribute(
                "role",
                role
        );

        Csrf.ensureToken(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/container-update.jsp"
        ).forward(
                request,
                response
        );
    }

    /* ============================================================
     * UPDATE CONTAINER
     * ============================================================ */

    private void updateContainer(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws Exception {

        Module3Authorization.requireContainerManagement(
                session
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        Long containerId =
                parseRequiredLong(
                        request.getParameter("containerId"),
                        "containerId"
                );

        /*
         * Read the existing database record first.
         *
         * This is important because current_port_id is an
         * existing system/location value and must not be lost
         * during an edit.
         */
        Container existing =
                service.getContainer(
                        containerId,
                        userId
                );

        if (existing == null) {

            throw new IllegalArgumentException(
                    "Container not found."
            );
        }

        String role =
                Module3Authorization.getRole(session);

        Long companyId;

        if (Module3Authorization.ROLE_SUPER_ADMIN
                .equals(role)) {

            /*
             * Super Admin never changes ownership during edit.
             */
            companyId =
                    existing.getOwnerCompanyId();

            if (companyId == null) {

                throw new SecurityException(
                        "Container owner company is missing."
                );
            }

        } else {

            companyId =
                    Module3Authorization.getCompanyId(
                            session
                    );

            if (companyId == null) {

                throw new SecurityException(
                        "Company information not found."
                );
            }

            if (existing.getOwnerCompanyId() == null
                    || !companyId.equals(
                            existing.getOwnerCompanyId()
                    )) {

                throw new SecurityException(
                        "You cannot update another company's container."
                );
            }
        }

        Container container =
                buildContainer(request);

        container.setContainerId(
                containerId
        );

        /*
         * Container number cannot be changed.
         */
        container.setContainerNumber(
                existing.getContainerNumber()
        );

        /*
         * Preserve owner company.
         */
        container.setOwnerCompanyId(
                companyId
        );

        /*
         * Preserve current status.
         *
         * Status is system-controlled and must not be reset
         * accidentally during an edit.
         */
        container.setStatus(
                existing.getStatus()
        );

        /*
         * ========================================================
         * IMPORTANT PORT FIX
         * ========================================================
         *
         * current_port_id represents the container's current
         * physical/location port.
         *
         * It is NOT origin_port_id.
         * It is NOT destination_port_id.
         *
         * During an edit, preserve the authoritative existing
         * currentPortId from the database.
         *
         * We do NOT ask the user to type a port ID.
         */
        container.setCurrentPortId(
                existing.getCurrentPortId()
        );

        /*
         * If no new image was selected,
         * preserve the old image.
         */
        if (container.getImageUrl() == null
                || container.getImageUrl().trim().isEmpty()) {

            container.setImageUrl(
                    existing.getImageUrl()
            );
        }

        service.updateContainer(
                container,
                userId,
                companyId
        );

        response.sendRedirect(
                request.getContextPath()
                + "/containers?action=manage"
        );
    }

    /* ============================================================
     * DELETE CONTAINER
     * ============================================================ */

    private void deleteContainer(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws Exception {

        Module3Authorization.requireContainerManagement(
                session
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        Long containerId =
                parseRequiredLong(
                        request.getParameter("containerId"),
                        "containerId"
                );

        Container existing =
                service.getContainer(
                        containerId,
                        userId
                );

        if (existing == null) {

            throw new IllegalArgumentException(
                    "Container not found."
            );
        }

        String role =
                Module3Authorization.getRole(session);

        Long companyId;

        if (Module3Authorization.ROLE_SUPER_ADMIN
                .equals(role)) {

            companyId =
                    existing.getOwnerCompanyId();

        } else {

            companyId =
                    Module3Authorization.getCompanyId(
                            session
                    );

            if (companyId == null) {

                throw new SecurityException(
                        "Company information not found."
                );
            }

            if (existing.getOwnerCompanyId() == null
                    || !companyId.equals(
                            existing.getOwnerCompanyId()
                    )) {

                throw new SecurityException(
                        "You cannot delete another company's container."
                );
            }
        }

        service.deleteContainer(
                existing,
                userId,
                companyId
        );

        response.sendRedirect(
                request.getContextPath()
                + "/containers?action=manage"
        );
    }

    /* ============================================================
     * BUILD CONTAINER
     * ============================================================ */

    private Container buildContainer(
            HttpServletRequest request)
            throws IOException, ServletException {

        Container container =
                new Container();

        /* ========================================================
         * CONTAINER NUMBER
         * ======================================================== */

        String containerNumber =
                trim(
                        request.getParameter(
                                "containerNumber"
                        )
                );

        if (containerNumber == null
                || containerNumber.isEmpty()) {

            throw new IllegalArgumentException(
                    "Container number is required."
            );
        }

        container.setContainerNumber(
                containerNumber
        );

        /* ========================================================
         * CONTAINER TYPE
         * ======================================================== */

        String type =
                trim(
                        request.getParameter(
                                "type"
                        )
                );

        if (!isValidType(type)) {

            throw new IllegalArgumentException(
                    "Please select a valid container type."
            );
        }

        container.setType(
                type
        );

        /* ========================================================
         * CONTAINER SIZE
         * ======================================================== */

        String size =
                trim(
                        request.getParameter(
                                "size"
                        )
                );

        if (!isValidSize(size)) {

            throw new IllegalArgumentException(
                    "Please select a valid container size."
            );
        }

        container.setSize(
                size
        );

        /* ========================================================
         * TARE WEIGHT
         * ======================================================== */

        Double tareWeight =
                parseRequiredDouble(
                        request.getParameter(
                                "tareWeightKg"
                        ),
                        "Tare weight"
                );

        /* ========================================================
         * MAXIMUM GROSS WEIGHT
         * ======================================================== */

        Double maxGrossWeight =
                parseRequiredDouble(
                        request.getParameter(
                                "maxGrossWeightKg"
                        ),
                        "Maximum gross weight"
                );

        /* ========================================================
         * GOODS CAPACITY KG
         * ======================================================== */

        Double goodsCapacityKg =
                parseRequiredDouble(
                        request.getParameter(
                                "goodsCapacityKg"
                        ),
                        "Goods capacity"
                );

        /* ========================================================
         * GOODS CAPACITY CBM
         * ======================================================== */

        Double goodsCapacityCbm =
                parseRequiredDouble(
                        request.getParameter(
                                "goodsCapacityCbm"
                        ),
                        "Goods capacity in CBM"
                );

        /* ========================================================
         * BASIC VALIDATION
         * ======================================================== */

        if (tareWeight < 0) {

            throw new IllegalArgumentException(
                    "Tare weight cannot be negative."
            );
        }

        if (maxGrossWeight <= 0) {

            throw new IllegalArgumentException(
                    "Maximum gross weight must be greater than 0."
            );
        }

        if (goodsCapacityKg <= 0) {

            throw new IllegalArgumentException(
                    "Goods capacity must be greater than 0."
            );
        }

        if (goodsCapacityCbm <= 0) {

            throw new IllegalArgumentException(
                    "Goods capacity in CBM must be greater than 0."
            );
        }

        /* ========================================================
         * DECIMAL(10,2) VALIDATION
         * ======================================================== */

        validateDecimal10_2(
                tareWeight,
                "Tare weight"
        );

        validateDecimal10_2(
                maxGrossWeight,
                "Maximum gross weight"
        );

        validateDecimal10_2(
                goodsCapacityKg,
                "Goods capacity"
        );

        validateDecimal10_2(
                goodsCapacityCbm,
                "Goods capacity in CBM"
        );

        /* ========================================================
         * MAX GROSS WEIGHT VS TARE WEIGHT
         * ======================================================== */

        if (maxGrossWeight < tareWeight) {

            throw new IllegalArgumentException(
                    "Maximum gross weight cannot be less than tare weight."
            );
        }

        /* ========================================================
         * USABLE GROSS CAPACITY
         * ======================================================== */

        double usableCapacity =
                maxGrossWeight
                - tareWeight;

        if (goodsCapacityKg > usableCapacity) {

            throw new IllegalArgumentException(
                    "Goods capacity cannot exceed usable gross capacity. "
                    + "Maximum allowed: "
                    + formatNumber(
                            usableCapacity
                    )
                    + " kg."
            );
        }

        /* ========================================================
         * SET NUMERIC VALUES
         * ======================================================== */

        container.setTareWeightKg(
                tareWeight
        );

        container.setMaxGrossWeightKg(
                maxGrossWeight
        );

        container.setGoodsCapacityKg(
                goodsCapacityKg
        );

        container.setGoodsCapacityCbm(
                goodsCapacityCbm
        );

        /* ========================================================
         * IMAGE UPLOAD
         * ======================================================== */

        String imagePath =
                saveContainerImage(
                        request
                );

        if (imagePath != null) {

            container.setImageUrl(
                    imagePath
            );
        }

        /* ========================================================
         * STATUS
         * ======================================================== */

        container.setStatus(
                "Available"
        );

        return container;
    }

    /* ============================================================
     * DECIMAL(10,2) VALIDATION
     * ============================================================ */

    private void validateDecimal10_2(
            Double value,
            String fieldName) {

        if (value == null) {

            throw new IllegalArgumentException(
                    fieldName + " is required."
            );
        }

        BigDecimal decimal =
                BigDecimal.valueOf(value)
                        .stripTrailingZeros();

        int scale =
                Math.max(
                        decimal.scale(),
                        0
                );

        if (scale > 2) {

            throw new IllegalArgumentException(
                    fieldName
                    + " can have maximum 2 decimal places."
            );
        }

        BigDecimal maximum =
                new BigDecimal(
                        "99999999.99"
                );

        if (decimal.compareTo(
                    maximum
                ) > 0) {

            throw new IllegalArgumentException(
                    fieldName
                    + " cannot exceed 99,999,999.99."
            );
        }
    }

    /* ============================================================
     * FORMAT NUMBER
     * ============================================================ */

    private String formatNumber(
            double value) {

        BigDecimal decimal =
                BigDecimal.valueOf(value)
                        .setScale(
                                2,
                                java.math.RoundingMode.HALF_UP
                        )
                        .stripTrailingZeros();

        return decimal.toPlainString();
    }

    /* ============================================================
     * GET AUTHORIZED COMPANY
     * ============================================================ */

    private Company getAuthorizedCompany(
            HttpServletRequest request,
            HttpSession session,
            Integer userId) {

        String role =
                Module3Authorization.getRole(
                        session
                );

        /*
         * SUPER ADMIN
         *
         * Super Admin selects company.
         */
        if (Module3Authorization.ROLE_SUPER_ADMIN
                .equals(role)) {

            Long companyId =
                    parseRequiredLong(
                            request.getParameter(
                                    "companyId"
                            ),
                            "companyId"
                    );

            return service.getCompany(
                    companyId,
                    userId
            );
        }

        /*
         * COMPANY USERS
         *
         * Company ID comes from authenticated session.
         */
        Long companyId =
                Module3Authorization.getCompanyId(
                        session
                );

        if (companyId == null) {

            throw new SecurityException(
                    "Company information not found."
            );
        }

        return service.getCompany(
                companyId,
                userId
        );
    }

    /* ============================================================
     * REQUIRE POST
     * ============================================================ */

    private void requirePost(
            boolean postRequest) {

        if (!postRequest) {

            throw new SecurityException(
                    "This operation requires POST."
            );
        }
    }

    /* ============================================================
     * REQUIRED LONG
     * ============================================================ */

    private Long parseRequiredLong(
            String value,
            String fieldName) {

        String text =
                trim(value);

        if (text == null
                || text.isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName
                    + " is required."
            );
        }

        try {

            return Long.valueOf(text);

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    fieldName
                    + " must be a valid number."
            );
        }
    }

    /* ============================================================
     * PARSE LONG
     * ============================================================ */

    private Long parseLong(
            String value) {

        String text =
                trim(value);

        if (text == null
                || text.isEmpty()) {

            return null;
        }

        try {

            return Long.valueOf(text);

        } catch (NumberFormatException e) {

            return null;
        }
    }

    /* ============================================================
     * REQUIRED DOUBLE
     * ============================================================ */

    private Double parseRequiredDouble(
            String value,
            String fieldName) {

        String text =
                trim(value);

        if (text == null
                || text.isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName
                    + " is required."
            );
        }

        try {

            Double result =
                    Double.valueOf(text);

            if (result.isNaN()
                    || result.isInfinite()) {

                throw new NumberFormatException();
            }

            return result;

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    fieldName
                    + " must be a valid number."
            );
        }
    }

    /* ============================================================
     * TRIM
     * ============================================================ */

    private String trim(
            String value) {

        if (value == null) {
            return null;
        }

        return value.trim();
    }

    /* ============================================================
     * VALID TYPE
     * ============================================================ */

    private boolean isValidType(
            String type) {

        if (type == null) {
            return false;
        }

        return "Dry".equals(type)
                || "Reefer".equals(type)
                || "Open Top".equals(type)
                || "Flat Rack".equals(type)
                || "Tank".equals(type);
    }

    /* ============================================================
     * VALID SIZE
     * ============================================================ */

    private boolean isValidSize(
            String size) {

        if (size == null) {
            return false;
        }

        return "20ft".equals(size)
                || "40ft".equals(size)
                || "40ft HC".equals(size)
                || "45ft".equals(size);
    }
}