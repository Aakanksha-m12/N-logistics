<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="model.Container"%>

<%
    /*
     * ============================================================
     * SESSION / ROLE
     * ============================================================
     */

    String role =
            (String) session.getAttribute("roleName");

    if (role == null) {
        role = "";
    }

    boolean isSuperAdmin =
            "Super Admin".equals(role);

    boolean isCompanyAdmin =
            "Company Admin".equals(role);


    /*
     * Only Super Admin and Company Admin can update containers.
     */

    if (!isSuperAdmin && !isCompanyAdmin) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Access denied."
        );

        return;
    }


    /*
     * ============================================================
     * CONTAINER
     * ============================================================
     */

    Container container =
            (Container) request.getAttribute("container");

    if (container == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Container not found."
        );

        return;
    }


    /*
     * ============================================================
     * CSRF TOKEN
     * ============================================================
     */

    controller.Csrf.ensureToken(request);

    String csrfToken =
            (String) session.getAttribute("csrfToken");


    /*
     * ============================================================
     * CURRENT IMAGE
     * ============================================================
     */

    String currentImage =
            container.getImageUrl();

    if (currentImage == null) {
        currentImage = "";
    }
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>N Logistics · Update Container</title>


    <!-- ========================================================
         BOOTSTRAP
         ======================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- ========================================================
         N LOGISTICS DESIGN
         ======================================================== -->

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

            --danger: #B23A2E;

        }


        * {
            box-sizing: border-box;
        }


        html,
        body {

            margin: 0;

            padding: 0;

            min-height: 100%;

        }


        body {

            background: var(--paper);

            color: var(--ink);

            font-family:
                Arial,
                Helvetica,
                sans-serif;

        }


        /* ========================================================
           SIDEBAR
           ======================================================== */

        .nl-sidebar {

            position: fixed;

            top: 0;

            left: 0;

            bottom: 0;

            width: 245px;

            background: var(--ink);

            color: white;

            z-index: 1000;

            display: flex;

            flex-direction: column;

        }


        .sidebar-brand {

            padding:
                24px 22px 22px;

            border-bottom:
                1px solid #30404D;

        }


        .brand-link {

            color: white;

            text-decoration: none;

            font-size: 20px;

            font-weight: 700;

            display: flex;

            align-items: center;

        }


        .brand-link:hover {

            color: white;

        }


        .brand-mark {

            width: 36px;

            height: 36px;

            background: var(--cargo);

            display: inline-flex;

            align-items: center;

            justify-content: center;

            margin-right: 10px;

            font-size: 18px;

            font-weight: 800;

        }


        .brand-subtitle {

            margin-left: 46px;

            margin-top: -2px;

            color: #AEB9C2;

            font-size: 10px;

            line-height: 1.4;

        }


        /* ========================================================
           SIDEBAR NAVIGATION
           ======================================================== */

        .sidebar-nav {

            padding:
                22px 12px;

            flex: 1;

        }


        .nav-section-title {

            color: #7F8D98;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.2px;

            padding:
                0 12px;

            margin-bottom: 8px;

        }


        .sidebar-link {

            display: flex;

            align-items: center;

            color: #D4DCE1;

            text-decoration: none;

            padding:
                11px 12px;

            margin-bottom: 3px;

            font-size: 13px;

            font-weight: 600;

            border-left:
                3px solid transparent;

        }


        .sidebar-link:hover {

            background: #1B2D3B;

            color: white;

            border-left-color:
                var(--cargo);

        }


        .sidebar-link.active {

            background: #1B2D3B;

            color: white;

            border-left-color:
                var(--cargo);

        }


        .sidebar-icon {

            width: 25px;

            margin-right: 7px;

            font-size: 14px;

            text-align: center;

        }


        /* ========================================================
           SIDEBAR FOOTER
           ======================================================== */

        .sidebar-footer {

            padding:
                15px 14px;

            border-top:
                1px solid #30404D;

        }


        .sidebar-user {

            color: #AEB9C2;

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            margin-bottom: 8px;

        }


        .sidebar-role {

            color: white;

            font-size: 12px;

            font-weight: 700;

            margin-bottom: 12px;

        }


        .logout-button {

            width: 100%;

            background: transparent;

            color: #D4DCE1;

            border:
                1px solid #455661;

            padding:
                9px 12px;

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

        }


        .logout-button:hover {

            background: #243743;

            color: white;

            border-color: #657681;

        }


        /* ========================================================
           MAIN AREA
           ======================================================== */

        .nl-main {

            margin-left: 245px;

            min-height: 100vh;

        }


        /* ========================================================
           TOP BAR
           ======================================================== */

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

            font-size: 12px;

            color: var(--ink-soft);

            font-weight: 600;

        }


        .topbar-role {

            color: var(--ink);

            border:
                1px solid var(--line);

            padding:
                7px 11px;

            font-size: 11px;

            font-weight: 700;

        }


        /* ========================================================
           CONTENT
           ======================================================== */

        .nl-content {

            max-width: 1050px;

            margin: 0 auto;

            padding:
                38px 28px 60px;

        }


        /* ========================================================
           PAGE HEADER
           ======================================================== */

        .page-header {

            display: flex;

            justify-content:
                space-between;

            align-items: flex-start;

            gap: 20px;

            margin-bottom: 25px;

        }


        .page-kicker {

            color: var(--cargo);

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.5px;

            margin-bottom: 8px;

        }


        .page-title {

            font-size: 32px;

            font-weight: 750;

            letter-spacing: -0.5px;

            margin: 0 0 8px;

        }


        .page-description {

            color: var(--ink-soft);

            font-size: 14px;

            margin: 0;

            line-height: 1.6;

        }


        /* ========================================================
           BACK BUTTON
           ======================================================== */

        .back-button {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            background: white;

            color: var(--ink);

            border:
                1px solid var(--line);

            padding:
                9px 14px;

            text-decoration: none;

            font-size: 12px;

            font-weight: 700;

            white-space: nowrap;

        }


        .back-button:hover {

            background: #F7F8F8;

            color: var(--ink);

        }


        /* ========================================================
           PANEL
           ======================================================== */

        .nl-panel {

            background: var(--surface);

            border:
                1px solid var(--line);

            margin-bottom: 24px;

        }


        .panel-header {

            padding:
                19px 22px;

            border-bottom:
                1px solid var(--line);

        }


        .panel-title {

            font-size: 17px;

            font-weight: 700;

            margin: 0;

        }


        .panel-description {

            color: var(--ink-soft);

            font-size: 11px;

            margin:
                4px 0 0;

        }


        .panel-body {

            padding:
                25px 22px 27px;

        }


        /* ========================================================
           INFORMATION BOX
           ======================================================== */

        .info-box {

            background: #F7F8F8;

            border:
                1px solid var(--line);

            padding:
                14px 16px;

            margin-bottom: 22px;

            color: var(--ink-soft);

            font-size: 12px;

            line-height: 1.6;

        }


        .info-box strong {

            color: var(--ink);

        }


        /* ========================================================
           WARNING BOX
           ======================================================== */

        .warning-box {

            background: var(--cargo-soft);

            border:
                1px solid #E7C1AE;

            padding:
                13px 15px;

            margin-bottom: 22px;

            color: #7E3C20;

            font-size: 12px;

            line-height: 1.6;

        }


        /* ========================================================
           FORM
           ======================================================== */

        .form-label {

            color: var(--ink);

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.6px;

            margin-bottom: 7px;

        }


        .required {

            color: var(--danger);

        }


        .form-control,
        .form-select {

            min-height: 42px;

            border:
                1px solid var(--line);

            border-radius: 0;

            color: var(--ink);

            font-size: 13px;

        }


        .form-control:focus,
        .form-select:focus {

            border-color:
                var(--cargo);

            box-shadow:
                0 0 0 0.15rem
                rgba(217, 98, 43, 0.12);

        }


        .form-control[readonly] {

            background: #F7F8F8;

            color: var(--ink-soft);

            cursor: not-allowed;

        }


        .form-text {

            color: var(--ink-faint);

            font-size: 10px;

            margin-top: 5px;

        }


        /* ========================================================
           CURRENT IMAGE
           ======================================================== */

        .current-image-box {

            border:
                1px solid var(--line);

            background: #F7F8F8;

            padding: 15px;

            margin-top: 8px;

        }


        .current-image-title {

            color: var(--ink-faint);

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.7px;

            margin-bottom: 10px;

        }


        .current-image {
    width: 240px;
    height: 160px;
    object-fit: cover;
    display: block;
    border: 1px solid var(--border);
    background: #F7F8F8;
    border-radius: 8px;
    

        }


        .no-image {

            color: var(--ink-faint);

            font-size: 12px;

        }


        /* ========================================================
           STATUS DISPLAY
           ======================================================== */

        .status-display {

            display: inline-block;

            padding:
                6px 10px;

            background: #F7F8F8;

            border:
                1px solid var(--line);

            color: var(--ink-soft);

            font-size: 11px;

            font-weight: 700;

        }


        /* ========================================================
           BUTTONS
           ======================================================== */

        .button-row {

            display: flex;

            align-items: center;

            gap: 9px;

            margin-top: 27px;

            padding-top: 22px;

            border-top:
                1px solid var(--line);

        }


        .btn-nl {

            background: var(--cargo);

            color: white;

            border:
                1px solid var(--cargo);

            border-radius: 0;

            padding:
                10px 18px;

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

        }


        .btn-nl:hover {

            background: var(--cargo-dark);

            border-color: var(--cargo-dark);

            color: white;

        }


        .btn-cancel {

            background: white;

            color: var(--ink);

            border:
                1px solid var(--line);

            border-radius: 0;

            padding:
                10px 18px;

            font-size: 12px;

            font-weight: 700;

            text-decoration: none;

        }


        .btn-cancel:hover {

            background: #F7F8F8;

            color: var(--ink);

        }


        /* ========================================================
           FOOTER NOTE
           ======================================================== */

        .footer-note {

            background: #F7F8F8;

            border-top:
                1px solid var(--line);

            padding:
                13px 18px;

            color: var(--ink-soft);

            font-size: 11px;

            line-height: 1.5;

        }


        .footer-note strong {

            color: var(--ink);

        }


        /* ========================================================
           MOBILE
           ======================================================== */

        @media (max-width: 850px) {

            .nl-sidebar {

                position: relative;

                width: 100%;

                min-height: auto;

            }


            .sidebar-nav {

                padding:
                    12px;

            }


            .sidebar-footer {

                padding:
                    12px;

            }


            .nl-main {

                margin-left: 0;

            }


            .nl-topbar {

                padding:
                    0 18px;

            }


            .nl-content {

                padding:
                    28px 16px 45px;

            }


            .page-header {

                flex-direction: column;

                align-items: flex-start;

            }

        }


        @media (max-width: 600px) {

            .page-title {

                font-size: 27px;

            }


            .panel-body {

                padding:
                    20px 16px 22px;

            }


            .button-row {

                flex-direction: column;

                align-items: stretch;

            }


            .btn-nl,
            .btn-cancel {

                width: 100%;

                text-align: center;

            }

        }

    </style>

