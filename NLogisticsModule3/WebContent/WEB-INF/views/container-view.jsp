<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%@ page import="model.Container"%>

<%
    String role =
            (String) session.getAttribute("roleName");

    Container container =
            (Container) request.getAttribute("container");

    if (container == null) {
        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Container not found."
        );
        return;
    }

    boolean isCustomer =
            "Customer".equals(role);

    boolean canManage =
            "Super Admin".equals(role)
            || "Company Admin".equals(role);

    String companyName =
            (String) request.getAttribute("companyName");

    if (companyName == null ||
            companyName.trim().isEmpty()) {
        companyName = "—";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>N Logistics · Container Details</title>


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         STYLE
         ===================================================== -->

    <style>

        :root {

            --paper: #F0F2F1;
            --surface: #FFFFFF;

            --ink: #10202F;
            --ink-soft: #5C6A78;
            --ink-faint: #8B96A0;

            --line: #DFE3E2;

            --cargo: #D9622B;
            --cargo-dark: #BC4F20;
            --cargo-soft: #FBE7DB;

            --success: #2F7D53;

            --sidebar-width: 250px;
        }


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


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .nl-sidebar {

            position: fixed;

            left: 0;
            top: 0;

            width: var(--sidebar-width);

            height: 100vh;

            background: var(--ink);

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 1000;
        }


        /* =====================================================
           BRAND
           ===================================================== */

        .sidebar-brand {

            padding: 24px 22px;

            border-bottom:
                1px solid #33424E;
        }


        .brand-main {

            display: flex;

            align-items: center;

            color: white;

            text-decoration: none;

            font-size: 20px;

            font-weight: 700;
        }


        .brand-mark {

            width: 36px;
            height: 36px;

            display: inline-flex;

            align-items: center;
            justify-content: center;

            background: var(--cargo);

            color: white;

            margin-right: 10px;

            font-weight: 800;
        }


        .brand-subtitle {

            color: #AEB9C1;

            font-size: 10px;

            margin-top: 7px;

            margin-left: 46px;

            text-transform: uppercase;

            letter-spacing: 0.8px;
        }


        /* =====================================================
           SIDEBAR NAVIGATION
           ===================================================== */

        .sidebar-navigation {

            padding: 20px 12px;

            flex: 1;
        }


        .nav-label {

            color: #7F8C96;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.2px;

            padding:
                0 12px 9px;
        }


        .sidebar-link {

            display: flex;

            align-items: center;

            gap: 11px;

            width: 100%;

            padding:
                11px 12px;

            margin-bottom: 4px;

            color: #D7DEE3;

            text-decoration: none;

            font-size: 13px;

            font-weight: 600;

            border-left:
                3px solid transparent;

            transition:
                background 0.15s ease,
                color 0.15s ease,
                border-color 0.15s ease;
        }


        .sidebar-link:hover {

            color: white;

            background: #1C303F;

            border-left-color:
                var(--cargo);
        }


        .sidebar-link.active {

            color: white;

            background: #1C303F;

            border-left-color:
                var(--cargo);
        }


        .nav-icon {

            width: 25px;

            height: 25px;

            display: inline-flex;

            align-items: center;
            justify-content: center;

            border:
                1px solid #4A5965;

            font-size: 11px;

            flex-shrink: 0;
        }


        /* =====================================================
           SIDEBAR FOOTER
           ===================================================== */

        .sidebar-footer {

            border-top:
                1px solid #33424E;

            padding: 16px;
        }


        .role-label {

            color: #7F8C96;

            font-size: 9px;

            text-transform: uppercase;

            letter-spacing: 1px;

            margin-bottom: 5px;
        }


        .role-value {

            color: #E1E7EB;

            font-size: 12px;

            font-weight: 700;

            margin-bottom: 14px;
        }


        .logout-button {

            width: 100%;

            background: transparent;

            border:
                1px solid #566571;

            color: #E1E7EB;

            padding: 9px 12px;

            font-size: 11px;

            font-weight: 700;

            text-align: left;

            cursor: pointer;
        }


        .logout-button:hover {

            background: #1C303F;

            border-color: var(--cargo);

            color: white;
        }


        /* =====================================================
           MAIN AREA
           ===================================================== */

        .nl-main {

            margin-left:
                var(--sidebar-width);

            min-height: 100vh;
        }


        /* =====================================================
           TOP BAR
           ===================================================== */

        .nl-topbar {
            height: 72px;
            background: var(--surface);
            border-bottom: 1px solid var(--line);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
        }


        .topbar-title {

            font-size: 13px;

            font-weight: 700;

            color: var(--ink);
        }


        .topbar-context {

            color: var(--ink-soft);

            font-size: 11px;

            margin-top: 3px;
        }


        .topbar-role {

            border:
                1px solid var(--line);

            padding:
                7px 11px;

            color: var(--ink-soft);

            font-size: 11px;

            font-weight: 700;
        }


        /* =====================================================
           CONTENT
           ===================================================== */

        .nl-content {

            max-width: 1100px;

            margin: 0 auto;

            padding:
                36px 30px 60px;
        }


        /* =====================================================
           PAGE HEADER
           ===================================================== */

        .page-header {

            display: flex;

            justify-content:
                space-between;

            align-items:
                flex-start;

            gap: 20px;

            margin-bottom: 25px;
        }


        .page-kicker {

            color: var(--cargo);

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.4px;

            margin-bottom: 7px;
        }


        .page-title {

            margin: 0;

            font-size: 30px;

            font-weight: 750;

            letter-spacing: -0.4px;
        }


        .page-description {

            color: var(--ink-soft);

            font-size: 13px;

            margin:
                7px 0 0;

            line-height: 1.5;
        }


        /* =====================================================
           BUTTONS
           ===================================================== */

        .btn-back {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            background: white;

            border:
                1px solid var(--line);

            color: var(--ink);

            text-decoration: none;

            padding:
                10px 15px;

            font-size: 11px;

            font-weight: 700;

            white-space: nowrap;
        }


        .btn-back:hover {

            background: #F7F8F8;

            color: var(--ink);
        }


        .btn-edit {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            background: var(--cargo);

            border:
                1px solid var(--cargo);

            color: white;

            text-decoration: none;

            padding:
                10px 17px;

            font-size: 11px;

            font-weight: 700;
        }


        .btn-edit:hover {

            background: var(--cargo-dark);

            border-color: var(--cargo-dark);

            color: white;
        }


        /* =====================================================
           MAIN CARD
           ===================================================== */

        .container-card {

            background: var(--surface);

            border:
                1px solid var(--line);

            margin-bottom: 22px;

            overflow: hidden;
        }


        /* =====================================================
           IMAGE SECTION
           ===================================================== */

        .container-image-section {

            background: #E9ECEB;

            min-height: 330px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-bottom:
                1px solid var(--line);

            padding: 25px;
        }


        .container-image {

            max-width: 100%;

            max-height: 360px;

            width: auto;

            height: auto;

            object-fit: contain;

            display: block;
        }


        .image-placeholder {

            width: 100%;

            min-height: 280px;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            color: var(--ink-faint);
        }


        .placeholder-icon {

            width: 55px;

            height: 55px;

            display: flex;

            align-items: center;

            justify-content: center;

            border:
                1px solid #C9CFCD;

            background: white;

            color: var(--cargo);

            font-size: 22px;

            font-weight: 800;

            margin-bottom: 12px;
        }


        .placeholder-text {

            font-size: 12px;

            color: var(--ink-soft);
        }


        /* =====================================================
           DETAILS SECTION
           ===================================================== */

        .details-section {

            padding: 25px;
        }


        .details-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding-bottom: 18px;

            margin-bottom: 20px;

            border-bottom:
                1px solid var(--line);
        }


        .details-title {

            margin: 0;

            font-size: 18px;

            font-weight: 700;
        }


        .details-label {

            color: var(--ink-faint);

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            margin-bottom: 6px;
        }


        .details-value {

            color: var(--ink);

            font-size: 14px;

            font-weight: 600;
        }


        .details-number {

            font-size: 19px;

            font-weight: 800;

            letter-spacing: 0.2px;
        }


        .detail-box {

            padding:
                16px 17px;

            border:
                1px solid var(--line);

            background: #FAFBFB;

            height: 100%;
        }


        /* =====================================================
           STATUS
           ===================================================== */

        .status-badge {

            display: inline-block;

            padding:
                6px 10px;

            font-size: 10px;

            font-weight: 700;
        }


        .status-available {

            background: #EDF7F1;

            border:
                1px solid #B9D9C7;

            color: var(--success);
        }


        .status-allocated {

            background: #FFF4E9;

            border:
                1px solid #EAC9A5;

            color: #A35C18;
        }


        .status-in-transit {

            background: #EAF1F8;

            border:
                1px solid #BDD0E2;

            color: #315D82;
        }


        .status-maintenance {

            background: #FBE7DB;

            border:
                1px solid #E9BBA4;

            color: var(--cargo);
        }


        .status-default {

            background: #F1F3F3;

            border:
                1px solid var(--line);

            color: var(--ink-soft);
        }


        /* =====================================================
           CUSTOMER NOTE
           ===================================================== */

        .customer-note {

            margin-top: 22px;

            padding:
                15px 17px;

            background:
                var(--cargo-soft);

            border-left:
                3px solid var(--cargo);

            color: #704020;

            font-size: 12px;

            line-height: 1.6;
        }


        .customer-note strong {

            color: var(--ink);
        }


        /* =====================================================
           ACTION FOOTER
           ===================================================== */

        .card-actions {

            border-top:
                1px solid var(--line);

            padding:
                17px 25px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 12px;

            background: #FAFBFB;
        }


        .action-info {

            color: var(--ink-soft);

            font-size: 11px;
        }


        .action-buttons {

            display: flex;

            gap: 9px;

            flex-wrap: wrap;
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 900px) {

            :root {
                --sidebar-width: 210px;
            }

            .nl-topbar {
                padding: 0 20px;
            }

            .nl-content {
                padding:
                    28px 20px 50px;
            }
        }


        @media (max-width: 700px) {

            .nl-sidebar {

                position: relative;

                width: 100%;

                height: auto;
            }


            .sidebar-navigation {

                padding: 12px;
            }


            .sidebar-link {

                display: inline-flex;

                width: auto;

                margin-right: 4px;
            }


            .sidebar-footer {

                display: flex;

                align-items: center;

                justify-content: space-between;

                gap: 15px;
            }


            .role-value {

                margin-bottom: 0;
            }


            .logout-button {

                width: auto;
            }


            .nl-main {

                margin-left: 0;
            }


            .nl-topbar {

                height: auto;

                min-height: 65px;

                padding:
                    14px 18px;
            }


            .page-header {

                flex-direction: column;
            }


            .container-image-section {

                min-height: 240px;
            }


            .card-actions {

                align-items: flex-start;

                flex-direction: column;
            }
        }


        @media (max-width: 500px) {

            .nl-content {

                padding:
                    23px 14px 40px;
            }


            .page-title {

                font-size: 26px;
            }


            .details-section {

                padding: 18px;
            }


            .card-actions {

                padding:
                    15px 18px;
            }


            .details-heading {

                align-items: flex-start;

                flex-direction: column;

                gap: 10px;
            }
        }

    </style>

