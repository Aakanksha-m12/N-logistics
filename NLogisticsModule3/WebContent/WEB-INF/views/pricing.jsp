<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="model.PricingRule" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.Set" %>

<%
    String role =
            (String) request.getAttribute("role");

    if (role == null) {
        role = "";
    }

    boolean isCustomer =
            "Customer".equals(role);

    boolean canManagePricing =
            "Super Admin".equals(role)
            || "Company Admin".equals(role);

    boolean canViewPricing =
            "Super Admin".equals(role)
            || "Company Admin".equals(role)
            || "Company Staff (Finance)".equals(role);


    /*
     * PricingController sends PricingRule[]
     */
    PricingRule[] pricingRules =
            (PricingRule[]) request.getAttribute("pricingRules");


    /*
     * Customer dropdown values are derived from
     * existing pricing rules.
     *
     * No new database fields or tables are required.
     */
    Set<String> containerTypes =
            new LinkedHashSet<String>();

    Set<String> containerSizes =
            new LinkedHashSet<String>();


    if (pricingRules != null) {

        for (PricingRule rule :
                pricingRules) {

            if (rule == null) {
                continue;
            }


            if (rule.getContainerType() != null) {

                containerTypes.add(
                    rule.getContainerType()
                );
            }


            if (rule.getContainerSize() != null) {

                containerSizes.add(
                    rule.getContainerSize()
                );
            }
        }
    }


    /*
     * Route IDs supplied by PricingController.
     */
    Long[] routeIds =
            (Long[]) request.getAttribute("routeIds");


    /*
     * Customer pricing error.
     *
     * This is set by PricingController when the selected
     * type + size + route has no applicable pricing rule.
     */
    String pricingError =
            (String) request.getAttribute("pricingError");


    /*
     * Preserve the customer's previous selections when
     * returning to this page after an unavailable selection.
     */
    String selectedType =
            request.getParameter("containerType");

    String selectedSize =
            request.getParameter("containerSize");

    String selectedRoute =
            request.getParameter("routeId");
%>


