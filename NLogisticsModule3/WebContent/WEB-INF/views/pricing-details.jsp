
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="model.PricingRule"%>

<%
String role = (String) request.getAttribute("role");

PricingRule pricingRule =
        (PricingRule) request.getAttribute("pricingRule");

boolean isSuperAdmin = "Super Admin".equals(role);
boolean isCompanyAdmin = "Company Admin".equals(role);
boolean isFinance = "Company Staff (Finance)".equals(role);

boolean canManagePricing =
        isSuperAdmin || isCompanyAdmin;
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
    content="width=device-width, initial-scale=1.0">

<title>N Logistics · Pricing Details</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<style>

:root {
    --paper: #F0F2F1;
    --surface: #FFFFFF;
    --ink: #10202F;
    --ink-soft: #5C6A78;
    --orange: #D9622B;
    --green: #2F7D53;
    --amber: #A66A1E;
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

    max-width: 1050px;

    margin: 0 auto;

    padding:
        38px 24px 60px;
}


/* =====================================================
   PAGE HEADER
   ===================================================== */

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
}

.page-description {

    color: var(--ink-soft);

    max-width: 780px;

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

    padding:
        28px;

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

    margin-bottom: 22px;

    line-height: 1.5;
}


/* =====================================================
   DETAIL GRID
   ===================================================== */

.detail-grid {

    display: grid;

    grid-template-columns:
        repeat(2, 1fr);

    gap: 14px;
}

.detail-item {

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        17px;

    background:
        #FAFBFB;

    transition:
        border-color 0.15s ease,
        background 0.15s ease;
}

.detail-item:hover {

    border-color:
        #C9D0CE;

    background:
        #F8F9F9;
}

.detail-label {

    color: var(--ink-soft);

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: .8px;

    font-weight: 700;

    margin-bottom: 8px;
}

.detail-value {

    font-size: 17px;

    font-weight: 700;
}

.detail-value.price {

    color: var(--green);

    font-size: 22px;
}


/* =====================================================
   TYPE BADGE
   ===================================================== */

.badge-type {

    display: inline-block;

    background:
        var(--soft-cargo);

    color:
        #93451F;

    padding:
        6px 10px;

    border:
        1px solid #F0C7B2;

    border-radius: 0;

    font-size: 12px;

    font-weight: 700;
}


/* =====================================================
   MULTIPLIER
   ===================================================== */

.multiplier {

    font-family:
        "Courier New",
        monospace;

    color:
        var(--ink);
}


/* =====================================================
   FORMULA BOX
   ===================================================== */

.formula-box {

    margin-top: 22px;

    padding:
        18px;

    background:
        #F7F8F8;

    border:
        1px solid var(--border);

    border-left:
        4px solid var(--orange);
}

.formula-title {

    font-size: 12px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: .7px;

    margin-bottom: 8px;
}

.formula {

    font-family:
        "Courier New",
        monospace;

    font-size: 13px;

    color:
        var(--ink-soft);
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

    margin-top: 25px;

    padding-top: 20px;

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
        10px 17px;

    font-size: 12px;

    font-weight: 700;

    text-decoration: none;
}

.btn-nl:hover {

    background:
        #BC4F20;

    border-color:
        #BC4F20;

    color: white;
}

.btn-outline-nl {

    background: white;

    color: var(--ink);

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        10px 17px;

    font-size: 12px;

    font-weight: 700;

    text-decoration: none;
}

.btn-outline-nl:hover {

    background:
        #F7F8F8;

    color: var(--ink);
}


/* =====================================================
   EMPTY STATE
   ===================================================== */

.empty-state {

    text-align: center;

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

    margin-bottom: 7px;
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

        flex-direction: column;
    }

    .back-button {

        width: 100%;

        justify-content: center;
    }

}


@media (max-width: 700px) {

    .detail-grid {

        grid-template-columns:
            1fr;
    }

    .action-bar {

        flex-direction: column;

        align-items: stretch;
    }

    .action-bar a {

        width: 100%;

        text-align: center;
    }

    .nl-panel {

        padding:
            20px;
    }

}


@media (max-width: 500px) {

    .page-title {

        font-size: 28px;
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


    <!-- SIDEBAR NAVIGATION -->

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

            <%= role == null ? "User" : role %>

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

            Commercial Controls / Pricing / Details

        </div>


        <div class="nl-role">

            <%= role == null ? "User" : role %>

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
                    Pricing Rule Details
                </h1>


                <p class="page-description">
                    Review the configuration and calculated final price
                    for the selected pricing rule.
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


            <% if (pricingRule == null) { %>


                <div class="empty-state">

                    <div class="empty-title">
                        Pricing rule not found
                    </div>

                    <div>
                        The requested pricing rule could not be
                        loaded.
                    </div>

                </div>


            <% } else { %>


                <div class="panel-title">
                    Pricing Configuration
                </div>


                <div class="panel-description">
                    Pricing information available to your role.
                </div>


                <div class="detail-grid">


                    <div class="detail-item">

                        <div class="detail-label">
                            Container Type
                        </div>

                        <div class="detail-value">

                            <span class="badge-type">
                                <%= pricingRule.getContainerType() %>
                            </span>

                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Container Size
                        </div>

                        <div class="detail-value">
                            <%= pricingRule.getContainerSize() %>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Route
                        </div>

                        <div class="detail-value">
                            <%= pricingRule.getRouteId() %>
                        </div>

                    </div>


                    <% if (canManagePricing) { %>


                        <div class="detail-item">

                            <div class="detail-label">
                                Base Price
                            </div>

                            <div class="detail-value">
                                ₹ <%= pricingRule.getBasePrice() %>
                            </div>

                        </div>


                        <div class="detail-item">

                            <div class="detail-label">
                                Seasonal Multiplier
                            </div>

                            <div class="detail-value multiplier">
                                <%= pricingRule.getSeasonalMultiplier() %>
                            </div>

                        </div>


                        <div class="detail-item">

                            <div class="detail-label">
                                Demand Multiplier
                            </div>

                            <div class="detail-value multiplier">
                                <%= pricingRule.getDemandMultiplier() %>
                            </div>

                        </div>


                    <% } %>


                    <div class="detail-item">

                        <div class="detail-label">
                            Final Price
                        </div>

                        <div class="detail-value price">
                            ₹ <%= pricingRule.getFinalPrice() %>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Valid From
                        </div>

                        <div class="detail-value">
                            <%= pricingRule.getValidFrom() %>
                        </div>

                    </div>


                    <div class="detail-item">

                        <div class="detail-label">
                            Valid To
                        </div>

                        <div class="detail-value">
                            <%= pricingRule.getValidTo() %>
                        </div>

                    </div>


                </div>


                <% if (canManagePricing) { %>


                    <div class="formula-box">

                        <div class="formula-title">
                            Pricing Calculation
                        </div>

                        <div class="formula">
                            Final Price = (Base Price × Seasonal Multiplier × Demand Multiplier) + Configured Surcharge
                        </div>

                    </div>


                <% } %>


                <div class="action-bar">


                    <a
                        class="btn-outline-nl"
                        href="<%= request.getContextPath() %>/app?action=home">

                        Back to Pricing

                    </a>


                    <% if (canManagePricing) { %>


                        <a
                            class="btn-nl"
                            href="<%= request.getContextPath() %>/pricing?action=edit&pricingId=<%= pricingRule.getPricingId() %>">

                            Edit Pricing Rule

                        </a>


                    <% } %>


                </div>


            <% } %>


        </section>


    </main>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>

