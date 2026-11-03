<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="model.PricingRule"%>
<%@ page import="controller.Csrf"%>

<%
String role = (String) request.getAttribute("role");

if (role == null) {
    role = "User";
}

PricingRule pricingRule =
        (PricingRule) request.getAttribute("pricingRule");

boolean isSuperAdmin =
        "Super Admin".equals(role);

boolean isCompanyAdmin =
        "Company Admin".equals(role);

boolean canManagePricing =
        isSuperAdmin || isCompanyAdmin;

String csrfToken = Csrf.ensureToken(request);
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
    content="width=device-width, initial-scale=1.0">

<title>N Logistics · Update Pricing Rule</title>

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
    --orange: #D9622B;
    --orange-soft: #FBE7DB;
    --green: #2F7D53;
    --border: #DFE3E2;
    --sidebar-hover: #1A3142;
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

    left: 0;
    top: 0;

    width: 245px;
    height: 100vh;

    background: var(--ink);

    display: flex;
    flex-direction: column;

    z-index: 1000;

    overflow-y: auto;
}


/* =====================================================
   SIDEBAR BRAND
   ===================================================== */

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

    font-weight: 800;
}

.nl-subtitle {

    color: #BFC8CF;

    font-size: 10px;

    margin-top: 8px;

    line-height: 1.4;
}


/* =====================================================
   SIDEBAR MENU
   ===================================================== */

.nl-sidebar-menu {

    flex: 1;

    padding:
        20px 12px;
}

.sidebar-label {

    color: #82919C;

    font-size: 10px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 1.2px;

    padding:
        0 10px;

    margin-bottom: 9px;
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

    background:
        var(--sidebar-hover);

    color: white;
}

.sidebar-link.active {

    background:
        var(--sidebar-hover);

    color: white;

    border-left:
        3px solid var(--orange);
}

.sidebar-icon {

    width: 22px;

    text-align: center;

    font-size: 15px;
}


/* =====================================================
   SIDEBAR FOOTER
   ===================================================== */

.nl-sidebar-footer {

    padding:
        16px 12px;

    border-top:
        1px solid #344553;
}

.sidebar-role {

    color: #82919C;

    font-size: 10px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 0.8px;

    padding:
        0 10px;

    margin-bottom: 6px;
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

    cursor: pointer;
}