</head>


<body>


<!-- ============================================================
     LEFT SIDEBAR
     ============================================================ -->

<aside class="nl-sidebar">


    <!-- BRAND -->

    <div class="sidebar-brand">

        <a
            class="brand-link"
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

    <div class="sidebar-nav">


        <div class="nav-section-title">
            Navigation
        </div>


        <!-- DASHBOARD -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ⌂
            </span>

            Dashboard

        </a>


        <!-- CONTAINERS -->

        <a
            class="sidebar-link active"
            href="<%= request.getContextPath() %>/containers?action=view">

            <span class="sidebar-icon">
                ▣
            </span>

            Containers

        </a>


        <!-- PRICING -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing?action=view">

            <span class="sidebar-icon">
                ₹
            </span>

            Pricing

        </a>


        <!-- DEMAND FORECAST -->

        <%
            if (isSuperAdmin || isCompanyAdmin) {
        %>

            <a
                class="sidebar-link"
                href="<%= request.getContextPath() %>/forecast?action=view">

                <span class="sidebar-icon">
                    ◔
                </span>

                Demand Forecast

            </a>

        <%
            }
        %>


        <div class="nav-section-title mt-4">
            Current Task
        </div>


        <!-- BACK TO DASHBOARD -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ←
            </span>

            Back to Dashboard

        </a>


    </div>


    <!-- SIDEBAR FOOTER -->

    <div class="sidebar-footer">


        <div class="sidebar-user">
            Signed in as
        </div>


        <div class="sidebar-role">

            <%= role %>

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