</head>


<body>


<!-- =====================================================
     SIDEBAR
     ===================================================== -->

<aside class="nl-sidebar">


    <!-- BRAND -->

    <div class="sidebar-brand">

        <a
            class="brand-main"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="brand-mark">
                N
            </span>

            Logistics

        </a>


        <div class="brand-subtitle">

            Import &amp; Export Management

        </div>

    </div>


    <!-- NAVIGATION -->

    <div class="sidebar-navigation">


        <div class="nav-label">
            Navigation
        </div>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="nav-icon">
                H
            </span>

            Dashboard

        </a>


        <a
            class="sidebar-link active"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="nav-icon">
                C
            </span>

            Containers

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing?action=view">

            <span class="nav-icon">
                P
            </span>

            Pricing

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/forecast?action=view">

            <span class="nav-icon">
                F
            </span>

            Demand Forecast

        </a>

    </div>


    <!-- SIDEBAR FOOTER -->

    <div class="sidebar-footer">


        <div>

            <div class="role-label">
                Signed in as
            </div>

            <div class="role-value">
                <%= role == null ? "" : role %>
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


                Logout

            </button>

        </form>

    </div>

</aside>


<!-- =====================================================
     MAIN
     ===================================================== -->

<div class="nl-main">


    <!-- =================================================
         TOP BAR
         ================================================= -->

    <header class="nl-topbar">

        <div class="topbar-title">
            Container Management
        </div>

        <div class="topbar-role">
            <%= role == null ? "" : role %>
        </div>

    </header>


    <!-- =================================================
         CONTENT
         ================================================= -->

    <main class="nl-content">


        <!-- =================================================
             PAGE HEADER
             ================================================= -->

        <div class="page-header">


            <div>

                <div class="page-kicker">
                    Container Management
                </div>


                <h1 class="page-title">
                    Container Details
                </h1>


                <p class="page-description">

                    View the complete information for this
                    logistics container.

                </p>

            </div>


            <!-- BACK -->

            <a
                class="btn-back"
                href="<%= request.getContextPath() %>/app?action=home">

                ← Back to Containers

            </a>

        </div>


        <!-- =================================================
             CONTAINER CARD
             ================================================= -->

        <section class="container-card">


            <!-- =================================================
                 IMAGE
                 ================================================= -->

            <div class="container-image-section">


                <% if (container.getImageUrl() != null &&
                       !container.getImageUrl().trim().isEmpty()) { %>


                    <img
                        class="container-image"
                        src="<%= request.getContextPath() %>/<%= container.getImageUrl() %>"
                        alt="Container image">


                <% } else { %>


                    <div class="image-placeholder">


                        <div class="placeholder-icon">
                            N
                        </div>


                        <div class="placeholder-text">

                            No container image available

                        </div>


                    </div>


                <% } %>


            </div>


            <!-- =================================================
                 DETAILS
                 ================================================= -->

            <div class="details-section">


                <div class="details-heading">


                    <div>

                        <div class="details-label">
                            Container Number
                        </div>

                        <h2 class="details-title details-number">

                            <%= container.getContainerNumber() %>

                        </h2>

                    </div>


                    <div>

                        <%
                            String status =
                                    container.getStatus();

                            String statusClass =
                                    "status-default";

                            if ("Available".equals(status)) {

                                statusClass =
                                        "status-available";

                            } else if ("Allocated".equals(status)) {

                                statusClass =
                                        "status-allocated";

                            } else if ("In-Transit".equals(status)) {

                                statusClass =
                                        "status-in-transit";

                            } else if ("Under Maintenance"
                                    .equals(status)) {

                                statusClass =
                                        "status-maintenance";
                            }
                        %>


                        <span
                            class="status-badge <%= statusClass %>">

                            <%= status %>

                        </span>

                    </div>

                </div>


                <!-- =================================================
                     DETAILS GRID
                     ================================================= -->

                <div class="row g-3">


                    <!-- TYPE -->

                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="details-label">
                                Container Type
                            </div>

                            <div class="details-value">

                                <%= container.getType() %>

                            </div>

                        </div>

                    </div>


                    <!-- COMPANY -->

                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="details-label">
                                Company
                            </div>

                            <div class="details-value">
                                <%= companyName %>
                            </div>

                        </div>

                    </div>


                    <!-- SIZE -->

                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="details-label">
                                Container Size
                            </div>

                            <div class="details-value">

                                <%= container.getSize() %>

                            </div>

                        </div>

                    </div>


                    <!-- GOODS CAPACITY KG -->

                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="details-label">
                                Goods Capacity
                            </div>

                            <div class="details-value">

                                <%= container.getGoodsCapacityKg() %>
                                kg

                            </div>

                        </div>

                    </div>


                    <!-- GOODS CAPACITY CBM -->

                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="details-label">
                                Goods Volume Capacity
                            </div>

                            <div class="details-value">

                                <%= container.getGoodsCapacityCbm() %>
                                CBM

                            </div>

                        </div>

                    </div>


                    <!-- CURRENT PORT -->

                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="details-label">
                                Current Port
                            </div>

                            <div class="details-value">

                                <%= container.getCurrentPortId() %>

                            </div>

                        </div>

                    </div>


                    <!-- STATUS -->

                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="details-label">
                                Current Status
                            </div>

                            <div class="details-value">

                                <%= container.getStatus() %>

                            </div>

                        </div>

                    </div>


                    <% if (!isCustomer) { %>


                    <!-- TARE WEIGHT -->

                    <div class="col-md-6">

                        <div class="detail-box">

                            <div class="details-label">
                                Tare Weight
                            </div>

                            <div class="details-value">

                                <%= container.getTareWeightKg() %>
                                kg

                            </div>

                        </div>

                    </div>


                    <!-- MAX GROSS WEIGHT -->

                    <div class="col-md-6">

                        <div class="detail-box">

                            <div class="details-label">
                                Maximum Gross Weight
                            </div>

                            <div class="details-value">

                                <%= container.getMaxGrossWeightKg() %>
                                kg

                            </div>

                        </div>

                    </div>


                    <% } %>


                </div>


                <!-- =================================================
                     CUSTOMER NOTE
                     ================================================= -->

                <% if (isCustomer) { %>


                    <div class="customer-note">

                        <strong>Customer view:</strong>

                        Weight-related operational details are
                        not displayed in the customer view.

                    </div>


                <% } %>


            </div>


            <!-- =================================================
                 ACTION FOOTER
                 ================================================= -->

            <div class="card-actions">


                <div class="action-info">

                    Container information

                </div>


                <div class="action-buttons">


                    <!-- BACK -->

                    <a
                        class="btn-back"
                        href="<%= request.getContextPath() %>/app?action=home">

                        ← Back

                    </a>


                    <% if (canManage) { %>


                        <!-- EDIT -->

                        <a
                            class="btn-edit"
                            href="<%= request.getContextPath() %>/containers?action=edit&containerId=<%= container.getContainerId() %>">

                            Edit Container

                        </a>


                    <% } %>


                </div>

            </div>


        </section>


    </main>

</div>


<!-- =====================================================
     BOOTSTRAP JAVASCRIPT
     ===================================================== -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>