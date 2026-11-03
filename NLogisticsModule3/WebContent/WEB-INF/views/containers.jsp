
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.Container"%>

<%
    /*
     * ============================================================
     * READ ROLE
     * ============================================================
     */

    String role =
            (String) request.getAttribute("role");

    if (role == null) {
        role = "";
    }


    /*
     * ============================================================
     * READ CONTAINERS
     * ============================================================
     */

    List<?> containerObjects =
            (List<?>) request.getAttribute("containers");

    List<Container> containers =
            new ArrayList<Container>();

    if (containerObjects != null) {

        for (Object object : containerObjects) {

            if (object instanceof Container) {

                containers.add(
                        (Container) object
                );
            }
        }
    }


    /*
     * ============================================================
     * ROLE FLAGS
     * ============================================================
     */

    boolean isSuperAdmin =
            "Super Admin".equals(role);

    boolean isCompanyAdmin =
            "Company Admin".equals(role);

    boolean isOperations =
            "Company Staff (Operations)".equals(role);

    boolean isFinance =
            "Company Staff (Finance)".equals(role);

    boolean isCustomer =
            "Customer".equals(role);


    /*
     * ============================================================
     * MANAGEMENT PERMISSION
     * ============================================================
     */

    boolean canManageContainers =
            isSuperAdmin ||
            isCompanyAdmin;

    String pageAction =
            request.getParameter("action");

    boolean managementPage =
            "manage".equalsIgnoreCase(pageAction);


    /*
     * ============================================================
     * CSRF TOKEN
     * ============================================================
     */

    String csrfToken =
            (String) session.getAttribute("csrfToken");

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>N Logistics | Container Catalog</title>


    <!-- ======================================================
         BOOTSTRAP
         ====================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- ======================================================
         PAGE STYLE
         ====================================================== -->

    <style>

        :root {

            --paper: #F0F2F1;

            --surface: #FFFFFF;

            --ink: #10202F;

            --ink-soft: #5C6A78;

            --ink-faint: #8B96A0;

            --orange: #D9622B;

            --orange-dark: #BD4F21;

            --green: #2F7D53;

            --amber: #A66A1E;

            --red: #B23A2E;

            --border: #DFE3E2;

            --soft-cargo: #FBE7DB;

        }


        /*
         * ======================================================
         * GLOBAL
         * ======================================================
         */

        * {

            box-sizing: border-box;

        }


        body {

            margin: 0;

            background: var(--paper);

            color: var(--ink);

            font-family:
                Arial,
                Helvetica,
                sans-serif;

        }


        /*
         * ======================================================
         * SIDEBAR
         * ======================================================
         */

        .nl-sidebar {

            position: fixed;

            left: 0;

            top: 0;

            bottom: 0;

            width: 245px;

            background: var(--ink);

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 1000;

        }


        /*
         * BRAND
         */

        .sidebar-brand {

            min-height: 90px;

            padding: 22px 20px;

            display: flex;

            align-items: center;

            border-bottom:
                1px solid #30404D;

        }


        .brand-mark {

            width: 40px;

            height: 40px;

            background: var(--orange);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 20px;

            font-weight: 800;

            margin-right: 11px;

        }


        .brand-name {

            font-size: 19px;

            font-weight: 700;

        }


        .brand-subtitle {

            color: #AEB9C2;

            font-size: 10px;

            margin-top: 2px;

        }


        /*
         * NAVIGATION
         */

        .sidebar-nav {

            padding: 25px 14px;

            flex: 1;

            overflow-y: auto;

        }


        .nav-section-title {

            color: #71808C;

            font-size: 10px;

            font-weight: 700;

            letter-spacing: 1.2px;

            padding:
                0 12px 9px;

        }


        .nav-section-space {

            margin-top: 25px;

        }


        .sidebar-link {

            display: flex;

            align-items: center;

            gap: 10px;

            padding:
                11px 12px;

            margin-bottom: 4px;

            color: #D7DEE3;

            text-decoration: none;

            font-size: 13px;

            font-weight: 600;

            border-left:
                3px solid transparent;

        }


        .sidebar-link:hover {

            background: #1B2D3B;

            color: white;

        }


        .sidebar-link.active {

            background: #1B2D3B;

            color: white;

            border-left-color:
                var(--orange);

        }


        .sidebar-icon {

            width: 22px;

            text-align: center;

            font-size: 15px;

        }


        /*
         * SIDEBAR BOTTOM
         */

        .sidebar-bottom {

            border-top:
                1px solid #30404D;

            padding:
                18px 14px;

        }


        .sidebar-role {

            padding:
                10px 10px 15px;

        }


        .role-label {

            color: #71808C;

            font-size: 9px;

            font-weight: 700;

            letter-spacing: 1px;

        }


        .role-name {

            color: #E4E9ED;

            font-size: 12px;

            font-weight: 600;

            margin-top: 5px;

            word-break: break-word;

        }


        /*
         * LOGOUT
         */

        .logout-form {

            margin: 0;

        }


        .logout-button {

            width: 100%;

            border:
                1px solid #465663;

            background: transparent;

            color: #D7DEE3;

            padding:
                10px 12px;

            display: flex;

            align-items: center;

            gap: 10px;

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

        }


        .logout-button:hover {

            background: #263A49;

            color: white;

        }


        /*
         * ======================================================
         * MAIN PAGE
         * ======================================================
         */

        .nl-page {

            margin-left: 245px;

            min-height: 100vh;

            background: var(--paper);

        }


        /*
         * ======================================================
         * TOP BAR
         * ======================================================
         */

        .nl-topbar {

            min-height: 72px;

            background: white;

            border-bottom:
                1px solid var(--border);

            padding:
                0 30px;

            display: flex;

            align-items: center;

            justify-content: space-between;

        }


        .topbar-kicker {

            color: var(--orange);

            font-size: 9px;

            font-weight: 800;

            letter-spacing: 1.5px;

        }


        .topbar-title {

            font-size: 16px;

            font-weight: 700;

            margin-top: 3px;

        }


        .topbar-right {

            display: flex;

            align-items: center;

        }


        .role-badge {

            background: var(--ink);

            color: white;

            padding:
                7px 11px;

            font-size: 11px;

            font-weight: 700;

        }


        /*
         * ======================================================
         * CONTENT
         * ======================================================
         */

        .nl-content {

            max-width: 1400px;

            margin: 0 auto;

            padding:
                35px 30px 60px;

        }


        /*
         * ======================================================
         * PAGE HEADER
         * ======================================================
         */

        .page-header {

            display: flex;

            justify-content:
                space-between;

            align-items:
                flex-end;

            gap: 20px;

            margin-bottom: 25px;

        }


        .page-kicker {

            color: var(--orange);

            font-size: 11px;

            font-weight: 800;

            text-transform: uppercase;

            letter-spacing: 1.4px;

            margin-bottom: 6px;

        }


        .page-title {

            font-size: 31px;

            font-weight: 750;

            margin:
                0 0 7px;

            color: var(--ink);

        }


        .page-description {

            color: var(--ink-soft);

            margin: 0;

            font-size: 13px;

        }


        /*
         * ======================================================
         * BACK BUTTON
         * ======================================================
         */

        .btn-back {

            background: white;

            border:
                1px solid var(--border);

            color: var(--ink);

            padding:
                9px 15px;

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

        }


        .btn-back:hover {

            background: var(--ink);

            color: white;

        }


        /*
         * ======================================================
         * PANEL
         * ======================================================
         */

        .nl-panel {

            background: var(--surface);

            border:
                1px solid var(--border);

            border-radius: 0;

            padding: 0;

            margin-bottom: 22px;

            overflow: hidden;

        }


        .panel-header {

            padding:
                18px 21px;

            border-bottom:
                1px solid var(--border);

        }


        .panel-body {

            padding:
                21px;

        }


        .panel-title {

            font-size: 17px;

            font-weight: 700;

            color: var(--ink);

        }


        .panel-description {

            color: var(--ink-soft);

            font-size: 11px;

            margin-top: 4px;

        }


        /*
         * ======================================================
         * FORM
         * ======================================================
         */

        .form-label {

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: .7px;

            color: var(--ink);

        }


        .form-control,
        .form-select {

            min-height: 42px;

            border:
                1px solid var(--border);

            border-radius: 0;

            font-size: 13px;

        }


        .form-control:focus,
        .form-select:focus {

            border-color:
                var(--orange);

            box-shadow:
                0 0 0 0.15rem
                rgba(217, 98, 43, .12);

        }


        /*
         * ======================================================
         * ORANGE BUTTON
         * ======================================================
         */

        .btn-nl {

            background: var(--orange);

            border:
                1px solid var(--orange);

            color: white;

            min-height: 42px;

            border-radius: 0;

            font-size: 12px;

            font-weight: 700;

        }


        .btn-nl:hover {

            background:
                var(--orange-dark);

            border-color:
                var(--orange-dark);

            color: white;

        }


        /*
         * ======================================================
         * SELECTED COMPANY
         * ======================================================
         */

        .selected-company {

            margin-top: 18px;

            padding:
                12px 15px;

            border-left:
                4px solid var(--orange);

            background:
                var(--soft-cargo);

        }


        .selected-label {

            display: block;

            color: var(--orange);

            font-size: 9px;

            font-weight: 800;

            letter-spacing: 1px;

            margin-bottom: 4px;

        }


        /*
         * ======================================================
         * COMPANY CONTEXT
         * ======================================================
         */

        .company-context {

            display: flex;

            align-items: center;

            gap: 13px;

            background: white;

            border:
                1px solid var(--border);

            padding:
                15px 18px;

            margin-bottom: 22px;

        }


        .context-icon {

            width: 35px;

            height: 35px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: var(--orange);

            color: white;

            font-weight: 800;

        }


        .context-title {

            font-size: 13px;

            font-weight: 700;

        }


        .context-text {

            color: var(--ink-soft);

            font-size: 11px;

            margin-top: 3px;

        }


        /*
         * ======================================================
         * MANAGEMENT HEADER
         * ======================================================
         */

        .management-header {

            display: flex;

            justify-content:
                space-between;

            align-items: center;

            gap: 15px;

            flex-wrap: wrap;

            padding:
                20px 21px;

            border-bottom:
                1px solid var(--border);

        }


        .management-header-text {

            color: var(--ink-soft);

            font-size: 11px;

            margin: 0;

        }


        /*
         * ======================================================
         * ADD BUTTON
         * ======================================================
         */

        .btn-add {

            display: inline-block;

            background:
                var(--orange);

            border:
                1px solid var(--orange);

            color: white;

            padding:
                10px 16px;

            text-decoration: none;

            font-size: 12px;

            font-weight: 700;

        }


        .btn-add:hover {

            background:
                var(--orange-dark);

            border-color:
                var(--orange-dark);

            color: white;

        }


        /*
         * ======================================================
         * TABLE
         * ======================================================
         */

        .table-responsive {

            width: 100%;

            overflow-x: auto;

        }


        .table {

            margin-bottom: 0;

        }


        .table thead th {

            background:
                var(--ink);

            color: white;

            border: none;

            padding:
                13px 12px;

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: .6px;

            white-space: nowrap;

        }


        .table tbody td {

            padding:
                13px 12px;

            border-bottom:
                1px solid var(--border);

            font-size: 12px;

            color: var(--ink);

        }


        .table tbody tr:hover {

            background: #F8F9F9;

        }


        .actions-column {

            min-width: 180px;

        }


        /*
         * ======================================================
         * IMAGE
         * ======================================================
         */

        .container-image {
    width: 150px;
    height: 100px;
    object-fit: cover;
    display: block;
    border: 1px solid var(--line);
    background: #F7F8F8;
    

        }


        .no-image {

            width: 75px;

            height: 55px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                var(--paper);

            border:
                1px solid var(--border);

            color: var(--ink-soft);

            font-size: 10px;

            text-align: center;

        }


        /*
         * ======================================================
         * STATUS
         * ======================================================
         */

        .status-badge {

            display: inline-block;

            padding:
                5px 9px;

            font-size: 10px;

            font-weight: 800;

            border-radius: 0;

        }


        .status-available {

            background: #E3F1E8;

            color: var(--green);

        }


        .status-allocated {

            background: var(--soft-cargo);

            color: var(--orange);

        }


        .status-transit {

            background: #FFF0D8;

            color: var(--amber);

        }


        .status-maintenance {

            background: #F8E2E0;

            color: var(--red);

        }


        /*
         * ======================================================
         * ACTION BUTTONS
         * ======================================================
         */

        .action-buttons {

            display: flex;

            flex-wrap: wrap;

            gap: 5px;

        }


        .btn-view {

            background: white;

            border:
                1px solid var(--border);

            color: var(--ink);

            font-weight: 700;

        }


        .btn-view:hover {

            background:
                var(--paper);

            color: var(--ink);

        }


        .btn-edit {

            background: #FFF0D8;

            border:
                1px solid #E8C88E;

            color: var(--amber);

            font-weight: 700;

        }


        .btn-edit:hover {

            background: #FBE4B9;

            color: var(--amber);

        }


        .btn-delete {

            background: #F8E2E0;

            border:
                1px solid #E2B5B0;

            color: var(--red);

            font-weight: 700;

        }


        .btn-delete:hover {

            background: #F1D0CD;

            color: var(--red);

        }


        /*
         * ======================================================
         * EMPTY STATE
         * ======================================================
         */

        .empty-state {

            text-align: center;

            padding:
                60px 20px;

        }


        .empty-icon {

            width: 45px;

            height: 45px;

            margin:
                0 auto 15px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                var(--soft-cargo);

            color:
                var(--orange);

            font-weight: 800;

        }


        .empty-state h5 {

            font-size: 16px;

            font-weight: 700;

            margin-bottom: 6px;

        }


        .empty-state p {

            color: var(--ink-soft);

            font-size: 12px;

            margin-bottom: 0;

        }


        /*
         * ======================================================
         * RESPONSIVE
         * ======================================================
         */

        @media (max-width: 900px) {

            .nl-sidebar {

                width: 205px;

            }


            .nl-page {

                margin-left: 205px;

            }


            .nl-content {

                padding:
                    25px 20px 45px;

            }


            .nl-topbar {

                padding:
                    0 20px;

            }

        }


        @media (max-width: 700px) {

            .nl-sidebar {

                position: relative;

                width: 100%;

                min-height: auto;

            }


            .sidebar-nav {

                overflow: visible;

            }


            .sidebar-bottom {

                border-top:
                    1px solid #30404D;

            }


            .nl-page {

                margin-left: 0;

            }


            .page-header {

                align-items:
                    flex-start;

                flex-direction:
                    column;

            }


            .nl-topbar {

                min-height: 65px;

            }


            .topbar-right {

                display: none;

            }

        }

    </style>