.logout-btn:hover {

    background:
        #422A28;

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
   CONTENT
   ===================================================== */

.nl-content {

    max-width: 950px;

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

    align-items:
        flex-start;

    gap: 20px;

    margin-bottom:
        25px;
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

    background:
        #F7F8F8;

    color: var(--ink);
}


/* =====================================================
   PANEL
   ===================================================== */

.nl-panel {

    background:
        var(--surface);

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        28px;

    box-shadow:
        0 5px 18px
        rgba(16, 32, 47, 0.035);
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
   INFO BOX
   ===================================================== */

.info-box {

    background:
        #F7F8F8;

    border:
        1px solid var(--border);

    border-left:
        4px solid var(--orange);

    padding:
        16px 18px;

    margin-bottom:
        24px;
}

.info-title {

    font-size: 12px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: .7px;

    margin-bottom: 6px;
}

.info-text {

    color: var(--ink-soft);

    font-size: 13px;

    margin: 0;

    font-family:
        "Courier New",
        monospace;
}


/* =====================================================
   SECTION TITLES
   ===================================================== */

.section-title {

    font-size: 13px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: .8px;

    margin:
        26px 0 14px;

    padding-bottom:
        9px;

    border-bottom:
        1px solid var(--border);
}


/* =====================================================
   FORM
   ===================================================== */

.form-label {

    font-size: 11px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: .6px;

    margin-bottom: 7px;
}

.form-control,
.form-select {

    min-height: 43px;

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        10px 12px;

    font-size: 13px;

    color: var(--ink);
}

.form-control:focus,
.form-select:focus {

    border-color:
        var(--orange);

    box-shadow:
        0 0 0 2px
        rgba(217, 98, 43, 0.12);
}

.form-help {

    color:
        var(--ink-soft);

    font-size: 11px;

    margin-top: 6px;

    line-height: 1.5;
}

.readonly-value {

    background:
        #F7F8F8;
}


/* =====================================================
   ACTION BAR
   ===================================================== */

.action-bar {

    display: flex;

    justify-content:
        space-between;

    align-items: center;

    gap: 12px;

    margin-top:
        28px;

    padding-top:
        20px;

    border-top:
        1px solid var(--border);
}

.btn-nl {

    background:
        var(--orange);

    color: white;

    border:
        1px solid var(--orange);

    border-radius: 0;

    padding:
        10px 18px;

    font-size: 12px;

    font-weight: 700;

    cursor: pointer;
}

.btn-nl:hover {

    background:
        #BC4F20;

    border-color:
        #BC4F20;

    color: white;
}

.btn-outline-nl {

    background:
        white;

    color:
        var(--ink);

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        10px 18px;

    font-size: 12px;

    font-weight: 700;

    text-decoration: none;
}

.btn-outline-nl:hover {

    background:
        #F7F8F8;

    color:
        var(--ink);
}


/* =====================================================
   EMPTY STATE
   ===================================================== */

.empty-state {

    text-align:
        center;

    padding:
        60px 20px;

    color:
        var(--ink-soft);
}

.empty-title {

    color:
        var(--ink);

    font-size: 19px;

    font-weight: 700;

    margin-bottom:
        7px;
}


/* =====================================================
   RESPONSIVE
   ===================================================== */

@media (max-width: 900px) {

    .nl-sidebar {

        position: relative;

        width: 100%;

        height: auto;
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

        flex-direction:
            column;
    }

    .back-button {

        width: 100%;

        justify-content:
            center;
    }

}


@media (max-width: 700px) {

    .nl-panel {

        padding:
            20px;
    }

    .action-bar {

        flex-direction:
            column;

        align-items:
            stretch;
    }

    .action-bar .btn,
    .action-bar a {

        width: 100%;

        text-align:
            center;
    }

}


@media (max-width: 500px) {

    .page-title {

        font-size:
            28px;
    }

}

</style>

</head>


<body>


<!-- =====================================================
     SIDEBAR
     ===================================================== -->

<aside class="nl-sidebar">


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

            Commercial Controls / Pricing / Update

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
                    Update Pricing Rule
                </h1>


                <p class="page-description">

                    Update the pricing configuration for the selected
                    container type, size and route.

                </p>

            </div>


            <!-- BACK BUTTON -->

            <a
                class="back-button"
                href="<%= request.getContextPath() %>/app?action=home">

                ← Back to Pricing

            </a>


        </div>


        <section class="nl-panel">


            <% if (pricingRule == null || !canManagePricing) { %>


                <div class="empty-state">

                    <div class="empty-title">
                        Pricing rule unavailable
                    </div>

                    <div>

                        You do not have permission to update this
                        pricing rule, or the rule could not be found.

                    </div>

                </div>


            <% } else { %>


                <div class="panel-title">
                    Pricing Configuration
                </div>


                <div class="panel-description">

                    Update the pricing inputs below. The final price
                    will be calculated by the server.

                </div>


                <div class="info-box">

                    <div class="info-title">
                        Automatic price calculation
                    </div>

                    <p class="info-text">

                        Final Price = Base Price × Seasonal Multiplier ×
                        Demand Multiplier
            + Configured Surcharge

                    </p>

                </div>


                <form method="post"
                      action="<%= request.getContextPath() %>/pricing">


                    <!-- Operation -->

                    <input type="hidden"
                           name="action"
                           value="update">


                    <!-- Generated database ID -->

                    <input type="hidden"
                           name="pricingId"
                           value="<%= pricingRule.getPricingId() %>">


                    <!-- CSRF protection -->

                    <input type="hidden"
                           name="csrfToken"
                           value="<%= csrfToken %>">


                    <!-- Container & Route -->

                    <div class="section-title">
                        Container &amp; Route
                    </div>


                    <div class="row g-3">


                        <!-- Container Type -->

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


                                <option
                                    value="Dry"
                                    <%= "Dry".equals(
                                            pricingRule.getContainerType())
                                        ? "selected" : "" %>>

                                    Dry

                                </option>


                                <option
                                    value="Reefer"
                                    <%= "Reefer".equals(
                                            pricingRule.getContainerType())
                                        ? "selected" : "" %>>

                                    Reefer

                                </option>


                                <option
                                    value="Open Top"
                                    <%= "Open Top".equals(
                                            pricingRule.getContainerType())
                                        ? "selected" : "" %>>

                                    Open Top

                                </option>


                                <option
                                    value="Flat Rack"
                                    <%= "Flat Rack".equals(
                                            pricingRule.getContainerType())
                                        ? "selected" : "" %>>

                                    Flat Rack

                                </option>


                                <option
                                    value="Tank"
                                    <%= "Tank".equals(
                                            pricingRule.getContainerType())
                                        ? "selected" : "" %>>

                                    Tank

                                </option>


                            </select>

                        </div>


                        <!-- Container Size -->

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


                                <option
                                    value="20ft"
                                    <%= "20ft".equals(
                                            pricingRule.getContainerSize())
                                        ? "selected" : "" %>>

                                    20ft

                                </option>


                                <option
                                    value="40ft"
                                    <%= "40ft".equals(
                                            pricingRule.getContainerSize())
                                        ? "selected" : "" %>>

                                    40ft

                                </option>


                                <option
                                    value="40ft HC"
                                    <%= "40ft HC".equals(
                                            pricingRule.getContainerSize())
                                        ? "selected" : "" %>>

                                    40ft HC

                                </option>


                                <option
                                    value="45ft"
                                    <%= "45ft".equals(
                                            pricingRule.getContainerSize())
                                        ? "selected" : "" %>>

                                    45ft

                                </option>


                            </select>

                        </div>


                        <!-- Route -->

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

                                <%
                                    Long[] routeIds =
                                            (Long[]) request.getAttribute("routeIds");

                                    if (routeIds != null) {
                                        for (Long routeId : routeIds) {
                                %>

                                    <option
                                        value="<%= routeId %>"
                                        <%= routeId.equals(pricingRule.getRouteId())
                                                ? "selected" : "" %>>
                                        Route #<%= routeId %>
                                    </option>

                                <%
                                        }
                                    }
                                %>

                            </select>


                            <div class="form-help">

                                Existing route identifier for this
                                pricing rule.

                            </div>

                        </div>


                    </div>


                    <!-- Pricing Values -->

                    <div class="section-title">
                        Pricing Values
                    </div>


                    <div class="row g-3">


                        <!-- Base Price -->

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
                                value="<%= pricingRule.getBasePrice() %>"
                                min="0"
                                step="0.01"
                                required>


                            <div class="form-help">

                                Base price before multipliers.

                            </div>

                        </div>


                        <!-- Seasonal Multiplier -->

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
                                value="<%= pricingRule.getSeasonalMultiplier() %>"
                                min="0"
                                step="0.0001"
                                required>


                            <div class="form-help">

                                Seasonal pricing factor.

                            </div>

                        </div>


                        <!-- Demand Multiplier -->

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
                                value="<%= pricingRule.getDemandMultiplier() %>"
                                min="0"
                                step="0.0001"
                                required>


                            <div class="form-help">

                                Demand pricing factor.

                            </div>

                        </div>


                    </div>


                    <!-- Validity Period -->

                    <div class="section-title">
                        Validity Period
                    </div>


                    <div class="row g-3">


                        <!-- Valid From -->

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
                                value="<%= pricingRule.getValidFrom() %>"
                                required>

                        </div>


                        <!-- Valid To -->

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
                                value="<%= pricingRule.getValidTo() %>"
                                required>

                        </div>


                    </div>


                    <!-- Audit Reason -->

                    <div class="section-title">
                        Price Change Audit
                    </div>


                    <div class="row g-3">


                        <div class="col-12">

                            <label
                                class="form-label"
                                for="reason">

                                Reason for Price Change

                            </label>


                            <input
                                type="text"
                                class="form-control"
                                id="reason"
                                name="reason"
                                maxlength="255"
                                placeholder="Enter reason for changing the price"
                                required>


                            <div class="form-help">

                                This reason is recorded in the pricing
                                audit when the final price changes.

                            </div>

                        </div>


                    </div>


                    <!-- Actions -->

                    <div class="action-bar">


                        <a
                            class="btn-outline-nl"
                            href="<%= request.getContextPath() %>/app?action=home">

                            Cancel

                        </a>


                        <button
                            type="submit"
                            class="btn btn-nl">

                            Update Pricing Rule

                        </button>


                    </div>


                </form>


            <% } %>


        </section>


    </main>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>