<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        N Logistics · Pricing
    </title>


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <style>

        :root {

            --paper: #F0F2F1;
            --surface: #FFFFFF;

            --ink: #10202F;
            --ink-soft: #5C6A78;
            --ink-faint: #8B96A0;

            --line: #DFE3E2;

            --cargo: #D9622B;
            --cargo-soft: #FBE7DB;

            --success: #2F7D53;

            --sidebar: #10202F;
            --sidebar-hover: #1B3041;

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

            top: 0;
            left: 0;
            bottom: 0;

            width: 245px;

            background: var(--sidebar);

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 1000;

            overflow-y: auto;

        }


        .sidebar-brand {

            padding:
                24px 20px 22px;

            border-bottom:
                1px solid rgba(255,255,255,0.10);

        }


        .nl-brand {

            color: white;

            font-size: 20px;

            font-weight: 700;

            text-decoration: none;

            display: flex;

            align-items: center;

        }


        .nl-brand:hover {
            color: white;
        }


        .nl-mark {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            width: 36px;
            height: 36px;

            margin-right: 10px;

            background: var(--cargo);

            border-radius: 7px;

            font-weight: 800;

        }


        .nl-subtitle {

            color: #AEBAC3;

            font-size: 10px;

            margin-left: 46px;

            margin-top: 5px;

            line-height: 1.4;

        }


        /* =====================================================
           SIDEBAR MENU
           ===================================================== */

        .sidebar-menu {

            padding:
                22px 12px;

            flex-grow: 1;

        }


        .sidebar-section {

            color: #71818D;

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

            color: #D7DEE3;

            text-decoration: none;

            padding:
                11px 12px;

            margin-bottom: 4px;

            font-size: 13px;

            font-weight: 600;

            border-radius: 5px;

            transition:
                background 0.15s ease,
                color 0.15s ease;

        }


        .sidebar-link:hover {

            background:
                var(--sidebar-hover);

            color: white;

        }


        .sidebar-link.active {

            background:
                var(--cargo);

            color: white;

        }


        .sidebar-icon {

            width: 27px;

            margin-right: 7px;

            text-align: center;

            font-size: 14px;

        }


        /* =====================================================
           SIDEBAR BOTTOM
           ===================================================== */

        .sidebar-bottom {

            padding:
                15px 12px 18px;

            border-top:
                1px solid rgba(255,255,255,0.10);

        }


        .sidebar-role-label {

            color: #71818D;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            padding:
                0 12px 7px;

        }


        .sidebar-role {

            color: white;

            font-size: 12px;

            font-weight: 700;

            padding:
                0 12px 15px;

        }


        /* =====================================================
           LOGOUT
           ===================================================== */

        .logout-btn {

            width: 100%;

            background: transparent;

            color: #D7DEE3;

            border:
                1px solid #40515D;

            border-radius: 5px;

            padding:
                10px 12px;

            font-size: 12px;

            font-weight: 700;

            text-align: left;

            cursor: pointer;

        }


        .logout-btn:hover {

            background: #253946;

            color: white;

        }


        /* =====================================================
           MAIN AREA
           ===================================================== */

        .nl-main {

            margin-left: 245px;

            min-height: 100vh;

        }


        /* =====================================================
           TOP BAR
           ===================================================== */

        .nl-topbar {

            height: 72px;

            background: var(--surface);

            border-bottom:
                1px solid var(--line);

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding:
                0 30px;

        }


        .topbar-title {

            font-size: 14px;

            font-weight: 700;

        }


        .topbar-role {

            color: var(--ink-soft);

            font-size: 12px;

        }


        /* =====================================================
           MAIN CONTENT
           ===================================================== */

        .nl-content {

            max-width: 1280px;

            margin: 0 auto;

            padding:
                38px 30px 60px;

        }


        /* =====================================================
           PAGE HEADER
           ===================================================== */

        .page-header {

            display: flex;

            justify-content:
                space-between;

            align-items: flex-end;

            gap: 20px;

            margin-bottom: 24px;

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

            font-size: 34px;

            font-weight: 750;

            margin-bottom: 8px;

            letter-spacing: -0.5px;

        }


        .page-description {

            color: var(--ink-soft);

            max-width: 760px;

            margin-bottom: 0;

            line-height: 1.6;

            font-size: 13px;

        }


        /* =====================================================
           HEADER ACTIONS
           ===================================================== */

        .header-actions {

            display: flex;

            gap: 9px;

            align-items: center;

        }


        .back-button {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            background: white;

            color: var(--ink);

            border:
                1px solid var(--line);

            border-radius: 5px;

            padding:
                9px 14px;

            font-size: 12px;

            font-weight: 700;

            text-decoration: none;

            white-space: nowrap;

        }


        .back-button:hover {

            background: #F7F8F8;

            color: var(--ink);

        }


        /* =====================================================
           PANEL
           ===================================================== */

        .nl-panel {

            background: var(--surface);

            border:
                1px solid var(--line);

            border-radius: 7px;

            padding: 0;

            overflow: hidden;

            box-shadow:
                0 3px 14px rgba(16, 32, 47, 0.035);

        }


        .panel-header {

            padding:
                20px 22px;

            border-bottom:
                1px solid var(--line);

            display: flex;

            justify-content:
                space-between;

            align-items: center;

            gap: 15px;

        }


        .panel-title {

            font-size: 18px;

            font-weight: 700;

            margin: 0;

        }


        .panel-description {

            color: var(--ink-soft);

            font-size: 12px;

            margin:
                4px 0 0;

        }


        /* =====================================================
           CUSTOMER PRICE FORM
           ===================================================== */

        .customer-price-panel {

            padding:
                30px 25px 35px;

        }


        .customer-intro {

            max-width: 700px;

            margin-bottom: 28px;

        }


        .customer-intro h2 {

            font-size: 22px;

            font-weight: 700;

            margin-bottom: 8px;

        }


        .customer-intro p {

            color: var(--ink-soft);

            font-size: 13px;

            line-height: 1.6;

            margin: 0;

        }


        .pricing-form {

            max-width: 850px;

        }


        .form-label-nl {

            display: block;

            color: var(--ink);

            font-size: 12px;

            font-weight: 700;

            margin-bottom: 8px;

        }


        .form-select-nl {

            width: 100%;

            min-height: 44px;

            border:
                1px solid var(--line);

            border-radius: 5px;

            padding:
                9px 12px;

            background: white;

            color: var(--ink);

            font-size: 13px;

        }


        .form-select-nl:focus {

            border-color:
                var(--cargo);

            box-shadow:
                0 0 0 0.15rem rgba(217, 98, 43, 0.12);

            outline: none;

        }


        .calculate-btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            background:
                var(--cargo);

            color: white;

            border:
                1px solid var(--cargo);

            border-radius: 5px;

            padding:
                11px 20px;

            font-size: 12px;

            font-weight: 700;

            text-decoration: none;

            cursor: pointer;

        }


        .calculate-btn:hover {

            background: #BC4F20;

            border-color: #BC4F20;

            color: white;

        }


        /* =====================================================
           PRICING ERROR MESSAGE
           ===================================================== */

        .pricing-error {

            margin-bottom: 25px;

            padding:
                15px 18px;

            background:
                #FFF4E5;

            border:
                1px solid #F0D3A8;

            border-left:
                4px solid var(--cargo);

            border-radius: 5px;

            color:
                #6B4A24;

            font-size: 13px;

            line-height: 1.6;

        }


        .pricing-error-title {

            display: block;

            color:
                #8A4B16;

            font-size: 14px;

            font-weight: 700;

            margin-bottom: 3px;

        }


        .customer-note {

            margin-top: 25px;

            padding:
                14px 18px;

            background:
                #F7F8F8;

            border:
                1px solid var(--line);

            color:
                var(--ink-soft);

            font-size: 12px;

            line-height: 1.5;

        }


        .customer-note strong {

            color: var(--ink);

        }


        /* =====================================================
           ROLE INFORMATION
           ===================================================== */

        .role-info {

            color: var(--ink-soft);

            font-size: 11px;

            white-space: nowrap;

            padding:
                6px 9px;

            background: #F7F8F8;

            border:
                1px solid var(--line);

        }


        /* =====================================================
           TABLE
           ===================================================== */

        .table-wrapper {

            width: 100%;

            overflow-x: auto;

        }


        .pricing-table {

            width: 100%;

            margin: 0;

            border-collapse: collapse;

            min-width: 850px;

        }


        .pricing-table thead th {

            background: var(--ink);

            color: white;

            border: none;

            padding:
                14px 13px;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.7px;

            white-space: nowrap;

        }


        .pricing-table tbody td {

            border-bottom:
                1px solid var(--line);

            padding:
                15px 13px;

            font-size: 13px;

            vertical-align: middle;

            color: var(--ink);

        }


        .pricing-table tbody tr:last-child td {

            border-bottom: none;

        }


        .pricing-table tbody tr:hover {

            background: #F8F9F9;

        }


        /* =====================================================
           CONTAINER TYPE
           ===================================================== */

        .type-badge {

            display: inline-block;

            padding:
                5px 8px;

            background:
                var(--cargo-soft);

            color:
                var(--cargo);

            border:
                1px solid #F1C9B5;

            font-size: 11px;

            font-weight: 700;

        }


        /* =====================================================
           SIZE
           ===================================================== */

        .size-text {

            font-weight: 700;

        }


        /* =====================================================
           ROUTE
           ===================================================== */

        .route-value {

            font-family:
                "Courier New",
                monospace;

            font-size: 12px;

            color: var(--ink-soft);

        }


        /* =====================================================
           PRICE
           ===================================================== */

        .price-value {

            font-weight: 700;

            white-space: nowrap;

        }


        .final-price {

            color:
                var(--success);

            font-weight: 800;

            white-space: nowrap;

        }


        /* =====================================================
           MULTIPLIERS
           ===================================================== */

        .multiplier {

            font-family:
                "Courier New",
                monospace;

            font-size: 12px;

            color: var(--ink-soft);

        }


        /* =====================================================
           DATES
           ===================================================== */

        .date-value {

            white-space: nowrap;

            color: var(--ink-soft);

            font-size: 12px;

        }


        /* =====================================================
           ACTIONS
           ===================================================== */

        .actions-cell {

            white-space: nowrap;

        }


        .btn-nl {

            background:
                var(--cargo);

            color: white;

            border:
                1px solid var(--cargo);

            border-radius: 5px;

            padding:
                9px 15px;

            font-size: 12px;

            font-weight: 700;

            text-decoration: none;

        }


        .btn-nl:hover {

            background: #BC4F20;

            border-color: #BC4F20;

            color: white;

        }


        .btn-edit {

            background: white;

            color: var(--cargo);

            border:
                1px solid var(--cargo);

            border-radius: 4px;

            padding:
                7px 11px;

            font-size: 11px;

            font-weight: 700;

            text-decoration: none;

            display: inline-block;

            margin-right: 5px;

        }


        .btn-edit:hover {

            background:
                var(--cargo-soft);

            color: var(--cargo);

        }


        .btn-view {

            background:
                var(--ink);

            color: white;

            border:
                1px solid var(--ink);

            border-radius: 4px;

            padding:
                7px 11px;

            font-size: 11px;

            font-weight: 700;

            text-decoration: none;

            display: inline-block;

        }


        .btn-view:hover {

            background: #243747;

            color: white;

        }


        /* =====================================================
           FINANCE VIEW ONLY
           ===================================================== */

        .view-only {

            color: var(--ink-faint);

            font-size: 11px;

            font-weight: 600;

        }


        /* =====================================================
           EMPTY STATE
           ===================================================== */

        .empty-state {

            padding:
                55px 25px;

            text-align: center;

        }


        .empty-icon {

            width: 50px;

            height: 50px;

            margin:
                0 auto 15px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                var(--cargo-soft);

            color:
                var(--cargo);

            font-size: 18px;

            font-weight: 800;

        }


        .empty-title {

            font-size: 16px;

            font-weight: 700;

            margin-bottom: 6px;

        }


        .empty-text {

            color: var(--ink-soft);

            font-size: 13px;

            margin: 0;

        }


        /* =====================================================
           INFORMATION BAR
           ===================================================== */

        .pricing-note {

            padding:
                14px 20px;

            background:
                #F7F8F8;

            border-top:
                1px solid var(--line);

            color:
                var(--ink-soft);

            font-size: 12px;

            line-height: 1.5;

        }


        .pricing-note strong {

            color: var(--ink);

        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 900px) {

            .nl-sidebar {

                width: 210px;

            }


            .nl-main {

                margin-left: 210px;

            }

        }


        @media (max-width: 750px) {

            .nl-sidebar {

                position: relative;

                width: 100%;

                min-height: auto;

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
                    28px 15px 45px;

            }


            .page-header {

                flex-direction: column;

                align-items: flex-start;

            }


            .header-actions {

                width: 100%;

            }


            .header-actions a {

                flex: 1;

                text-align: center;

                justify-content: center;

            }


            .panel-header {

                align-items: flex-start;

                flex-direction: column;

            }


            .role-info {

                white-space: normal;

            }

        }


        @media (max-width: 500px) {

            .nl-brand {

                font-size: 18px;

            }


            .nl-subtitle {

                display: none;

            }


            .nl-topbar {

                height: 62px;

            }


            .topbar-role {

                display: none;

            }


            .page-title {

                font-size: 28px;

            }

        }

    </style>