</head>


<body>


<!-- ========================================================= -->
<!-- SIDEBAR -->
<!-- ========================================================= -->

<div class="nl-sidebar">


    <!-- =====================================================
         BRAND
         ===================================================== -->

    <div class="sidebar-brand">


        <div class="brand-mark">
            N
        </div>


        <div>

            <div class="brand-name">
                Logistics
            </div>

            <div class="brand-subtitle">
                Import &amp; Export
            </div>

        </div>


    </div>



    <!-- =====================================================
         NAVIGATION
         ===================================================== -->

    <div class="sidebar-nav">


        <div class="nav-section-title">
            MAIN
        </div>


        <!-- DASHBOARD -->

        <a
            href="<%= request.getContextPath() %>/app?action=home"
            class="sidebar-link">

            <span class="sidebar-icon">
                &#8962;
            </span>

            <span>
                Dashboard
            </span>

        </a>



        <!-- CONTAINERS -->

        <a
            href="<%= request.getContextPath() %>/containers?action=view"
            class="sidebar-link active">

            <span class="sidebar-icon">
                &#9632;
            </span>

            <span>
                Containers
            </span>

        </a>



        <!-- PRICING -->

        <% if (isSuperAdmin
                || isCompanyAdmin
                || isFinance) { %>


            <a
                href="<%= request.getContextPath() %>/pricing?action=view"
                class="sidebar-link">

                <span class="sidebar-icon">
                    &#8377;
                </span>

                <span>
                    Pricing
                </span>

            </a>


        <% } %>



        <!-- DEMAND FORECAST -->

        <% if (isSuperAdmin
                || isCompanyAdmin) { %>


            <a
                href="<%= request.getContextPath() %>/forecast?action=view"
                class="sidebar-link">

                <span class="sidebar-icon">
                    &#8599;
                </span>

                <span>
                    Demand Forecast
                </span>

            </a>


        <% } %>



        <!-- ACCOUNT -->

        <div class="nav-section-title nav-section-space">
            ACCOUNT
        </div>



        <!-- BACK TO DASHBOARD -->

        <a
            href="<%= request.getContextPath() %>/app?action=home"
            class="sidebar-link">

            <span class="sidebar-icon">
                &#8592;
            </span>

            <span>
                Back to Dashboard
            </span>

        </a>


    </div>



    <!-- =====================================================
         SIDEBAR BOTTOM
         ===================================================== -->

    <div class="sidebar-bottom">


        <div class="sidebar-role">

            <div class="role-label">
                SIGNED IN AS
            </div>


            <div class="role-name">

                <%= role %>

            </div>

        </div>



        <!-- LOGOUT -->

        <form
            method="get"
            action="<%= request.getContextPath() %>/app"
            class="m-0">

            <input
                type="hidden"
                name="action"
                value="logout">

            <button
                type="submit"
                class="logout-button">



                <span class="sidebar-icon">
                    &#10132;
                </span>


                <span>
                    Logout
                </span>


            </button>

        </form>


    </div>


