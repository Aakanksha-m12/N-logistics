<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="model.DemandForecast" %>

<%
    String role =
            (String) request.getAttribute("role");

    if (role == null) {
        role = "";
    }

    boolean canViewForecast =
            "Super Admin".equals(role)
            || "Company Admin".equals(role);

    DemandForecast[] forecasts =
            (DemandForecast[]) request.getAttribute("forecasts");

    DemandForecast[] priceTrend =
            (DemandForecast[]) request.getAttribute("priceTrend");

    String selectedContainerType =
            (String) request.getAttribute("containerType");

    Object selectedRouteId =
            request.getAttribute("routeId");

    Object selectedPeriods =
            request.getAttribute("numberOfPeriods");

    if (selectedContainerType == null) {
        selectedContainerType = "";
    }

    if (selectedPeriods == null) {
        selectedPeriods = 6;
    }

    boolean hasForecastData =
            priceTrend != null &&
            priceTrend.length > 0;
%>


<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>N Logistics · Demand Forecast</title>


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         CHART.JS
         ===================================================== -->

    <script
        src="https://cdn.jsdelivr.net/npm/chart.js">
    </script>


    <!-- =====================================================
         N LOGISTICS DESIGN SYSTEM
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

            --hold: #B23A2E;

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
           SIDEBAR BRAND
           ===================================================== */

        .sidebar-brand {

            padding:
                23px 21px;

            border-bottom:
                1px solid #33424E;
        }


        .sidebar-brand-link {

            display: flex;

            align-items: center;

            color: white;

            text-decoration: none;

            font-size: 20px;

            font-weight: 700;
        }


        .sidebar-brand-link:hover {

            color: white;
        }


        .sidebar-mark {

            width: 35px;

            height: 35px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            background: var(--cargo);

            margin-right: 10px;

            font-weight: 800;
        }


        .sidebar-subtitle {

            color: #AEB9C1;

            font-size: 9px;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            margin-top: 7px;

            margin-left: 45px;
        }


        /* =====================================================
           SIDEBAR NAVIGATION
           ===================================================== */

        .sidebar-nav {

            flex: 1;

            padding:
                22px 12px;
        }


        .sidebar-section-label {

            color: #7F8C96;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.2px;

            padding:
                0 12px 10px;
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


        .sidebar-icon {

            width: 27px;

            height: 27px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            border:
                1px solid #4A5965;

            color: #D7DEE3;

            font-size: 10px;

            flex-shrink: 0;
        }


        /* =====================================================
           SIDEBAR FOOTER
           ===================================================== */

        .sidebar-footer {

            border-top:
                1px solid #33424E;

            padding:
                16px;
        }


        .sidebar-role-label {

            color: #7F8C96;

            font-size: 9px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1px;

            margin-bottom: 5px;
        }


        .sidebar-role {

            color: #E1E7EB;

            font-size: 12px;

            font-weight: 700;

            margin-bottom: 13px;
        }


        .logout-form {

            margin: 0;
        }


        .logout-button {

            width: 100%;

            padding:
                10px 12px;

            background: transparent;

            border:
                1px solid #566571;

            color: #D7DEE3;

            font-size: 11px;

            font-weight: 700;

            text-align: left;

            cursor: pointer;
        }


        .logout-button:hover {

            background: #1C303F;

            border-color:
                var(--cargo);

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

            min-height: 72px;

            background: var(--surface);

            border-bottom:
                1px solid var(--line);

            padding:
                0 30px;

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .topbar-title {

            font-size: 13px;

            font-weight: 700;

            color: var(--ink);
        }


        .topbar-subtitle {

            color: var(--ink-soft);

            font-size: 11px;

            margin-top: 3px;
        }


        .topbar-role {

            color: var(--ink-soft);

            font-size: 11px;

            font-weight: 700;

            border:
                1px solid var(--line);

            padding:
                7px 11px;
        }


        /* =====================================================
           MAIN CONTENT
           ===================================================== */

        .nl-content {

            max-width: 1280px;

            margin: 0 auto;

            padding:
                38px 24px 60px;
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

            font-size: 12px;

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
        }


        /* =====================================================
           HEADER ACTIONS
           ===================================================== */

        .page-actions {

            display: flex;

            align-items: center;

            gap: 10px;

            flex-wrap: wrap;
        }


        .back-button {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            background: white;

            color: var(--ink);

            border:
                1px solid var(--line);

            padding:
                10px 15px;

            text-decoration: none;

            font-size: 11px;

            font-weight: 700;

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

            border-radius: 0;

            padding: 0;

            overflow: hidden;

            margin-bottom: 24px;
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
           FILTER PANEL
           ===================================================== */

        .filter-body {

            padding:
                22px;
        }


        .form-label {

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.7px;

            color: var(--ink);
        }


        .form-control,
        .form-select {

            border:
                1px solid var(--line);

            border-radius: 0;

            min-height: 42px;

            font-size: 13px;

            color: var(--ink);
        }


        .form-control:focus,
        .form-select:focus {

            border-color:
                var(--cargo);

            box-shadow:
                0 0 0 0.15rem
                rgba(217, 98, 43, 0.12);
        }


        /* =====================================================
           BUTTONS
           ===================================================== */

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

            text-decoration: none;
        }


        .btn-nl:hover {

            background:
                var(--cargo-dark);

            border-color:
                var(--cargo-dark);

            color: white;
        }


        .btn-outline-nl {

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


        .btn-outline-nl:hover {

            background: #F7F8F8;

            color: var(--ink);
        }


        /* =====================================================
           STATUS
           ===================================================== */

        .status-badge {

            display: inline-block;

            padding:
                6px 9px;

            font-size: 11px;

            font-weight: 700;

            border:
                1px solid #B9D9C7;

            background: #EDF7F1;

            color: var(--success);
        }


        .status-empty {

            border-color:
                #F1C9B5;

            background:
                var(--cargo-soft);

            color:
                var(--cargo);
        }


        /* =====================================================
           SUMMARY STRIP
           ===================================================== */

        .summary-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            border-bottom:
                1px solid var(--line);
        }


        .summary-item {

            padding:
                20px 22px;

            border-right:
                1px solid var(--line);
        }


        .summary-item:last-child {

            border-right: none;
        }


        .summary-label {

            color: var(--ink-faint);

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            margin-bottom: 7px;
        }


        .summary-value {

            font-size: 21px;

            font-weight: 800;

            color: var(--ink);
        }


        .summary-sub {

            color: var(--ink-soft);

            font-size: 11px;

            margin-top: 3px;
        }


        /* =====================================================
           GRAPH
           ===================================================== */

        .chart-container {

            position: relative;

            height: 390px;

            padding:
                25px;
        }


        .chart-title {

            padding:
                20px 22px 0;

            font-size: 16px;

            font-weight: 700;
        }


        .chart-description {

            padding:
                4px 22px 0;

            color: var(--ink-soft);

            font-size: 11px;
        }


        /* =====================================================
           TABLE
           ===================================================== */

        .table-wrapper {

            width: 100%;

            overflow-x: auto;
        }


        .forecast-table {

            width: 100%;

            margin: 0;

            border-collapse: collapse;

            min-width: 850px;
        }


        .forecast-table thead th {

            background: var(--ink);

            color: white;

            border: none;

            padding:
                14px 13px;

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.7px;

            white-space: nowrap;
        }


        .forecast-table tbody td {

            border-bottom:
                1px solid var(--line);

            padding:
                15px 13px;

            font-size: 13px;

            vertical-align: middle;

            color: var(--ink);
        }


        .forecast-table tbody tr:last-child td {

            border-bottom: none;
        }


        .forecast-table tbody tr:hover {

            background: #F8F9F9;
        }


        .period-value {

            font-weight: 700;
        }


        .route-value {

            font-family:
                "Courier New",
                monospace;

            font-size: 12px;

            color: var(--ink-soft);
        }


        .demand-value {

            font-weight: 800;
        }


        .price-value {

            color: var(--success);

            font-weight: 800;

            white-space: nowrap;
        }


        .algorithm-value {

            display: inline-block;

            padding:
                4px 7px;

            background: #F7F8F8;

            border:
                1px solid var(--line);

            color: var(--ink-soft);

            font-family:
                "Courier New",
                monospace;

            font-size: 11px;
        }


        .generated-value {

            color: var(--ink-soft);

            font-size: 11px;

            white-space: nowrap;
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

            width: 44px;

            height: 44px;

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

            margin: 0 auto;

            max-width: 620px;

            line-height: 1.6;
        }


        /* =====================================================
           INFORMATION BAR
           ===================================================== */

        .forecast-note {

            padding:
                14px 20px;

            background: #F7F8F8;

            border-top:
                1px solid var(--line);

            color: var(--ink-soft);

            font-size: 12px;

            line-height: 1.5;
        }


        .forecast-note strong {

            color: var(--ink);
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 900px) {

            :root {
                --sidebar-width: 210px;
            }


            .nl-topbar {

                padding:
                    0 20px;
            }


            .nl-content {

                padding:
                    28px 20px 50px;
            }


            .page-header {

                flex-direction: column;

                align-items: flex-start;
            }


            .summary-grid {

                grid-template-columns: 1fr;
            }


            .summary-item {

                border-right: none;

                border-bottom:
                    1px solid var(--line);
            }


            .summary-item:last-child {

                border-bottom: none;
            }


            .panel-header {

                align-items: flex-start;

                flex-direction: column;
            }


            .chart-container {

                height: 320px;

                padding: 15px;
            }

        }


        @media (max-width: 700px) {

            .nl-sidebar {

                position: relative;

                width: 100%;

                height: auto;
            }


            .sidebar-nav {

                padding:
                    12px;
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


            .sidebar-role {

                margin-bottom: 0;
            }


            .logout-button {

                width: auto;
            }


            .nl-main {

                margin-left: 0;
            }


            .nl-topbar {

                min-height: 65px;

                padding:
                    14px 18px;
            }

        }


        @media (max-width: 500px) {

            .nl-brand {

                font-size: 18px;
            }


            .nl-subtitle {

                display: none;
            }


            .nl-role {

                font-size: 11px;

                padding:
                    6px 8px;
            }


            .page-title {

                font-size: 28px;
            }


            .page-actions {

                width: 100%;
            }


            .back-button {

                width: 100%;
            }

        }

    </style>

</head>


<body>


<!-- =====================================================
     SIDE NAVIGATION
     ===================================================== -->

<aside class="nl-sidebar">


    <!-- BRAND -->

    <div class="sidebar-brand">

        <a
            class="sidebar-brand-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-mark">
                N
            </span>

            Logistics

        </a>


        <div class="sidebar-subtitle">

            Import &amp; Export Management

        </div>

    </div>


    <!-- NAVIGATION -->

    <div class="sidebar-nav">


        <div class="sidebar-section-label">

            Navigation

        </div>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                H
            </span>

            Dashboard

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/containers?action=view">

            <span class="sidebar-icon">
                C
            </span>

            Containers

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing?action=view">

            <span class="sidebar-icon">
                P
            </span>

            Pricing

        </a>


        <a
            class="sidebar-link active"
            href="<%= request.getContextPath() %>/forecast?action=view">

            <span class="sidebar-icon">
                F
            </span>

            Demand Forecast

        </a>

    </div>


    <!-- SIDEBAR FOOTER -->

    <div class="sidebar-footer">


        <div>

            <div class="sidebar-role-label">

                Signed in as

            </div>


            <div class="sidebar-role">

                <%= role %>

            </div>

        </div>


        <!-- LOGOUT BUTTON -->

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
     MAIN AREA
     ===================================================== -->

<div class="nl-main">


    <!-- =================================================
         TOP BAR
         ================================================= -->

    <header class="nl-topbar">


        <div>

            <div class="topbar-title">

                Demand Forecast

            </div>


            <div class="topbar-subtitle">

                Demand intelligence &amp; pricing analysis

            </div>

        </div>


        <div class="topbar-role">

            <%= role %>

        </div>

    </header>


    <!-- =================================================
         MAIN CONTENT
         ================================================= -->

    <main class="nl-content">


        <!-- =================================================
             PAGE HEADER
             ================================================= -->

        <div class="page-header">


            <div>

                <div class="page-kicker">
                    Demand Intelligence
                </div>


                <h1 class="page-title">
                    Demand Forecast
                </h1>


                <p class="page-description">

                    Review future container demand and forecasted
                    pricing generated from historical demand data.

                </p>

            </div>


            <div class="page-actions">


                <!-- BACK BUTTON -->

                <a
                    href="<%= request.getContextPath() %>/app?action=home"
                    class="back-button">

                    ← Back to Dashboard

                </a>


                <div>

                    <% if (hasForecastData) { %>

                        <span class="status-badge">

                            Forecast data available

                        </span>

                    <% } else { %>

                        <span class="status-badge status-empty">

                            No forecast generated

                        </span>

                    <% } %>

                </div>

            </div>

        </div>


        <!-- =================================================
             FORECAST FILTER PANEL
             ================================================= -->

        <section class="nl-panel">


            <div class="panel-header">

                <div>

                    <div class="panel-title">

                        Forecast Parameters

                    </div>


                    <p class="panel-description">

                        Select the container type, route and number
                        of future periods to review.

                    </p>

                </div>

            </div>


            <div class="filter-body">


                <form
                    method="get"
                    action="<%= request.getContextPath() %>/forecast">


                    <input
                        type="hidden"
                        name="action"
                        value="view">


                    <div class="row g-3 align-items-end">


                        <!-- CONTAINER TYPE -->

                        <div class="col-md-4">

                            <label
                                class="form-label">

                                Container Type

                            </label>


                            <select
                                name="containerType"
                                class="form-select"
                                required>


                                <option
                                    value=""
                                    <%= selectedContainerType.isEmpty()
                                        ? "selected" : "" %>>

                                    Select container type

                                </option>


                                <option
                                    value="Dry"
                                    <%= "Dry".equals(
                                            selectedContainerType)
                                        ? "selected" : "" %>>

                                    Dry

                                </option>


                                <option
                                    value="Reefer"
                                    <%= "Reefer".equals(
                                            selectedContainerType)
                                        ? "selected" : "" %>>

                                    Reefer

                                </option>


                                <option
                                    value="Open Top"
                                    <%= "Open Top".equals(
                                            selectedContainerType)
                                        ? "selected" : "" %>>

                                    Open Top

                                </option>


                                <option
                                    value="Flat Rack"
                                    <%= "Flat Rack".equals(
                                            selectedContainerType)
                                        ? "selected" : "" %>>

                                    Flat Rack

                                </option>


                                <option
                                    value="Tank"
                                    <%= "Tank".equals(
                                            selectedContainerType)
                                        ? "selected" : "" %>>

                                    Tank

                                </option>


                            </select>

                        </div>


                        <!-- ROUTE -->

                        <div class="col-md-4">

                            <label
                                class="form-label">

                                Route

                            </label>


                            <select
                                name="routeId"
                                class="form-select"
                                required>

                                <option value="">
                                    Select route
                                </option>

                                <%
                                    Long[] routeIds =
                                            (Long[]) request.getAttribute("routeIds");

                                    if (routeIds != null) {
                                        for (Long routeId : routeIds) {
                                %>

                                    <option
                                        value="<%= routeId %>"
                                        <%= selectedRouteId != null
                                            && routeId.toString().equals(
                                                    selectedRouteId.toString())
                                            ? "selected" : "" %>>
                                        Route #<%= routeId %>
                                    </option>

                                <%
                                        }
                                    }
                                %>

                            </select>

                        </div>


                        <!-- PERIODS -->

                        <div class="col-md-2">

                            <label
                                class="form-label">

                                Periods

                            </label>


                            <input
                                type="number"
                                name="periods"
                                class="form-control"
                                value="<%= selectedPeriods %>"
                                min="1"
                                max="24"
                                required>

                        </div>


                        <!-- BUTTON -->

                        <div class="col-md-2">

                            <button
                                type="submit"
                                class="btn-nl w-100">

                                View Forecast

                            </button>

                        </div>


                    </div>


                </form>

            </div>

        </section>


        <% if (hasForecastData) { %>


        <!-- =================================================
             SUMMARY
             ================================================= -->

        <section class="nl-panel">


            <div class="summary-grid">


                <div class="summary-item">

                    <div class="summary-label">

                        Container Type

                    </div>


                    <div class="summary-value">

                        <%= selectedContainerType %>

                    </div>


                    <div class="summary-sub">

                        Selected forecast category

                    </div>

                </div>


                <div class="summary-item">

                    <div class="summary-label">

                        Route

                    </div>


                    <div class="summary-value">

                        #<%= selectedRouteId %>

                    </div>


                    <div class="summary-sub">

                        Selected logistics route

                    </div>

                </div>


                <div class="summary-item">

                    <div class="summary-label">

                        Forecast Horizon

                    </div>


                    <div class="summary-value">

                        <%= priceTrend.length %>

                    </div>


                    <div class="summary-sub">

                        Future periods available

                    </div>

                </div>


            </div>


        </section>


        <!-- =================================================
             GRAPH
             ================================================= -->

        <section class="nl-panel">


            <div class="panel-header">

                <div>

                    <div class="panel-title">

                        Future Demand &amp; Price

                    </div>


                    <p class="panel-description">

                        Forecasted demand and corresponding
                        forecasted price for future periods.

                    </p>

                </div>

            </div>


            <div class="chart-title">

                Forecast Trend

            </div>


            <div class="chart-description">

                Demand is shown on the left axis and forecasted
                price is shown on the right axis.

            </div>


            <div class="chart-container">

                <canvas id="forecastChart">
                </canvas>

            </div>


        </section>


        <!-- =================================================
             FORECAST TABLE
             ================================================= -->

        <section class="nl-panel">


            <div class="panel-header">

                <div>

                    <div class="panel-title">

                        Forecast Details

                    </div>


                    <p class="panel-description">

                        Future forecast records currently available
                        for the selected container and route.

                    </p>

                </div>

            </div>


            <div class="table-wrapper">


                <table class="forecast-table">


                    <thead>

                        <tr>

                            <th>
                                Forecast Period
                            </th>

                            <th>
                                Container Type
                            </th>

                            <th>
                                Route
                            </th>

                            <th>
                                Forecasted Demand
                            </th>

                            <th>
                                Forecasted Price
                            </th>

                            <th>
                                Algorithm
                            </th>

                            <th>
                                Generated
                            </th>

                        </tr>

                    </thead>


                    <tbody>


                    <%
                        for (DemandForecast forecast :
                                priceTrend) {
                    %>


                        <tr>


                            <td>

                                <span class="period-value">

                                    <%= forecast.getForecastPeriod() %>

                                </span>

                            </td>


                            <td>

                                <%= forecast.getContainerType() %>

                            </td>


                            <td>

                                <span class="route-value">

                                    Route #<%= forecast.getRouteId() %>

                                </span>

                            </td>


                            <td>

                                <span class="demand-value">

                                    <%= forecast.getForecastedDemand() %>

                                </span>

                            </td>


                            <td>

                                <span class="price-value">

                                    ₹ <%= forecast.getForecastedPrice() %>

                                </span>

                            </td>


                            <td>

                                <span class="algorithm-value">

                                    <%= forecast.getAlgorithmVersion() %>

                                </span>

                            </td>


                            <td>

                                <span class="generated-value">

                                    <%= forecast.getGeneratedAt() %>

                                </span>

                            </td>


                        </tr>


                    <%
                        }
                    %>


                    </tbody>


                </table>

            </div>


            <div class="forecast-note">

                <strong>Forecasting engine:</strong>

                Future demand is produced by the forecasting
                algorithm from historical demand supplied by the
                appropriate historical-data source. Forecasted
                price is calculated by the server using the
                configured pricing rule.

            </div>


        </section>


        <% } else { %>


        <!-- =================================================
             EMPTY STATE
             ================================================= -->

        <section class="nl-panel">


            <div class="empty-state">


                <div class="empty-icon">

                    N

                </div>


                <div class="empty-title">

                    No forecast data available

                </div>


                <p class="empty-text">

                    Select a container type, route and forecast
                    horizon above. Forecast records will appear
                    here after legitimate historical demand data
                    has been processed by the forecasting engine.

                </p>


            </div>


            <div class="forecast-note">

                <strong>Data source:</strong>

                Forecast calculations require actual historical
                demand data. No historical values are fabricated
                by this module.

            </div>


        </section>


        <% } %>


    </main>

</div>


<!-- =====================================================
     CHART DATA
     ===================================================== -->

<%
    if (hasForecastData) {

        StringBuilder labels =
                new StringBuilder();

        StringBuilder demandData =
                new StringBuilder();

        StringBuilder priceData =
                new StringBuilder();


        for (int i = 0;
             i < priceTrend.length;
             i++) {

            DemandForecast forecast =
                    priceTrend[i];


            if (i > 0) {

                labels.append(",");

                demandData.append(",");

                priceData.append(",");
            }


            labels.append("\"")
                  .append(
                      forecast.getForecastPeriod()
                  )
                  .append("\"");


            demandData.append(
                    forecast.getForecastedDemand()
            );


            priceData.append(
                    forecast.getForecastedPrice()
            );

        }
%>


<script>

    const forecastLabels = [
        <%= labels.toString() %>
    ];


    const demandData = [
        <%= demandData.toString() %>
    ];


    const priceData = [
        <%= priceData.toString() %>
    ];


    const forecastCanvas =
        document.getElementById(
            "forecastChart"
        );


    if (forecastCanvas) {

        new Chart(
            forecastCanvas,
            {

                type: "line",

                data: {

                    labels: forecastLabels,

                    datasets: [

                        {

                            label:
                                "Forecasted Demand",

                            data:
                                demandData,

                            yAxisID:
                                "demandAxis",

                            tension: 0.25,

                            borderWidth: 2,

                            pointRadius: 4

                        },


                        {

                            label:
                                "Forecasted Price",

                            data:
                                priceData,

                            yAxisID:
                                "priceAxis",

                            tension: 0.25,

                            borderWidth: 2,

                            pointRadius: 4

                        }

                    ]

                },


                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    interaction: {

                        mode: "index",

                        intersect: false

                    },


                    plugins: {

                        legend: {

                            position: "top"

                        }

                    },


                    scales: {

                        demandAxis: {

                            type: "linear",

                            position: "left",

                            title: {

                                display: true,

                                text:
                                    "Forecasted Demand"

                            }

                        },


                        priceAxis: {

                            type: "linear",

                            position: "right",

                            title: {

                                display: true,

                                text:
                                    "Forecasted Price (₹)"

                            },


                            grid: {

                                drawOnChartArea: false

                            }

                        }

                    }

                }

            }

        );

    }

</script>


<%
    }
%>


<!-- =====================================================
     BOOTSTRAP JAVASCRIPT
     ===================================================== -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>