<!-- ============================================================
     MAIN
     ============================================================ -->

<div class="nl-main">


    <!-- ========================================================
         TOP BAR
         ======================================================== -->

    <header class="nl-topbar">

        <div class="topbar-title">
            Container Management
        </div>

        <div class="topbar-role">
            <%= role == null ? "" : role %>
        </div>

    </header>


    <!-- ========================================================
         CONTENT
         ======================================================== -->

    <main class="nl-content">


        <!-- ====================================================
             PAGE HEADER
             ==================================================== -->

        <div class="page-header">


            <div>

                <div class="page-kicker">

                    Container Operations

                </div>


                <h1 class="page-title">

                    Update Container

                </h1>


                <p class="page-description">

                    Update the permitted information for the
                    selected container.

                </p>

            </div>


            <!-- BACK BUTTON -->

            <a
                href="<%= request.getContextPath() %>/app?action=home"
                class="back-button">

                ← Back to Containers

            </a>


        </div>


        <!-- ====================================================
             UPDATE PANEL
             ==================================================== -->

        <section class="nl-panel">


            <div class="panel-header">

                <div class="panel-title">

                    Container Information

                </div>


                <div class="panel-description">

                    Modify the container information and save
                    the changes.

                </div>

            </div>


            <div class="panel-body">


                <!-- =================================================
                     INFORMATION
                     ================================================= -->

                <div class="info-box">

                    <strong>
                        Container ID:
                    </strong>

                    <%= container.getContainerId() %>

                    <br>

                    <strong>
                        Company:
                    </strong>

                    Company-owned container

                    <br>

                    The container number and company ownership
                    are controlled by the system.

                </div>


                <!-- =================================================
                     OPERATIONAL WARNING
                     ================================================= -->

                <%
                    if ("Allocated".equals(container.getStatus())
                            || "In-Transit".equals(container.getStatus())) {
                %>

                    <div class="warning-box">

                        <strong>
                            Operational status:
                        </strong>

                        <%= container.getStatus() %>

                        <br>

                        This container is currently being used
                        operationally. Its status cannot be
                        changed through this form.

                    </div>

                <%
                    }
                %>


                <!-- =================================================
                     UPDATE FORM
                     ================================================= -->

                <form
                    method="post"
                    action="<%= request.getContextPath() %>/containers"
                    enctype="multipart/form-data">


                    <!-- CSRF -->

                    <input
                        type="hidden"
                        name="action"
                        value="update">


                    <input
                        type="hidden"
                        name="containerId"
                        value="<%= container.getContainerId() %>">


                    <input
                        type="hidden"
                        name="csrfToken"
                        value="<%= csrfToken %>">


                    <div class="row g-4">


                        <!-- =========================================
                             CONTAINER NUMBER
                             ========================================= -->

                        <div class="col-md-6">

                            <label
                                class="form-label">

                                Container Number
                                <span class="required">*</span>

                            </label>


                            <input
                                type="text"
                                name="containerNumber"
                                class="form-control"
                                maxlength="50"
                                value="<%= container.getContainerNumber() %>"
                                readonly
                                required>


                            <div class="form-text">

                                Container number is controlled by
                                the system and cannot be changed.

                            </div>

                        </div>


                        <!-- =========================================
                             TYPE
                             ========================================= -->

                        <div class="col-md-3">

                            <label
                                class="form-label">

                                Type
                                <span class="required">*</span>

                            </label>


                            <select
                                name="type"
                                class="form-select"
                                required>


                                <option
                                    value="Dry"
                                    <%= "Dry".equals(
                                            container.getType())
                                        ? "selected" : "" %>>

                                    Dry

                                </option>


                                <option
                                    value="Reefer"
                                    <%= "Reefer".equals(
                                            container.getType())
                                        ? "selected" : "" %>>

                                    Reefer

                                </option>


                                <option
                                    value="Open Top"
                                    <%= "Open Top".equals(
                                            container.getType())
                                        ? "selected" : "" %>>

                                    Open Top

                                </option>


                                <option
                                    value="Flat Rack"
                                    <%= "Flat Rack".equals(
                                            container.getType())
                                        ? "selected" : "" %>>

                                    Flat Rack

                                </option>


                                <option
                                    value="Tank"
                                    <%= "Tank".equals(
                                            container.getType())
                                        ? "selected" : "" %>>

                                    Tank

                                </option>


                            </select>

                        </div>


                        <!-- =========================================
                             SIZE
                             ========================================= -->

                        <div class="col-md-3">

                            <label
                                class="form-label">

                                Size
                                <span class="required">*</span>

                            </label>


                            <select
                                name="size"
                                class="form-select"
                                required>


                                <option
                                    value="20ft"
                                    <%= "20ft".equals(
                                            container.getSize())
                                        ? "selected" : "" %>>

                                    20ft

                                </option>


                                <option
                                    value="40ft"
                                    <%= "40ft".equals(
                                            container.getSize())
                                        ? "selected" : "" %>>

                                    40ft

                                </option>


                                <option
                                    value="40ft HC"
                                    <%= "40ft HC".equals(
                                            container.getSize())
                                        ? "selected" : "" %>>

                                    40ft HC

                                </option>


                                <option
                                    value="45ft"
                                    <%= "45ft".equals(
                                            container.getSize())
                                        ? "selected" : "" %>>

                                    45ft

                                </option>


                            </select>

                        </div>

                        <!-- =========================================
                             CURRENT IMAGE
                             ========================================= -->

                        <div class="col-12">

                            <div class="current-image-box">


                                <div class="current-image-title">

                                    Current Container Image

                                </div>


                                <%
                                    if (!currentImage.trim().isEmpty()) {
                                %>


                                    <img
                                        src="<%= currentImage.startsWith("http://") || currentImage.startsWith("https://") ? currentImage : request.getContextPath() + "/" + currentImage %>"
                                        alt="Current container image"
                                        class="current-image"
                                        onerror="this.style.display='none'; document.getElementById('imageError').style.display='block';">


                                    <div
                                        id="imageError"
                                        class="no-image mt-2"
                                        style="display:none;">

                                        Current image could not be loaded.

                                    </div>


                                <%
                                    } else {
                                %>


                                    <div class="no-image">

                                        No current image available.

                                    </div>


                                <%
                                    }
                                %>


                            </div>

                        </div>


                        <!-- =========================================
                             NEW IMAGE FILE
                             ========================================= -->

                        <div class="col-12">

                            <label
                                class="form-label">

                                Replace Image

                            </label>


                            <input
                                type="file"
                                name="imageFile"
                                id="imageFile"
                                class="form-control"
                                accept=".jpg,.jpeg,.png,.webp,.gif">


                            <div class="form-text">

                                Optional. JPG, JPEG, PNG, WEBP or GIF.
                                Maximum file size: 5 MB.

                            </div>


                            <!-- NEW IMAGE PREVIEW -->

                            <div
                                id="newImagePreviewBox"
                                class="current-image-box"
                                style="display:none;">

                                <div class="current-image-title">

                                    New Image Preview

                                </div>


                                <img
                                    id="newImagePreview"
                                    class="current-image"
                                    alt="New container image preview">

                            </div>

                        </div>


                        <!-- =========================================
                             TARE WEIGHT
                             ========================================= -->

                        <div class="col-md-4">

                            <label
                                class="form-label">

                                Tare Weight (kg)
                                <span class="required">*</span>

                            </label>


                            <input
                                type="number"
                                name="tareWeightKg"
                                id="tareWeightKg"
                                class="form-control"
                                min="0"
                                step="0.01"
                                value="<%= container.getTareWeightKg() %>"
                                required>


                            <div class="form-text">

                                Weight of the empty container.

                            </div>

                        </div>


                        <!-- =========================================
                             MAX GROSS WEIGHT
                             ========================================= -->

                        <div class="col-md-4">

                            <label
                                class="form-label">

                                Max Gross Weight (kg)
                                <span class="required">*</span>

                            </label>


                            <input
                                type="number"
                                name="maxGrossWeightKg"
                                id="maxGrossWeightKg"
                                class="form-control"
                                min="0"
                                step="0.01"
                                value="<%= container.getMaxGrossWeightKg() %>"
                                required>


                            <div class="form-text">

                                Maximum permitted total weight.

                            </div>

                        </div>


                        <!-- =========================================
                             GOODS CAPACITY KG
                             ========================================= -->

                        <div class="col-md-4">

                            <label
                                class="form-label">

                                Goods Capacity (kg)
                                <span class="required">*</span>

                            </label>


                            <input
                                type="number"
                                name="goodsCapacityKg"
                                id="goodsCapacityKg"
                                class="form-control"
                                min="0"
                                step="0.01"
                                value="<%= container.getGoodsCapacityKg() %>"
                                required>


                            <div class="form-text">

                                Cargo capacity in kilograms.

                            </div>

                        </div>


                        <!-- =========================================
                             GOODS CAPACITY CBM
                             ========================================= -->

                        <div class="col-md-4">

                            <label
                                class="form-label">

                                Goods Capacity (CBM)
                                <span class="required">*</span>

                            </label>


                            <input
                                type="number"
                                name="goodsCapacityCbm"
                                id="goodsCapacityCbm"
                                class="form-control"
                                min="0"
                                step="0.01"
                                value="<%= container.getGoodsCapacityCbm() %>"
                                required>


                            <div class="form-text">

                                Cargo volume capacity in cubic metres.

                            </div>

                        </div>


                        <!-- =========================================
                             STATUS
                             ========================================= -->

                        <div class="col-md-4">

                            <label
                                class="form-label">

                                Current Status

                            </label>


                            <div>

                                <span class="status-display">

                                    <%= container.getStatus() %>

                                </span>

                            </div>


                            <div class="form-text">

                                Operational status is controlled
                                by container operations.

                            </div>

                        </div>


                    </div>


                    <!-- =================================================
                         BUTTONS
                         ================================================= -->

                    <div class="button-row">


                        <button
                            type="submit"
                            class="btn-nl">

                            Save Changes

                        </button>


                        <a
                            href="<%= request.getContextPath() %>/app?action=home"
                            class="btn-cancel">

                            Cancel

                        </a>


                    </div>


                </form>


            </div>


            <!-- =====================================================
                 FOOTER NOTE
                 ===================================================== -->

            <div class="footer-note">

                <strong>Note:</strong>

                Container ownership and operational status are
                controlled by the system. Changes to container
                capacity and specifications are validated before
                they are stored.

            </div>


        </section>


    </main>