</div>



<!-- ========================================================= -->
<!-- MAIN PAGE -->
<!-- ========================================================= -->

<div class="nl-page">


    <!-- =====================================================
         TOP BAR
         ===================================================== -->

    <div class="nl-topbar">


        <div>

            <div class="topbar-kicker">
                N LOGISTICS
            </div>


            <div class="topbar-title">
                Container Management
            </div>

        </div>


        <div class="topbar-right">

            <span class="role-badge">

                <%= role %>

            </span>

        </div>


    </div>



    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="nl-content">


        <!-- =================================================
             PAGE HEADER
             ================================================= -->

        <div class="page-header">


            <div>

                <div class="page-kicker">
                    Fleet &amp; Equipment
                </div>


                <h1 class="page-title">
                    Container Catalog
                </h1>


                <p class="page-description">

                    View container availability, size,
                    cargo capacity and current status.

                </p>

            </div>



            <!-- BACK -->

            <div>

                <button
                    type="button"
                    class="btn-back"
                    onclick="window.location.href='<%= request.getContextPath() %>/app?action=home';">

                    &#8592; Back

                </button>

            </div>


        </div>



        <!-- =================================================
             COMPANY ADMIN / OPERATIONS
             ================================================= -->

      <% if (isCompanyAdmin || isOperations) { %>


            <div class="company-context">


                <div class="context-icon">
                    N
                </div>


                <div>


                    <div class="context-title">

                        Company Container Catalog

                    </div>


                    <div class="context-text">

                        Showing containers belonging to
                        your company.

                    </div>


                </div>


            </div>


        <% } %>



        <!-- =================================================
             CUSTOMER
             ================================================= -->

        <% if (isCustomer) { %>


            <div class="company-context">


                <div class="context-icon">
                    N
                </div>


                <div>


                    <div class="context-title">

                        Available Containers

                    </div>


                    <div class="context-text">

                        Containers currently available
                        for your booking.

                    </div>


                </div>


            </div>


        <% } %>



        <!-- =================================================
             CONTAINER PANEL
             ================================================= -->

        <div class="nl-panel">


            <!-- MANAGEMENT HEADER -->

            <div class="management-header">


                <div>


                    <% if (managementPage && canManageContainers) { %>


                        <div class="panel-title mb-1">

                            Manage Containers

                        </div>


                        <p class="management-header-text">

                            Add, view, update or delete
                            containers.

                        </p>


                    <% } else { %>


                        <div class="panel-title mb-1">

                            Container List

                        </div>


                        <p class="management-header-text">

                            View container information
                            and availability.

                        </p>


                    <% } %>


                </div>



                <!-- ADD CONTAINER -->

                <% if (managementPage && canManageContainers) { %>


                    <a
                        href="<%= request.getContextPath() %>/containers?action=addForm"
                        class="btn-add">

                        + Add Container

                    </a>


                <% } %>


            </div>



            <!-- =================================================
                 NO CONTAINERS
                 ================================================= -->

            <% if (containers.isEmpty()) { %>


                <div class="empty-state">


                    <div class="empty-icon">
                        N
                    </div>


                    <h5>
                        No containers found
                    </h5>


                    <p>

                        There are currently no containers
                        available for this view.

                    </p>



                    <% if (managementPage && canManageContainers) { %>


                        <a
                            href="<%= request.getContextPath() %>/containers?action=addForm"
                            class="btn-add empty-button">

                            + Add First Container

                        </a>


                    <% } %>


                </div>



            <!-- =================================================
                 CONTAINER TABLE
                 ================================================= -->

            <% } else { %>


                <div class="table-responsive">


                    <table
                        class="table table-hover align-middle">


                        <thead>


                            <tr>


                                <th>
                                    Image
                                </th>


                                <th>
                                    Container No.
                                </th>


                                <th>
                                    Type
                                </th>


                                <th>
                                    Size
                                </th>


                                <th>
                                    Goods Capacity (kg)
                                </th>


                                <th>
                                    Goods Capacity (CBM)
                                </th>


                                <th>
                                    Status
                                </th>


                                <th>
                                    Port
                                </th>


                                <% if (managementPage && canManageContainers) { %>


                                    <th
                                        class="actions-column">

                                        Actions

                                    </th>


                                <% } else { %>


                                    <th
                                        class="actions-column">

                                        View

                                    </th>


                                <% } %>


                            </tr>


                        </thead>



                        <tbody>


                            <% for (Container container :
                                    containers) { %>


                                <tr>


                                    <!-- IMAGE -->

                                    <td>


                                        <% if (
                                            container.getImageUrl() != null
                                            &&
                                            !container.getImageUrl()
                                                .trim()
                                                .isEmpty()) { %>


                                            <img
                                                src="<%= request.getContextPath() %>/<%= container.getImageUrl() %>"
                                                class="container-image"
                                                alt="Container image">


                                        <% } else { %>


                                            <div class="no-image">

                                                No image

                                            </div>


                                        <% } %>


                                    </td>



                                    <!-- CONTAINER NUMBER -->

                                    <td>


                                        <strong>

                                            <%= container.getContainerNumber() %>

                                        </strong>


                                    </td>



                                    <!-- TYPE -->

                                    <td>

                                        <%= container.getType() %>

                                    </td>



                                    <!-- SIZE -->

                                    <td>

                                        <%= container.getSize() %>

                                    </td>



                                    <!-- KG -->

                                    <td>

                                        <%= container.getGoodsCapacityKg() %>

                                    </td>



                                    <!-- CBM -->

                                    <td>

                                        <%= container.getGoodsCapacityCbm() %>

                                    </td>



                                    <!-- STATUS -->

                                    <td>


                                        <%

                                            String status =
                                                    container.getStatus();


                                            String statusClass =
                                                    "status-available";


                                            if ("Allocated"
                                                    .equals(status)) {

                                                statusClass =
                                                    "status-allocated";

                                            } else if (
                                                    "In-Transit"
                                                    .equals(status)) {

                                                statusClass =
                                                    "status-transit";

                                            } else if (
                                                    "Under Maintenance"
                                                    .equals(status)) {

                                                statusClass =
                                                    "status-maintenance";

                                            }

                                        %>


                                        <span
                                            class="status-badge <%= statusClass %>">

                                            <%= status %>

                                        </span>


                                    </td>



                                    <!-- PORT -->

                                    <td>


                                        <%= container.getCurrentPortId()
                                                == null
                                            ? "-"
                                            : container.getCurrentPortId() %>


                                    </td>



                                    <!-- ACTIONS -->

                                    <td>


                                        <div class="action-buttons">


                                            <!-- VIEW -->

                                            <a
                                                href="<%= request.getContextPath() %>/containers?action=viewOne&containerId=<%= container.getContainerId() %>"
                                                class="btn btn-sm btn-view">

                                                View

                                            </a>



                                            <% if (managementPage && canManageContainers) { %>


                                                <!-- EDIT -->

                                                <a
                                                    href="<%= request.getContextPath() %>/containers?action=edit&containerId=<%= container.getContainerId() %>"
                                                    class="btn btn-sm btn-edit">

                                                    Edit

                                                </a>



                                                <!-- DELETE -->

                                                <form
                                                    method="post"
                                                    action="<%= request.getContextPath() %>/containers"
                                                    style="display:inline;"
                                                    onsubmit="return confirmDelete('<%= container.getContainerNumber() %>');">


                                                    <input
                                                        type="hidden"
                                                        name="action"
                                                        value="delete">


                                                    <input
                                                        type="hidden"
                                                        name="containerId"
                                                        value="<%= container.getContainerId() %>">



                                                    <input
                                                        type="hidden"
                                                        name="csrfToken"
                                                        value="<%= csrfToken == null
                                                            ? ""
                                                            : csrfToken %>">


                                                    <button
                                                        type="submit"
                                                        class="btn btn-sm btn-delete">

                                                        Delete

                                                    </button>


                                                </form>


                                            <% } %>


                                        </div>


                                    </td>


                                </tr>


                            <% } %>


                        </tbody>


                    </table>


                </div>


            <% } %>


        </div>


    </main>


</div>



<!-- ========================================================= -->
<!-- DELETE CONFIRMATION -->
<!-- ========================================================= -->

<script>

    function confirmDelete(containerNumber) {

        return confirm(
            "Are you sure you want to delete container "
            + containerNumber
            + "?\n\n"
            + "This action cannot be undone."
        );

    }

</script>



<!-- ========================================================= -->
<!-- BOOTSTRAP JAVASCRIPT -->
<!-- ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>

