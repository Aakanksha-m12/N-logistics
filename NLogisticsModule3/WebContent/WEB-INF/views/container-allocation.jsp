<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="model.Container"%>
<%@ page import="java.util.List"%>
<%@ page import="controller.Csrf"%>

<%
    String role =
            (String) request.getAttribute("role");

    if (role == null) {
        role =
                (String) session.getAttribute("roleName");
    }

    if (role == null) {
        role = "";
    }

    boolean isSuperAdmin =
            "Super Admin".equals(role);

    boolean isCompanyAdmin =
            "Company Admin".equals(role);

    boolean isOperations =
            "Company Staff (Operations)".equals(role);

    boolean isCustomer =
            "Customer".equals(role);

    /*
     * Customer is now allowed to allocate.
     */
    boolean canAllocate =
            isSuperAdmin ||
            isCompanyAdmin ||
            isOperations ||
            isCustomer;

    /*
     * Route IDs supplied by AllocationController.
     */
    List<?> availableRouteObjects =
            (List<?>) request.getAttribute("availableRouteIds");

    /*
     * Customer allocation flag.
     */
    boolean customerAllocation =
            Boolean.TRUE.equals(
                    request.getAttribute("customerAllocation"));

    Container container =
            (Container) request.getAttribute("container");

    /*
     * Use the same CSRF implementation as AllocationController.
     * Csrf.ensureToken() creates the token if it does not exist
     * and stores it in the session using the key "csrfToken".
     */
    String csrfToken =
            Csrf.ensureToken(request);
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Allocate Container - N Logistics
    </title>


    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <style>

        :root {
            --paper: #F0F2F1;
            --surface: #FFFFFF;
            --ink: #10202F;
            --ink-soft: #5C6A78;
            --border: #DFE3E2;
            --orange: #D9622B;
            --orange-dark: #BE4F21;
            --success: #2F7D53;
            --danger: #B23A2E;
        }


        * {
            box-sizing: border-box;
        }


        body {
            margin: 0;
            background: var(--paper);
            color: var(--ink);
            font-family: Arial, Helvetica, sans-serif;
        }


        /* ======================================================
           SIDEBAR
           ====================================================== */

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 240px;
            height: 100vh;
            background: var(--ink);
            color: white;
            padding: 20px 15px;
            z-index: 1000;
        }


        .brand {
            display: flex;
            align-items: center;
            color: white;
            text-decoration: none;
            margin-bottom: 35px;
            padding: 5px;
        }


        .brand-box {
            width: 42px;
            height: 42px;
            background: var(--orange);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: bold;
            margin-right: 10px;
        }


        .brand-text {
            font-size: 17px;
            font-weight: bold;
        }


        .brand-small {
            display: block;
            color: #91A0AA;
            font-size: 9px;
            letter-spacing: 1px;
            margin-top: 3px;
        }


        .sidebar-title {
            color: #8FA0AA;
            font-size: 10px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 20px 10px 8px;
        }


        .sidebar-link {
            display: block;
            color: #D5DEE2;
            text-decoration: none;
            padding: 12px 13px;
            margin-bottom: 4px;
            font-size: 14px;
            border-left: 3px solid transparent;
        }


        .sidebar-link:hover,
        .sidebar-link.active {
            color: white;
            background: #193346;
            border-left-color: var(--orange);
        }


        .sidebar-role {
            position: absolute;
            left: 15px;
            right: 15px;
            bottom: 80px;
            border-top: 1px solid #2A3B48;
            padding: 15px 8px;
        }


        .role-label {
            color: #8FA0AA;
            font-size: 9px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }


        .role-name {
            color: white;
            font-size: 12px;
            margin-top: 5px;
        }


        .logout-area {
            position: absolute;
            left: 15px;
            right: 15px;
            bottom: 20px;
        }


        .logout-button {
            width: 100%;
            border: 1px solid #52636E;
            background: transparent;
            color: white;
            padding: 10px;
            font-size: 13px;
        }


        .logout-button:hover {
            background: var(--orange);
            border-color: var(--orange);
        }


        /* ======================================================
           MAIN
           ====================================================== */

        .main-content {
            margin-left: 240px;
            min-height: 100vh;
            padding: 35px;
        }


        .top-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 25px;
        }


        .back-button {
            color: var(--ink);
            background: white;
            border: 1px solid var(--border);
            padding: 9px 16px;
            text-decoration: none;
            font-size: 13px;
        }


        .back-button:hover {
            background: var(--ink);
            color: white;
        }


        .page-kicker {
            color: var(--orange);
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 7px;
        }


        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0;
        }


        .page-description {
            color: var(--ink-soft);
            font-size: 14px;
            max-width: 750px;
            line-height: 1.6;
            margin-top: 10px;
            margin-bottom: 25px;
        }


        /* ======================================================
           ALLOCATION CARD
           ====================================================== */

        .allocation-card {
            background: white;
            border: 1px solid var(--border);
        }


        .card-header-custom {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
        }


        .card-title {
            font-size: 20px;
            font-weight: bold;
            margin: 0;
        }


        .card-subtitle {
            color: var(--ink-soft);
            font-size: 12px;
            margin-top: 5px;
        }


        .card-body-custom {
            padding: 25px;
        }


        /* ======================================================
           LARGE IMAGE
           ====================================================== */

        .image-panel {
            background: #F7F8F8;
            border: 1px solid var(--border);
            padding: 15px;
        }


        .large-container-image {
            width: 100%;
            height: 390px;
            object-fit: cover;
            display: block;
            background: #EEF1F0;
        }


        .no-large-image {
            width: 100%;
            height: 390px;
            background: #EEF1F0;
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8B96A0;
            font-size: 14px;
            font-weight: bold;
        }


        /* ======================================================
           CONTAINER TITLE
           ====================================================== */

        .container-heading {
            margin-top: 15px;
        }


        .container-number {
            font-family: "Courier New", monospace;
            font-size: 22px;
            font-weight: bold;
        }


        .container-type {
            color: var(--ink-soft);
            font-size: 12px;
            margin-top: 4px;
        }


        /* ======================================================
           INFORMATION GRID
           ====================================================== */

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
            margin-top: 15px;
        }


        .info-item {
            border: 1px solid var(--border);
            padding: 13px 14px;
            background: #FFFFFF;
        }


        .info-label {
            color: #8B96A0;
            font-size: 9px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: .8px;
            margin-bottom: 5px;
        }


        .info-value {
            color: var(--ink);
            font-size: 13px;
            font-weight: bold;
        }


        /* ======================================================
           CAPACITY
           ====================================================== */

        .capacity-box {
            margin-top: 15px;
            background: #F7F8F8;
            border: 1px solid var(--border);
            padding: 17px;
        }


        .capacity-title {
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: .8px;
            margin-bottom: 12px;
        }


        .capacity-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }


        .capacity-value {
            background: white;
            border: 1px solid var(--border);
            padding: 14px;
        }


        .capacity-value-label {
            color: var(--ink-soft);
            font-size: 10px;
        }


        .capacity-number {
            font-size: 20px;
            font-weight: bold;
            margin-top: 4px;
        }


        /* ======================================================
           ROUTE
           ====================================================== */

        .route-box {
            margin-top: 25px;
            margin-bottom: 25px;
            background: #F7F8F8;
            border: 1px solid var(--border);
            padding: 20px;
        }


        .route-title {
            font-size: 15px;
            font-weight: bold;
            margin-bottom: 5px;
        }


        .route-description {
            color: var(--ink-soft);
            font-size: 11px;
            margin-bottom: 18px;
        }


        .route-location {
            min-height: 48px;
            background: white;
            border: 1px solid var(--border);
            padding: 13px 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }


        .route-label {
            color: var(--ink-soft);
            font-size: 11px;
        }


        .route-preview {
            margin-top: 18px;
            background: white;
            border: 1px solid var(--border);
            padding: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }


        .route-port {
            font-size: 14px;
            font-weight: bold;
        }


        .route-arrow {
            color: var(--orange);
            font-size: 22px;
            font-weight: bold;
        }


        /* ======================================================
           FORM
           ====================================================== */

        .form-panel {
            margin-top: 25px;
            border-top: 1px solid var(--border);
            padding-top: 25px;
        }


        .form-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }


        .form-description {
            color: var(--ink-soft);
            font-size: 12px;
            margin-bottom: 20px;
        }


        .form-label-custom {
            display: block;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: .7px;
            margin-bottom: 7px;
        }


        .form-control {
            min-height: 48px;
            border-radius: 0;
            border-color: #C9D0D2;
            font-size: 13px;
        }


        .form-control:focus {
            border-color: var(--orange);
            box-shadow:
                0 0 0 0.15rem
                rgba(217, 98, 43, .12);
        }


        .field-help {
            font-size: 10px;
            color: #8B96A0;
            margin-top: 6px;
        }


        .validation-message {
            min-height: 20px;
            font-size: 10px;
            margin-top: 6px;
        }


        .validation-neutral {
            color: #8B96A0;
        }


        .validation-valid {
            color: var(--success);
        }


        .validation-invalid {
            color: var(--danger);
        }


        .input-valid {
            border-color: var(--success) !important;
            background: #F5FBF7 !important;
        }


        .input-invalid {
            border-color: var(--danger) !important;
            background: #FFF7F5 !important;
        }


        /* ======================================================
           ACTIONS
           ====================================================== */

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 22px;
        }


        .allocate-button {
            flex: 1;
            min-height: 48px;
            background: var(--orange);
            border: 1px solid var(--orange);
            color: white;
            font-size: 12px;
            font-weight: bold;
        }


        .allocate-button:hover:not(:disabled) {
            background: var(--orange-dark);
            border-color: var(--orange-dark);
        }


        .allocate-button:disabled {
            background: #B9C0C3;
            border-color: #B9C0C3;
            cursor: not-allowed;
        }


        .cancel-button {
            min-height: 48px;
            padding: 0 22px;
            background: white;
            border: 1px solid var(--border);
            color: var(--ink);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }


        .cancel-button:hover {
            background: var(--ink);
            color: white;
        }


        /* ======================================================
           SERVER NOTE
           ====================================================== */

        .security-note {
            margin-top: 20px;
            background: white;
            border-left: 3px solid var(--orange);
            border-top: 1px solid var(--border);
            border-right: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            padding: 15px 17px;
            color: var(--ink-soft);
            font-size: 12px;
            line-height: 1.6;
        }


        .security-note strong {
            color: var(--ink);
        }


        /* ======================================================
           ERROR
           ====================================================== */

        .error-card {
            background: white;
            border: 1px solid var(--border);
            padding: 50px;
            text-align: center;
        }


        .error-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 8px;
        }


        .error-text {
            color: var(--ink-soft);
            font-size: 13px;
            margin-bottom: 20px;
        }


        /* ======================================================
           MOBILE
           ====================================================== */

        @media (max-width: 900px) {

            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
            }


            .sidebar-role,
            .logout-area {
                position: relative;
                left: auto;
                right: auto;
                bottom: auto;
                margin-top: 15px;
            }


            .main-content {
                margin-left: 0;
                padding: 20px;
            }


            .page-title {
                font-size: 29px;
            }


            .large-container-image,
            .no-large-image {
                height: 280px;
            }

        }


        @media (max-width: 600px) {

            .info-grid,
            .capacity-grid {
                grid-template-columns: 1fr;
            }


            .form-actions {
                flex-direction: column;
            }


            .cancel-button {
                min-height: 44px;
            }


            .route-preview {
                flex-direction: column;
                gap: 8px;
            }

        }

    </style>