</div>


<!-- ============================================================
     BOOTSTRAP JAVASCRIPT
     ============================================================ -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<!-- ============================================================
     IMAGE PREVIEW
     ============================================================ -->

<script>

    var imageFile =
        document.getElementById("imageFile");

    var previewBox =
        document.getElementById(
            "newImagePreviewBox"
        );

    var preview =
        document.getElementById(
            "newImagePreview"
        );


    if (imageFile) {

        imageFile.addEventListener(
            "change",
            function () {

                if (!this.files ||
                    this.files.length === 0) {

                    previewBox.style.display =
                        "none";

                    preview.removeAttribute(
                        "src"
                    );

                    return;
                }


                var file =
                    this.files[0];


                /*
                 * Maximum 5 MB.
                 */

                var maxSize =
                    5 * 1024 * 1024;


                if (file.size > maxSize) {

                    alert(
                        "Image size cannot exceed 5 MB."
                    );

                    this.value = "";

                    previewBox.style.display =
                        "none";

                    preview.removeAttribute(
                        "src"
                    );

                    return;
                }


                /*
                 * Allowed image types.
                 */

                var allowedTypes = [

                    "image/jpeg",

                    "image/png",

                    "image/webp",

                    "image/gif"

                ];


                if (allowedTypes.indexOf(
                        file.type) === -1) {

                    alert(
                        "Please select a JPG, JPEG, PNG, WEBP or GIF image."
                    );

                    this.value = "";

                    previewBox.style.display =
                        "none";

                    preview.removeAttribute(
                        "src"
                    );

                    return;
                }


                /*
                 * Preview selected image.
                 */

                var reader =
                    new FileReader();


                reader.onload =
                    function (event) {

                        preview.src =
                            event.target.result;

                        previewBox.style.display =
                            "block";

                    };


                reader.readAsDataURL(file);

            }
        );

    }


    /* =========================================================
       BASIC CLIENT-SIDE CAPACITY VALIDATION
       ========================================================= */

    var form =
        document.querySelector(
            "form[action$='/containers']"
        );


    if (form) {

        form.addEventListener(
            "submit",
            function (event) {

                var tare =
                    parseFloat(
                        document.getElementById(
                            "tareWeightKg"
                        ).value
                    );


                var maxGross =
                    parseFloat(
                        document.getElementById(
                            "maxGrossWeightKg"
                        ).value
                    );


                var goodsKg =
                    parseFloat(
                        document.getElementById(
                            "goodsCapacityKg"
                        ).value
                    );


                var goodsCbm =
                    parseFloat(
                        document.getElementById(
                            "goodsCapacityCbm"
                        ).value
                    );


                /*
                 * Basic positive-value validation.
                 */

                if (isNaN(tare) ||
                    isNaN(maxGross) ||
                    isNaN(goodsKg) ||
                    isNaN(goodsCbm)) {

                    alert(
                        "Please enter valid numeric values."
                    );

                    event.preventDefault();

                    return;
                }


                if (tare < 0 ||
                    maxGross <= 0 ||
                    goodsKg <= 0 ||
                    goodsCbm <= 0) {

                    alert(
                        "Weight and capacity values must be greater than zero."
                    );

                    event.preventDefault();

                    return;
                }


                /*
                 * Tare weight cannot exceed gross weight.
                 */

                if (tare > maxGross) {

                    alert(
                        "Tare weight cannot exceed maximum gross weight."
                    );

                    event.preventDefault();

                    return;
                }


                /*
                 * Database trigger requires:
                 *
                 * goods capacity <=
                 * max gross weight - tare weight
                 */

                var usableCapacity =
                    maxGross - tare;


                if (goodsKg >
                    usableCapacity) {

                    alert(
                        "Goods capacity cannot exceed the usable weight capacity after tare weight."
                    );

                    event.preventDefault();

                    return;
                }

            }
        );

    }

</script>


</body>

</html>