</head>


<body>


<!-- =====================================================
     SIDE NAVBAR
     ===================================================== -->

<aside class="nl-sidebar">


    <!-- BRAND -->

    <div class="sidebar-brand">

        <a
            class="nl-brand"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="nl-mark">
                N
            </span>

            Logistics

        </a>


        <div class="nl-subtitle">

            Import &amp; Export Management

        </div>

    </div>


    <!-- MENU -->

    <div class="sidebar-menu">


        <div class="sidebar-section">
            Workspace
        </div>


        <!-- DASHBOARD -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ▦
            </span>

            Dashboard

        </a>


        <!-- CONTAINERS -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/containers?action=view">

            <span class="sidebar-icon">
                ▣
            </span>

            Containers

        </a>


        <!-- ALLOCATION -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/allocation?action=view">

            <span class="sidebar-icon">
                ⇄
            </span>

            Allocation

        </a>


        <!-- PRICING -->

        <a
            class="sidebar-link active"
            href="<%= request.getContextPath() %>/pricing?action=view">

            <span class="sidebar-icon">
                ₹
            </span>

            Pricing

        </a>


        <!-- INTERNAL MODULE LINKS -->

        <% if (!isCustomer) { %>


            <!-- PRICING AUDIT -->

            <a
                class="sidebar-link"
                href="<%= request.getContextPath() %>/pricing-audit?action=view">

                <span class="sidebar-icon">
                    ≡
                </span>

                Pricing Audit

            </a>


            <!-- DEMAND FORECAST -->

            <a
                class="sidebar-link"
                href="<%= request.getContextPath() %>/forecast?action=view">

                <span class="sidebar-icon">
                    ↗
                </span>

                Demand Forecast

            </a>


            <!-- ADMINISTRATION -->

            <div class="sidebar-section mt-4">

                Administration

            </div>


            <a
                class="sidebar-link"
                href="<%= request.getContextPath() %>/containers?action=manage">

                <span class="sidebar-icon">
                    ⚙
                </span>

                Container Management

            </a>


        <% } %>


    </div>


    <!-- SIDEBAR BOTTOM -->

    <div class="sidebar-bottom">


        <div class="sidebar-role-label">

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
                class="logout-btn">

                ⇥ &nbsp; Logout

            </button>

        </form>

    </div>