</head>


<body>


<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<div class="sidebar">


    <a
        href="<%= request.getContextPath() %>/app?action=home"
        class="brand">

        <span class="brand-box">
            N
        </span>

        <span>

            <span class="brand-text">
                N Logistics
            </span>

            <span class="brand-small">
                IMPORT &amp; EXPORT
            </span>

        </span>

    </a>


    <div class="sidebar-title">
        Navigation
    </div>


    <a
        href="<%= request.getContextPath() %>/app?action=home"
        class="sidebar-link">

        Dashboard

    </a>


    <a
        href="<%= request.getContextPath() %>/app?action=containers"
        class="sidebar-link">

        Containers

    </a>


    <a
        href="<%= request.getContextPath() %>/allocation?action=view"
        class="sidebar-link active">

        Allocation

    </a>


    <a
        href="<%= request.getContextPath() %>/pricing?action=view"
        class="sidebar-link">

        Pricing

    </a>


    <a
        href="<%= request.getContextPath() %>/forecast?action=view"
        class="sidebar-link">

        Demand Forecast

    </a>


    <div class="sidebar-role">

        <div class="role-label">
            Active role
        </div>

        <div class="role-name">
            <%= role %>
        </div>

    </div>


    <div class="logout-area">

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

</div>


<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<main class="main-content">


    <div class="top-bar">

        <a
            href="<%= request.getContextPath() %>/allocation?action=view"
            class="back-button">

            &larr; Back to Allocation

        </a>

    </div>


    <div class="page-kicker">
        Container Allocation
    </div>


    <h1 class="page-title">
        Allocate Container
    </h1>


    <p class="page-description">

        Review the selected container, confirm its capacity,
        select its destination route, and enter the cargo
        weight and volume before allocation.

    </p>


    <% if (container == null) { %>


        <div class="error-card">

            <div class="error-title">
                Container Information Not Found
            </div>

            <div class="error-text">

                The selected container could not be loaded.

            </div>

            <a
                href="<%= request.getContextPath() %>/allocation?action=view"
                class="back-button">

                Back to Allocation

            </a>

        </div>


    <% } else { %>


        <!-- ====================================================
             ALLOCATION CARD
             ==================================================== -->

        <section class="allocation-card">


            <div class="card-header-custom">

                <h2 class="card-title">
                    Container Allocation
                </h2>

                <div class="card-subtitle">

                    Review container information before entering
                    cargo and destination details.

                </div>

            </div>


            <div class="card-body-custom">


                <div class="row g-4">


                    <!-- =========================================
                         LEFT: IMAGE
                         ========================================= -->

                    <div class="col-lg-6">


                        <div class="image-panel">


                            <% if (
                                container.getImageUrl() != null &&
                                !container.getImageUrl()
                                    .trim()
                                    .isEmpty()
                            ) { %>


                                <img
                                    src="<%= request.getContextPath() %>/<%= container.getImageUrl() %>"
                                    class="large-container-image"
                                    alt="Container image">


                            <% } else { %>


                                <div class="no-large-image">

                                    NO CONTAINER IMAGE

                                </div>


                            <% } %>


                            <div class="container-heading">

                                <div class="container-number">

                                    <%= container.getContainerNumber() %>

                                </div>


                                <div class="container-type">

                                    <%= container.getType() %>
                                    Container

                                </div>

                            </div>


                        </div>


                    </div>


                    <!-- =========================================
                         RIGHT: INFORMATION
                         ========================================= -->

                    <div class="col-lg-6">


                        <div class="page-kicker">
                            Container Information
                        </div>


                        <div class="info-grid">


                            <div class="info-item">

                                <div class="info-label">
                                    Container Number
                                </div>

                                <div class="info-value">
                                    <%= container.getContainerNumber() %>
                                </div>

                            </div>


                            <div class="info-item">

                                <div class="info-label">
                                    Type
                                </div>

                                <div class="info-value">
                                    <%= container.getType() %>
                                </div>

                            </div>


                            <div class="info-item">

                                <div class="info-label">
                                    Size
                                </div>

                                <div class="info-value">
                                    <%= container.getSize() %>
                                </div>

                            </div>


                            <div class="info-item">

                                <div class="info-label">
                                    Current Location
                                </div>

                                <div class="info-value">

                                    <%= container.getCurrentPortId() == null
                                        ? "Not assigned"
                                        : "Port ID " + container.getCurrentPortId() %>

                                </div>

                            </div>


                            <div class="info-item">

                                <div class="info-label">
                                    Tare Weight
                                </div>

                                <div class="info-value">

                                    <%= container.getTareWeightKg() %>
                                    KG

                                </div>

                            </div>


                            <div class="info-item">

                                <div class="info-label">
                                    Maximum Gross Weight
                                </div>

                                <div class="info-value">

                                    <%= container.getMaxGrossWeightKg() %>
                                    KG

                                </div>

                            </div>


                            <div class="info-item">

                                <div class="info-label">
                                    Status
                                </div>

                                <div class="info-value">

                                    <%= container.getStatus() %>

                                </div>

                            </div>


                            <div class="info-item">

                                <div class="info-label">
                                    Container ID
                                </div>

                                <div class="info-value">

                                    #<%= container.getContainerId() %>

                                </div>

                            </div>


                        </div>


                        <!-- =====================================
                             GOODS CAPACITY
                             ===================================== -->

                        <div class="capacity-box">


                            <div class="capacity-title">

                                Registered Goods Capacity

                            </div>


                            <div class="capacity-grid">


                                <div class="capacity-value">

                                    <div class="capacity-value-label">

                                        Maximum Cargo Weight

                                    </div>

                                    <div class="capacity-number">

                                        <%= container.getGoodsCapacityKg() %>
                                        KG

                                    </div>

                                </div>


                                <div class="capacity-value">

                                    <div class="capacity-value-label">

                                        Maximum Cargo Volume

                                    </div>

                                    <div class="capacity-number">

                                        <%= container.getGoodsCapacityCbm() %>
                                        CBM

                                    </div>

                                </div>


                            </div>


                        </div>


                    </div>

                </div>


                <!-- =================================================
                     CARGO + ROUTE FORM
                     ================================================= -->

                <% if (canAllocate &&
                       "Available".equalsIgnoreCase(
                               container.getStatus())) { %>


                    <div class="form-panel">


                        <div class="form-title">

                            Allocation Details

                        </div>


                        <div class="form-description">

                            The current location is taken automatically
                            from the container. Select a destination
                            route and enter the cargo weight and volume.

                        </div>


                        <form
                            method="post"
                            action="<%= request.getContextPath() %>/allocation"
                            onsubmit="return validateAllocation();">


                            <input
                                type="hidden"
                                name="action"
                                value="allocate">


                            <input
                                type="hidden"
                                name="containerId"
                                value="<%= container.getContainerId() %>">


                            <!-- =================================================
                                 CORRECT CSRF PARAMETER
                                 ================================================= -->

                            <input
                                type="hidden"
                                name="csrfToken"
                                value="<%= csrfToken == null
                                    ? ""
                                    : csrfToken %>">


                            <input
                                type="hidden"
                                id="maxKg"
                                value="<%= container.getGoodsCapacityKg() %>">


                            <input
                                type="hidden"
                                id="maxCbm"
                                value="<%= container.getGoodsCapacityCbm() %>">


                            <!-- =================================================
                                 ROUTE
                                 ================================================= -->

                            <div class="route-box">


                                <div class="route-title">

                                    Container Route

                                </div>


                                <div class="route-description">

                                    Current location is automatic.
                                    Select the destination route from
                                    the available routes.

                                </div>


                                <div class="row g-4">


                                    <!-- CURRENT LOCATION -->

                                    <div class="col-md-6">


                                        <label class="form-label-custom">

                                            Current Location

                                        </label>


                                        <div class="route-location">


                                            <span class="route-label">

                                                Port ID

                                            </span>


                                            <strong>

                                                <%= container.getCurrentPortId() == null
                                                    ? "Not assigned"
                                                    : container.getCurrentPortId() %>

                                            </strong>


                                        </div>


                                    </div>


                                    <!-- DESTINATION ROUTE -->

                                    <div class="col-md-6">


                                        <label
                                            class="form-label-custom"
                                            for="routeId">

                                            Going To

                                        </label>


                                        <select
                                            class="form-control"
                                            id="routeId"
                                            name="routeId"
                                            required
                                            onchange="validateRoute();">


                                            <option
                                                value="">

                                                Select destination route

                                            </option>


                                            <%
                                                if (availableRouteObjects != null &&
                                                    !availableRouteObjects.isEmpty()) {

                                                    for (Object routeObject :
                                                            availableRouteObjects) {

                                                        if (routeObject == null) {
                                                            continue;
                                                        }

                                                        String routeId =
                                                                String.valueOf(
                                                                        routeObject);
                                            %>


                                                        <option
                                                            value="<%= routeId %>">

                                                            Route <%= routeId %>

                                                        </option>


                                            <%
                                                    }

                                                } else {
                                            %>


                                                <option
                                                    value=""
                                                    disabled>

                                                    No routes available

                                                </option>


                                            <%
                                                }
                                            %>


                                        </select>


                                        <div class="field-help">

                                            Select the destination route.

                                        </div>


                                        <div
                                            id="routeMessage"
                                            class="validation-message validation-neutral">

                                            Select a destination route.

                                        </div>


                                    </div>


                                </div>


                                <!-- ROUTE PREVIEW -->

                                <div class="route-preview">


                                    <span class="route-port">

                                        <%= container.getCurrentPortId() == null
                                            ? "Current Port"
                                            : "Port " + container.getCurrentPortId() %>

                                    </span>


                                    <span class="route-arrow">

                                        &rarr;

                                    </span>


                                    <span
                                        class="route-port"
                                        id="destinationPreview">

                                        Destination Route

                                    </span>


                                </div>


                            </div>


                            <!-- =================================================
                                 CARGO
                                 ================================================= -->

                            <div class="row g-4">


                                <!-- CARGO KG -->

                                <div class="col-md-6">


                                    <label
                                        class="form-label-custom"
                                        for="cargoWeightKg">

                                        Cargo Weight (KG)

                                    </label>


                                    <input
                                        type="number"
                                        class="form-control"
                                        id="cargoWeightKg"
                                        name="cargoWeightKg"
                                        min="0"
                                        step="0.01"
                                        placeholder="Enter cargo weight"
                                        required
                                        oninput="validateWeight();">


                                    <div class="field-help">

                                        Maximum:
                                        <%= container.getGoodsCapacityKg() %>
                                        KG

                                    </div>


                                    <div
                                        id="weightMessage"
                                        class="validation-message validation-neutral">

                                        Enter cargo weight.

                                    </div>

                                </div>


                                <!-- CARGO CBM -->

                                <div class="col-md-6">


                                    <label
                                        class="form-label-custom"
                                        for="cargoVolumeCbm">

                                        Cargo Volume (CBM)

                                    </label>


                                    <input
                                        type="number"
                                        class="form-control"
                                        id="cargoVolumeCbm"
                                        name="cargoVolumeCbm"
                                        min="0"
                                        step="0.01"
                                        placeholder="Enter cargo volume"
                                        required
                                        oninput="validateVolume();">


                                    <div class="field-help">

                                        Maximum:
                                        <%= container.getGoodsCapacityCbm() %>
                                        CBM

                                    </div>


                                    <div
                                        id="volumeMessage"
                                        class="validation-message validation-neutral">

                                        Enter cargo volume.

                                    </div>

                                </div>


                            </div>


                            <!-- =================================================
                                 FORM ACTIONS
                                 ================================================= -->

                            <div class="form-actions">


                                <a
                                    href="<%= request.getContextPath() %>/allocation?action=view"
                                    class="cancel-button">

                                    Cancel

                                </a>


                                <button
                                    type="submit"
                                    id="allocateButton"
                                    class="allocate-button"
                                    disabled>

                                    Allocate Container

                                </button>


                            </div>


                        </form>


                    </div>


                <% } else { %>


                    <div class="security-note">

                        This container is not currently available
                        for allocation.

                    </div>


                <% } %>


            </div>


        </section>


        <!-- =====================================================
             SERVER VALIDATION NOTE
             ===================================================== -->

        <div class="security-note">

            <strong>
                Validation:
            </strong>

            The current location is taken from the container's
            current port. The selected route is supplied from the
            available route configuration. Cargo weight and cargo
            volume are checked server-side against the registered
            goods capacity. Only an Available container can be
            allocated.

        </div>


    <% } %>


