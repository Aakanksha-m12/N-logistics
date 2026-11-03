<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="controller.Csrf" %>

<%
String role = (String) request.getAttribute("role");

if (role == null) {
    role = "User";
}

/*
 * Always ensure that the current Module 3 session
 * has a CSRF token before displaying the form.
 */
String csrfToken = Csrf.ensureToken(request);
%>


<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>N Logistics · Add Pricing Rule</title>


<!-- =====================================================
     BOOTSTRAP
     ===================================================== -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- =====================================================
     N LOGISTICS DESIGN SYSTEM
     ===================================================== -->

<style>

:root {
    --paper: #F0F2F1;
    --surface: #FFFFFF;
    --ink: #10202F;
    --ink-soft: #5C6A78;
    --orange: #D9622B;
    --green: #2F7D53;
    --red: #B23A2E;
    --border: #DFE3E2;
    --soft-cargo: #FBE7DB;
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


/* =====================================================
   SIDEBAR
   ===================================================== */

.nl-sidebar {

    position: fixed;

    top: 0;
    left: 0;

    width: 245px;
    height: 100vh;

    background: var(--ink);

    display: flex;
    flex-direction: column;

    z-index: 1000;

    overflow-y: auto;
}


/* BRAND */

.nl-sidebar-brand {

    padding: 24px 20px;

    border-bottom:
        1px solid #344553;
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

    background: var(--orange);

    color: white;

    font-weight: 800;

}


.nl-subtitle {

    color: #BFC8CF;

    font-size: 10px;

    margin-top: 8px;

    line-height: 1.4;

}


/* SIDEBAR MENU */

.nl-sidebar-menu {

    padding: 20px 12px;

    flex: 1;

}


.sidebar-label {

    color: #82919C;

    font-size: 10px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 1.2px;

    padding:
        0 10px;

    margin-bottom: 8px;

}


.sidebar-link {

    display: flex;

    align-items: center;

    gap: 10px;

    width: 100%;

    padding:
        11px 12px;

    margin-bottom: 4px;

    color: #D5DDE2;

    text-decoration: none;

    font-size: 13px;

    font-weight: 600;

    border-left:
        3px solid transparent;

}


.sidebar-link:hover {

    background: #1A3142;

    color: white;

}


.sidebar-link.active {

    background: #1A3142;

    color: white;

    border-left:
        3px solid var(--orange);

}


.sidebar-icon {

    width: 22px;

    text-align: center;

    font-size: 15px;

}


/* SIDEBAR FOOTER */

.nl-sidebar-footer {

    padding:
        16px 12px;

    border-top:
        1px solid #344553;

}


.sidebar-role {

    color: #BFC8CF;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 0.8px;

    margin-bottom: 7px;

    padding:
        0 10px;

}


.sidebar-role-value {

    color: white;

    font-size: 12px;

    font-weight: 700;

    padding:
        0 10px;

    margin-bottom: 13px;

}


.logout-btn {

    width: 100%;

    background: transparent;

    color: #F1C9C2;

    border:
        1px solid #75453E;

    padding:
        10px 12px;

    font-size: 12px;

    font-weight: 700;

    text-align: left;

}


.logout-btn:hover {

    background: #422A28;

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

    min-height: 62px;

    background: white;

    border-bottom:
        1px solid var(--border);

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding:
        0 28px;

}


.topbar-title {

    color: var(--ink-soft);

    font-size: 12px;

    font-weight: 600;

}


.nl-role {

    color: var(--ink);

    font-size: 12px;

    font-weight: 700;

    border:
        1px solid var(--border);

    padding:
        7px 11px;

}


/* =====================================================
   MAIN CONTENT
   ===================================================== */

.nl-content {

    max-width: 950px;

    margin: 0 auto;

    padding:
        38px 24px 60px;

}


.page-header {

    display: flex;

    justify-content: space-between;

    align-items: flex-start;

    gap: 20px;

    margin-bottom: 25px;

}


.page-kicker {

    color: var(--orange);

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
   BACK BUTTON
   ===================================================== */

.back-button {

    display: inline-flex;

    align-items: center;

    gap: 7px;

    background: white;

    color: var(--ink);

    border:
        1px solid var(--border);

    padding:
        10px 15px;

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
        1px solid var(--border);

    border-radius: 0;

    padding: 28px;

    box-shadow:
        0 5px 18px rgba(16, 32, 47, 0.035);

}


.panel-title {

    font-size: 20px;

    font-weight: 700;

    margin-bottom: 5px;

}


.panel-description {

    color: var(--ink-soft);

    font-size: 13px;

    margin-bottom: 24px;

    line-height: 1.5;

}


/* =====================================================
   FORM
   ===================================================== */

.form-label {

    font-size: 13px;

    font-weight: 700;

    margin-bottom: 7px;

}


.form-control,
.form-select {

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        10px 12px;

    color: var(--ink);

}


.form-control:focus,
.form-select:focus {

    border-color:
        var(--orange);

    box-shadow:
        0 0 0 2px rgba(217, 98, 43, 0.12);

}


.form-help {

    color: var(--ink-soft);

    font-size: 12px;

    margin-top: 6px;

    line-height: 1.4;

}


/* =====================================================
   SECTION TITLE
   ===================================================== */

.section-title {

    font-size: 14px;

    font-weight: 700;

    margin:
        26px 0 14px;

    padding-bottom: 9px;

    border-bottom:
        1px solid var(--border);

    text-transform: uppercase;

    letter-spacing: 0.6px;

}


/* =====================================================
   INFORMATION BOX
   ===================================================== */

.info-box {

    background: #F7F8F8;

    border:
        1px solid var(--border);

    border-left:
        4px solid var(--orange);

    border-radius: 0;

    padding:
        15px 17px;

    margin-bottom: 22px;

}


.info-title {

    font-size: 13px;

    font-weight: 700;

    margin-bottom: 5px;

}


.info-text {

    color: var(--ink-soft);

    font-size: 13px;

    margin: 0;

    line-height: 1.5;

}


/* =====================================================
   ACTION BAR
   ===================================================== */

.action-bar {

    display: flex;

    justify-content: flex-end;

    gap: 10px;

    margin-top: 30px;

    padding-top: 20px;

    border-top:
        1px solid var(--border);

}


.btn-nl {

    background: var(--orange);

    color: white;

    border:
        1px solid var(--orange);

    border-radius: 0;

    padding:
        10px 18px;

    font-size: 13px;

    font-weight: 700;

}


.btn-nl:hover {

    background: #BC4F20;

    border-color: #BC4F20;

    color: white;

}


.btn-outline-nl {

    background: white;

    color: var(--ink);

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        10px 18px;

    font-size: 13px;

    font-weight: 600;

    text-decoration: none;

}


.btn-outline-nl:hover {

    background: #F7F8F8;

    color: var(--ink);

}


/* =====================================================
   MOBILE SIDEBAR
   ===================================================== */

@media (max-width: 800px) {

    .nl-sidebar {

        position: relative;

        width: 100%;

        height: auto;

    }


    .nl-sidebar-menu {

        padding:
            12px;

    }


    .nl-sidebar-footer {

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
            28px 15px 45px;

    }


    .page-header {

        flex-direction: column;

    }


    .back-button {

        width: 100%;

        justify-content: center;

    }


    .nl-panel {

        padding: 20px;

    }


    .action-bar {

        flex-direction: column;

    }


    .action-bar .btn,
    .action-bar a {

        width: 100%;

        text-align: center;

    }

}


@media (max-width: 500px) {

    .page-title {

        font-size: 28px;

    }


    .nl-topbar {

        min-height: 56px;

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

    <div class="nl-sidebar-brand">

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

    <div class="nl-sidebar-menu">


        <div class="sidebar-label">
            Navigation
        </div>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ▦
            </span>

            Dashboard

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/containers?action=view">

            <span class="sidebar-icon">
                □
            </span>

            Containers

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/allocation?action=view">

            <span class="sidebar-icon">
                ⇄
            </span>

            Allocation

        </a>


        <a
            class="sidebar-link active"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ₹
            </span>

            Pricing

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing-audit?action=view">

            <span class="sidebar-icon">
                ≡
            </span>

            Pricing Audit

        </a>


        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/forecast?action=view">

            <span class="sidebar-icon">
                ↗
            </span>

            Demand Forecast

        </a>

    </div>


    <!-- SIDEBAR FOOTER -->

    <div class="nl-sidebar-footer">


        <div class="sidebar-role">
            Signed in as
        </div>


        <div class="sidebar-role-value">

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

    <div class="nl-topbar">


        <div class="topbar-title">

            Commercial Controls / Pricing / Add Rule

        </div>


        <div class="nl-role">

            <%= role %>

        </div>

    </div>


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

                    Add Pricing Rule

                </h1>


                <p class="page-description">

                    Configure the pricing values used by the
                    logistics pricing engine.

                </p>

            </div>


            <!-- BACK BUTTON -->

            <a
                class="back-button"
                href="<%= request.getContextPath() %>/app?action=home">

                ← Back to Pricing

            </a>

        </div>


        <!-- =================================================
             PRICING PANEL
             ================================================= -->

        <section class="nl-panel">


            <div class="panel-title">

                Pricing Configuration

            </div>


            <div class="panel-description">

                Enter the rule inputs below. The final price
                is calculated by the server and must not be
                entered manually.

            </div>


            <!-- =================================================
                 CALCULATION INFORMATION
                 ================================================= -->

            <div class="info-box">

                <div class="info-title">

                    Automatic price calculation

                </div>


                <p class="info-text">

                    Final Price =
                    Base Price × Seasonal Multiplier ×
                    Demand Multiplier
            + Configured Surcharge

                </p>

            </div>


            <!-- =================================================
                 FORM
                 ================================================= -->

            <form
                method="post"
                action="<%= request.getContextPath() %>/pricing">


                <!-- ACTION -->

                <input
                    type="hidden"
                    name="action"
                    value="add">


                <!-- CSRF TOKEN -->

                <input
                    type="hidden"
                    name="csrfToken"
                    value="<%= csrfToken %>">


                <!-- =================================================
                     CONTAINER & ROUTE
                     ================================================= -->

                <div class="section-title">

                    Container &amp; Route

                </div>


                <div class="row g-3">


                    <!-- CONTAINER TYPE -->

                    <div class="col-md-6">

                        <label
                            class="form-label"
                            for="containerType">

                            Container Type

                        </label>


                        <select
                            class="form-select"
                            id="containerType"
                            name="containerType"
                            required>

                            <option value="">
                                Select container type
                            </option>

                            <option value="Dry">
                                Dry
                            </option>

                            <option value="Reefer">
                                Reefer
                            </option>

                            <option value="Open Top">
                                Open Top
                            </option>

                            <option value="Flat Rack">
                                Flat Rack
                            </option>

                            <option value="Tank">
                                Tank
                            </option>

                        </select>

                    </div>


                    <!-- CONTAINER SIZE -->

                    <div class="col-md-6">

                        <label
                            class="form-label"
                            for="containerSize">

                            Container Size

                        </label>


                        <select
                            class="form-select"
                            id="containerSize"
                            name="containerSize"
                            required>

                            <option value="">
                                Select container size
                            </option>

                            <option value="20ft">
                                20ft
                            </option>

                            <option value="40ft">
                                40ft
                            </option>

                            <option value="40ft HC">
                                40ft HC
                            </option>

                            <option value="45ft">
                                45ft
                            </option>

                        </select>

                    </div>


                    <!-- ROUTE -->

                    <div class="col-md-6">

                        <label
                            class="form-label"
                            for="routeId">

                            Route

                        </label>


                        <select
                            class="form-select"
                            id="routeId"
                            name="routeId"
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

                                <option value="<%= routeId %>">
                                    Route #<%= routeId %>
                                </option>

                            <%
                                    }
                                }
                            %>

                        </select>


                        <div class="form-help">

                            Enter the existing route ID.

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     PRICING VALUES
                     ================================================= -->

                <div class="section-title">

                    Pricing Values

                </div>


                <div class="row g-3">


                    <!-- BASE PRICE -->

                    <div class="col-md-4">

                        <label
                            class="form-label"
                            for="basePrice">

                            Base Price

                        </label>


                        <input
                            type="number"
                            class="form-control"
                            id="basePrice"
                            name="basePrice"
                            min="0"
                            step="0.01"
                            required>


                        <div class="form-help">

                            Base price before multipliers.

                        </div>

                    </div>


                    <!-- SEASONAL MULTIPLIER -->

                    <div class="col-md-4">

                        <label
                            class="form-label"
                            for="seasonalMultiplier">

                            Seasonal Multiplier

                        </label>


                        <input
                            type="number"
                            class="form-control"
                            id="seasonalMultiplier"
                            name="seasonalMultiplier"
                            min="0"
                            step="0.0001"
                            required>


                        <div class="form-help">

                            Seasonal pricing factor.

                        </div>

                    </div>


                    <!-- DEMAND MULTIPLIER -->

                    <div class="col-md-4">

                        <label
                            class="form-label"
                            for="demandMultiplier">

                            Demand Multiplier

                        </label>


                        <input
                            type="number"
                            class="form-control"
                            id="demandMultiplier"
                            name="demandMultiplier"
                            min="0"
                            step="0.0001"
                            required>


                        <div class="form-help">

                            Demand pricing factor.

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     VALIDITY PERIOD
                     ================================================= -->

                <div class="section-title">

                    Validity Period

                </div>


                <div class="row g-3">


                    <!-- VALID FROM -->

                    <div class="col-md-6">

                        <label
                            class="form-label"
                            for="validFrom">

                            Valid From

                        </label>


                        <input
                            type="date"
                            class="form-control"
                            id="validFrom"
                            name="validFrom"
                            required>

                    </div>


                    <!-- VALID TO -->

                    <div class="col-md-6">

                        <label
                            class="form-label"
                            for="validTo">

                            Valid To

                        </label>


                        <input
                            type="date"
                            class="form-control"
                            id="validTo"
                            name="validTo"
                            required>

                    </div>

                </div>


                <!-- =================================================
                     ACTIONS
                     ================================================= -->

                <div class="action-bar">


                    <a
                        class="btn-outline-nl"
                        href="<%= request.getContextPath() %>/app?action=home">

                        Cancel

                    </a>


                    <button
                        type="submit"
                        class="btn btn-nl">

                        Save Pricing Rule

                    </button>


                </div>


            </form>

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