</aside>


<!-- =====================================================
     MAIN AREA
     ===================================================== -->

<div class="nl-main">


    <!-- TOP BAR -->

    <header class="nl-topbar">

        <div class="topbar-title">

            Commercial Operations

        </div>


        <div class="topbar-role">

            <%= role %>

        </div>

    </header>


    <!-- =================================================
         MAIN CONTENT
         ================================================= -->

    <main class="nl-content">


        <!-- PAGE HEADER -->

        <div class="page-header">


            <div>

                <div class="page-kicker">

                    Commercial Controls

                </div>


                <h1 class="page-title">

                    Pricing

                </h1>


                <% if (isCustomer) { %>

                    <p class="page-description">

                        Select the container type, size and route
                        to view the applicable final price.

                    </p>

                <% } else { %>

                    <p class="page-description">

                        Manage and review container pricing rules,
                        validity periods and calculated final prices.

                    </p>

                <% } %>

            </div>


            <div class="header-actions">


                <!-- BACK BUTTON -->

                <a
                    href="<%= request.getContextPath() %>/app?action=home"
                    class="back-button">

                    ← Back to Dashboard

                </a>


                <% if (canManagePricing) { %>


                    <!-- ADD BUTTON -->

                    <a
                        href="<%= request.getContextPath() %>/pricing?action=addForm"
                        class="btn-nl">

                        + Add Pricing Rule

                    </a>


                <% } %>


            </div>


        </div>


        <!-- =================================================
             CUSTOMER VIEW
             ================================================= -->

        <% if (isCustomer) { %>


            <section class="nl-panel">


                <div class="panel-header">


                    <div>

                        <div class="panel-title">

                            Calculate Container Price

                        </div>


                        <p class="panel-description">

                            Choose your shipment requirements below.

                        </p>

                    </div>


                    <div class="role-info">

                        Customer Pricing

                    </div>


                </div>


                <div class="customer-price-panel">


                    <!-- =================================================
                         PRICING ERROR
                         ================================================= -->

                    <% if (pricingError != null &&
                           !pricingError.trim().isEmpty()) { %>


                        <div
                            class="pricing-error"
                            role="alert">

                            <span class="pricing-error-title">

                                ⚠ Price Not Available

                            </span>


                            <%= pricingError %>

                        </div>


                    <% } %>


                    <div class="customer-intro">

                        <h2>

                            Get Final Price

                        </h2>


                        <p>

                            Select the container type, container size
                            and route. The final price will be calculated
                            by the server using the configured pricing rule.

                        </p>

                    </div>


                    <form
                        method="get"
                        action="<%= request.getContextPath() %>/pricing"
                        class="pricing-form">


                        <input
                            type="hidden"
                            name="action"
                            value="calculate">


                        <div class="row g-4">


                            <!-- CONTAINER TYPE -->

                            <div class="col-md-4">

                                <label
                                    class="form-label-nl"
                                    for="containerType">

                                    Container Type

                                </label>


                                <select
                                    class="form-select-nl"
                                    id="containerType"
                                    name="containerType"
                                    required>


                                    <option
                                        value=""
                                        disabled
                                        <%= selectedType == null
                                            ? "selected"
                                            : "" %>>

                                        Select container type

                                    </option>


                                    <%
                                        for (String type :
                                                containerTypes) {
                                    %>

                                        <option
                                            value="<%= type %>"
                                            <%= type.equals(selectedType)
                                                ? "selected"
                                                : "" %>>

                                            <%= type %>

                                        </option>

                                    <%
                                        }
                                    %>


                                </select>

                            </div>


                            <!-- CONTAINER SIZE -->

                            <div class="col-md-4">

                                <label
                                    class="form-label-nl"
                                    for="containerSize">

                                    Container Size

                                </label>


                                <select
                                    class="form-select-nl"
                                    id="containerSize"
                                    name="containerSize"
                                    required>


                                    <option
                                        value=""
                                        disabled
                                        <%= selectedSize == null
                                            ? "selected"
                                            : "" %>>

                                        Select container size

                                    </option>


                                    <%
                                        for (String size :
                                                containerSizes) {
                                    %>

                                        <option
                                            value="<%= size %>"
                                            <%= size.equals(selectedSize)
                                                ? "selected"
                                                : "" %>>

                                            <%= size %>

                                        </option>

                                    <%
                                        }
                                    %>


                                </select>

                            </div>


                            <!-- ROUTE -->

                            <div class="col-md-4">

                                <label
                                    class="form-label-nl"
                                    for="routeId">

                                    Route

                                </label>


                                <select
                                    class="form-select-nl"
                                    id="routeId"
                                    name="routeId"
                                    required>


                                    <option
                                        value=""
                                        disabled
                                        <%= selectedRoute == null
                                            ? "selected"
                                            : "" %>>

                                        Select route

                                    </option>


                                    <%
                                        if (routeIds != null) {

                                            for (Long routeId :
                                                    routeIds) {
                                    %>

                                        <option
                                            value="<%= routeId %>"
                                            <%= String.valueOf(routeId)
                                                    .equals(selectedRoute)
                                                ? "selected"
                                                : "" %>>

                                            Route #<%= routeId %>

                                        </option>

                                    <%
                                            }
                                        }
                                    %>


                                </select>

                            </div>


                        </div>


                        <div class="mt-4">


                            <button
                                type="submit"
                                class="calculate-btn">

                                Calculate Final Price

                            </button>


                        </div>


                    </form>


                    <div class="customer-note">

                        <strong>Pricing engine:</strong>

                        The final price is calculated on the server.
                        Internal pricing components are not displayed
                        to customers.

                    </div>


                </div>


            </section>


        <% } else { %>


            <!-- =================================================
                 INTERNAL PRICING VIEW
                 ================================================= -->

            <section class="nl-panel">


                <!-- PANEL HEADER -->

                <div class="panel-header">


                    <div>

                        <div class="panel-title">

                            Active Pricing Configuration

                        </div>


                        <p class="panel-description">

                            Pricing information available according
                            to your authenticated role.

                        </p>

                    </div>


                    <div class="role-info">


                        <% if ("Super Admin".equals(role)) { %>

                            Full pricing administration

                        <% } else if ("Company Admin".equals(role)) { %>

                            Company pricing administration

                        <% } else if ("Company Staff (Finance)".equals(role)) { %>

                            Finance · View only

                        <% } else { %>

                            Restricted access

                        <% } %>


                    </div>


                </div>


                <!-- =================================================
                     TABLE
                     ================================================= -->

                <div class="table-wrapper">


                    <table class="pricing-table">


                        <thead>

                            <tr>

                                <th>
                                    Container Type
                                </th>

                                <th>
                                    Size
                                </th>

                                <th>
                                    Route
                                </th>


                                <% if (canManagePricing) { %>

                                    <th>
                                        Base Price
                                    </th>

                                    <th>
                                        Seasonal
                                    </th>

                                    <th>
                                        Demand
                                    </th>

                                <% } %>


                                <th>
                                    Final Price
                                </th>

                                <th>
                                    Valid From
                                </th>

                                <th>
                                    Valid To
                                </th>

                                <th>
                                    Actions
                                </th>

                            </tr>

                        </thead>


                        <tbody>


                        <%
                            if (pricingRules != null &&
                                pricingRules.length > 0) {

                                for (PricingRule rule :
                                        pricingRules) {
                        %>


                            <tr>


                                <!-- CONTAINER TYPE -->

                                <td>

                                    <span class="type-badge">

                                        <%= rule.getContainerType() %>

                                    </span>

                                </td>


                                <!-- SIZE -->

                                <td>

                                    <span class="size-text">

                                        <%= rule.getContainerSize() %>

                                    </span>

                                </td>


                                <!-- ROUTE -->

                                <td>

                                    <span class="route-value">

                                        Route #<%= rule.getRouteId() %>

                                    </span>

                                </td>


                                <% if (canManagePricing) { %>


                                    <!-- BASE PRICE -->

                                    <td>

                                        <span class="price-value">

                                            ₹ <%= rule.getBasePrice() %>

                                        </span>

                                    </td>


                                    <!-- SEASONAL -->

                                    <td>

                                        <span class="multiplier">

                                            × <%= rule.getSeasonalMultiplier() %>

                                        </span>

                                    </td>


                                    <!-- DEMAND -->

                                    <td>

                                        <span class="multiplier">

                                            × <%= rule.getDemandMultiplier() %>

                                        </span>

                                    </td>


                                <% } %>


                                <!-- FINAL PRICE -->

                                <td>

                                    <span class="final-price">

                                        ₹ <%= rule.getFinalPrice() %>

                                    </span>

                                </td>


                                <!-- VALID FROM -->

                                <td>

                                    <span class="date-value">

                                        <%= rule.getValidFrom() %>

                                    </span>

                                </td>


                                <!-- VALID TO -->

                                <td>

                                    <span class="date-value">

                                        <%= rule.getValidTo() %>

                                    </span>

                                </td>


                                <!-- ACTIONS -->

                                <td class="actions-cell">


                                    <% if (canManagePricing) { %>


                                        <!-- EDIT -->

                                        <a
                                            href="<%= request.getContextPath() %>/pricing?action=edit&pricingId=<%= rule.getPricingId() %>"
                                            class="btn-edit">

                                            Edit

                                        </a>


                                        <!-- VIEW -->

                                        <a
                                            href="<%= request.getContextPath() %>/pricing?action=details&pricingId=<%= rule.getPricingId() %>"
                                            class="btn-view">

                                            View

                                        </a>


                                    <% } else { %>


                                        <span class="view-only">

                                            View only

                                        </span>


                                    <% } %>


                                </td>


                            </tr>


                        <%
                                }

                            } else {
                        %>


                            <!-- EMPTY STATE -->

                            <tr>

                                <td
                                    colspan="<%= canManagePricing ? "10" : "7" %>"
                                    style="border-bottom: none;">


                                    <div class="empty-state">


                                        <div class="empty-icon">

                                            N

                                        </div>


                                        <div class="empty-title">

                                            No pricing rules available

                                        </div>


                                        <p class="empty-text">

                                            There are currently no pricing
                                            rules available for your access level.

                                        </p>


                                    </div>


                                </td>

                            </tr>


                        <%
                            }
                        %>


                        </tbody>


                    </table>


                </div>


                <!-- =================================================
                     PRICING NOTE
                     ================================================= -->

                <div class="pricing-note">


                    <strong>Pricing engine:</strong>

                    Final price is calculated on the server using
                    the configured pricing rule. Internal pricing
                    components are shown only to authorized
                    management roles.


                </div>


            </section>


        <% } %>


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