</main>


<script>

    function getNumber(id) {

        var input =
            document.getElementById(id);

        if (!input ||
            input.value === "") {

            return NaN;
        }

        return parseFloat(input.value);
    }


    /* ==========================================================
       ROUTE VALIDATION
       ========================================================== */

    function validateRoute() {

        var input =
            document.getElementById("routeId");

        var message =
            document.getElementById("routeMessage");

        var preview =
            document.getElementById("destinationPreview");


        if (!input || !message) {
            return;
        }


        input.classList.remove(
            "input-valid");

        input.classList.remove(
            "input-invalid");


        if (input.value === "") {

            message.className =
                "validation-message validation-neutral";

            message.textContent =
                "Select a destination route.";


            if (preview) {

                preview.textContent =
                    "Destination Route";
            }


            updateButton();

            return;
        }


        input.classList.add(
            "input-valid");

        message.className =
            "validation-message validation-valid";

        message.textContent =
            "Destination route selected.";


        if (preview) {

            preview.textContent =
                "Route " + input.value;
        }


        updateButton();
    }


    /* ==========================================================
       WEIGHT VALIDATION
       ========================================================== */

    function validateWeight() {

        var input =
            document.getElementById(
                "cargoWeightKg");

        var message =
            document.getElementById(
                "weightMessage");

        if (!input || !message) {
            return;
        }


        var value =
            parseFloat(input.value);

        var maximum =
            parseFloat(
                document.getElementById(
                    "maxKg").value);


        input.classList.remove(
            "input-valid");

        input.classList.remove(
            "input-invalid");


        if (input.value === "") {

            message.className =
                "validation-message validation-neutral";

            message.textContent =
                "Enter cargo weight.";

            updateButton();

            return;
        }


        if (isNaN(value) ||
            !isFinite(value)) {

            input.classList.add(
                "input-invalid");

            message.className =
                "validation-message validation-invalid";

            message.textContent =
                "Enter a valid number.";

            updateButton();

            return;
        }


        if (value < 0) {

            input.classList.add(
                "input-invalid");

            message.className =
                "validation-message validation-invalid";

            message.textContent =
                "Cargo weight cannot be negative.";

            updateButton();

            return;
        }


        if (value > maximum) {

            input.classList.add(
                "input-invalid");

            message.className =
                "validation-message validation-invalid";

            message.textContent =
                "Exceeds maximum capacity of "
                + maximum
                + " KG.";

            updateButton();

            return;
        }


        input.classList.add(
            "input-valid");

        message.className =
            "validation-message validation-valid";

        message.textContent =
            "Within container capacity.";

        updateButton();
    }


    /* ==========================================================
       VOLUME VALIDATION
       ========================================================== */

    function validateVolume() {

        var input =
            document.getElementById(
                "cargoVolumeCbm");

        var message =
            document.getElementById(
                "volumeMessage");

        if (!input || !message) {
            return;
        }


        var value =
            parseFloat(input.value);

        var maximum =
            parseFloat(
                document.getElementById(
                    "maxCbm").value);


        input.classList.remove(
            "input-valid");

        input.classList.remove(
            "input-invalid");


        if (input.value === "") {

            message.className =
                "validation-message validation-neutral";

            message.textContent =
                "Enter cargo volume.";

            updateButton();

            return;
        }


        if (isNaN(value) ||
            !isFinite(value)) {

            input.classList.add(
                "input-invalid");

            message.className =
                "validation-message validation-invalid";

            message.textContent =
                "Enter a valid number.";

            updateButton();

            return;
        }


        if (value < 0) {

            input.classList.add(
                "input-invalid");

            message.className =
                "validation-message validation-invalid";

            message.textContent =
                "Cargo volume cannot be negative.";

            updateButton();

            return;
        }


        if (value > maximum) {

            input.classList.add(
                "input-invalid");

            message.className =
                "validation-message validation-invalid";

            message.textContent =
                "Exceeds maximum capacity of "
                + maximum
                + " CBM.";

            updateButton();

            return;
        }


        input.classList.add(
            "input-valid");

        message.className =
            "validation-message validation-valid";

        message.textContent =
            "Within container capacity.";

        updateButton();
    }


    /* ==========================================================
       BUTTON VALIDATION
       ========================================================== */

    function updateButton() {

        var weight =
            getNumber(
                "cargoWeightKg");

        var volume =
            getNumber(
                "cargoVolumeCbm");


        var maxKg =
            parseFloat(
                document.getElementById(
                    "maxKg").value);


        var maxCbm =
            parseFloat(
                document.getElementById(
                    "maxCbm").value);


        var routeInput =
            document.getElementById(
                "routeId");


        var routeSelected =
            routeInput &&
            routeInput.value !== "";


        var button =
            document.getElementById(
                "allocateButton");


        if (!button) {
            return;
        }


        var validWeight =
            !isNaN(weight) &&
            isFinite(weight) &&
            weight >= 0 &&
            weight <= maxKg;


        var validVolume =
            !isNaN(volume) &&
            isFinite(volume) &&
            volume >= 0 &&
            volume <= maxCbm;


        button.disabled =
            !(
                validWeight &&
                validVolume &&
                routeSelected
            );
    }


    /* ==========================================================
       FINAL FORM VALIDATION
       ========================================================== */

    function validateAllocation() {

        var weight =
            getNumber(
                "cargoWeightKg");


        var volume =
            getNumber(
                "cargoVolumeCbm");


        var maxKg =
            parseFloat(
                document.getElementById(
                    "maxKg").value);


        var maxCbm =
            parseFloat(
                document.getElementById(
                    "maxCbm").value);


        if (isNaN(weight) ||
            !isFinite(weight) ||
            weight < 0 ||
            weight > maxKg) {

            validateWeight();

            return false;
        }


        if (isNaN(volume) ||
            !isFinite(volume) ||
            volume < 0 ||
            volume > maxCbm) {

            validateVolume();

            return false;
        }


        var routeInput =
            document.getElementById(
                "routeId");


        if (!routeInput ||
            routeInput.value === "") {

            validateRoute();

            return false;
        }


        return true;
    }


    /*
     * Initialize button state.
     */
    document.addEventListener(
        "DOMContentLoaded",
        function() {

            updateButton();

        });

</script>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>