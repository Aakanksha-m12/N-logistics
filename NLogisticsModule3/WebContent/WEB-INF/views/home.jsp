<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String role = (String) request.getAttribute("role");

if (role == null) {
    role = (String) session.getAttribute("roleName");
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

boolean isFinance =
        "Company Staff (Finance)".equals(role);

boolean isCustomer =
        "Customer".equals(role);
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
    content="width=device-width, initial-scale=1.0">

<title>N Logistics · Dashboard</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<style>

/* ============================================================
   N LOGISTICS DESIGN SYSTEM
   ============================================================ */

:root {

    --paper: #F0F2F1;
    --surface: #FFFFFF;

    --ink: #10202F;
    --ink-soft: #5C6A78;
    --ink-faint: #8B96A0;

    --orange: #D9622B;
    --orange-dark: #BC4F20;
    --orange-soft: #FBE7DB;

    --green: #2F7D53;
    --amber: #A66A1E;
    --red: #B23A2E;

    --border: #DFE3E2;

    --sidebar: #10202F;
    --sidebar-hover: #1B3041;
    --sidebar-active: #D9622B;
}


/* ============================================================
   GLOBAL
   ============================================================ */

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


/* ============================================================
   SIDEBAR
   ============================================================ */

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


/* ============================================================
   SIDEBAR BRAND
   ============================================================ */

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

    background: var(--orange);

    border-radius: 0;

    font-weight: 800;
}


.nl-subtitle {

    color: #AEBAC3;

    font-size: 10px;

    margin-left: 46px;

    margin-top: 6px;

    line-height: 1.4;
}


/* ============================================================
   SIDEBAR MENU
   ============================================================ */

.sidebar-menu {

    padding:
        22px 12px;

    flex-grow: 1;
}


.sidebar-section-title {

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

    border-radius: 0;

    border-left:
        3px solid transparent;

    transition:
        background 0.15s ease,
        color 0.15s ease,
        border-color 0.15s ease;
}


.sidebar-link:hover {

    background: var(--sidebar-hover);

    color: white;
}


.sidebar-link.active {

    background: var(--orange);

    color: white;

    border-left:
        3px solid #F6B394;
}


.sidebar-icon {

    width: 27px;

    font-size: 14px;

    text-align: center;

    margin-right: 7px;
}


/* ============================================================
   SIDEBAR BOTTOM
   ============================================================ */

.sidebar-bottom {

    padding:
        16px 12px 18px;

    border-top:
        1px solid rgba(255,255,255,0.10);
}


.sidebar-role {

    color: #AEBAC3;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 0.8px;

    padding:
        0 12px 7px;
}


.sidebar-role-value {

    color: white;

    font-size: 12px;

    font-weight: 700;

    padding:
        0 12px 15px;
}


/* ============================================================
   LOGOUT
   ============================================================ */

.logout-btn {

    width: 100%;

    background: transparent;

    color: #D7DEE3;

    border:
        1px solid #40515D;

    border-radius: 0;

    padding:
        10px 12px;

    font-size: 12px;

    font-weight: 700;

    text-align: left;

    cursor: pointer;

    transition:
        background 0.15s ease,
        border-color 0.15s ease;
}


.logout-btn:hover {

    background: #253946;

    color: white;

    border-color: #566874;
}


/* ============================================================
   MAIN AREA
   ============================================================ */

.nl-main {

    margin-left: 245px;

    min-height: 100vh;
}


/* ============================================================
   TOP BAR
   ============================================================ */

.nl-topbar {

    height: 72px;

    background: var(--surface);

    border-bottom:
        1px solid var(--border);

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding:
        0 30px;
}


.topbar-title {

    font-size: 14px;

    font-weight: 700;

    color: var(--ink);
}


.topbar-role {

    color: var(--ink-soft);

    font-size: 12px;
}


/* ============================================================
   ROLE BADGE
   ============================================================ */

.role-badge {

    display: inline-block;

    background: var(--orange-soft);

    color: #93451F;

    padding:
        6px 10px;

    border:
        1px solid #F0C7B2;

    border-radius: 0;

    font-size: 11px;

    font-weight: 700;
}


/* ============================================================
   CONTENT
   ============================================================ */

.nl-content {

    max-width: 1200px;

    margin: 0 auto;

    padding:
        38px 30px 60px;
}


/* ============================================================
   PAGE HEADER
   ============================================================ */

.page-header {

    display: flex;

    justify-content: space-between;

    align-items: flex-end;

    gap: 20px;

    margin-bottom: 25px;
}


.page-kicker {

    color: var(--orange);

    font-size: 11px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 1.5px;

    margin-bottom: 8px;
}


.page-title {

    font-size: 36px;

    font-weight: 750;

    margin-bottom: 8px;

    letter-spacing: -0.5px;
}


.page-description {

    color: var(--ink-soft);

    max-width: 760px;

    margin-bottom: 0;

    line-height: 1.6;

    font-size: 14px;
}


/* ============================================================
   BACK BUTTON
   ============================================================ */

.back-btn {

    display: inline-flex;

    align-items: center;

    justify-content: center;

    gap: 7px;

    background: white;

    color: var(--ink);

    border:
        1px solid var(--border);

    border-radius: 0;

    padding:
        10px 15px;

    font-size: 12px;

    font-weight: 700;

    text-decoration: none;

    white-space: nowrap;
}


.back-btn:hover {

    background: #F7F8F8;

    color: var(--ink);
}


/* ============================================================
   WELCOME PANEL
   ============================================================ */

.welcome-panel {

    background: var(--surface);

    border:
        1px solid var(--border);

    border-left:
        4px solid var(--orange);

    border-radius: 0;

    padding:
        22px 24px;

    margin-bottom: 25px;

    box-shadow:
        0 3px 14px
        rgba(16,32,47,0.035);
}


.welcome-title {

    font-size: 18px;

    font-weight: 700;

    margin-bottom: 6px;
}


.welcome-text {

    color: var(--ink-soft);

    margin: 0;

    font-size: 13px;
}


/* ============================================================
   FEATURE GRID
   ============================================================ */

.feature-grid {

    display: grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap: 18px;
}


/* ============================================================
   FEATURE CARD
   ============================================================ */

.feature-card {

    background: var(--surface);

    border:
        1px solid var(--border);

    border-radius: 0;

    padding: 22px;

    min-height: 190px;

    display: flex;

    flex-direction: column;

    box-shadow:
        0 3px 14px
        rgba(16,32,47,0.035);

    transition:
        transform 0.15s ease,
        box-shadow 0.15s ease,
        border-color 0.15s ease;
}


.feature-card:hover {

    transform:
        translateY(-2px);

    border-color:
        #C7CFCD;

    box-shadow:
        0 8px 24px
        rgba(16,32,47,0.08);
}


.feature-label {

    color: var(--orange);

    font-size: 10px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 1.2px;

    margin-bottom: 9px;
}


.feature-title {

    font-size: 18px;

    font-weight: 700;

    margin-bottom: 8px;
}


.feature-text {

    color: var(--ink-soft);

    font-size: 12px;

    line-height: 1.6;

    flex-grow: 1;

    margin-bottom: 18px;
}


/* ============================================================
   ALL FEATURE BUTTONS - ORANGE
   ============================================================ */

.btn-nl {

    display: inline-flex;

    align-items: center;

    justify-content: center;

    background: var(--orange);

    color: white;

    border:
        1px solid var(--orange);

    border-radius: 0;

    padding:
        10px 15px;

    font-size: 11px;

    font-weight: 700;

    text-decoration: none;

    align-self: flex-start;

    transition:
        background 0.15s ease,
        border-color 0.15s ease;
}


.btn-nl:hover {

    background: var(--orange-dark);

    border-color: var(--orange-dark);

    color: white;
}


/* ============================================================
   RESPONSIVE
   ============================================================ */

@media (max-width: 1000px) {

    .nl-sidebar {

        width: 210px;
    }

    .nl-main {

        margin-left: 210px;
    }

    .feature-grid {

        grid-template-columns:
            repeat(2, 1fr);
    }
}


@media (max-width: 700px) {

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
            28px 18px 45px;
    }

    .page-header {

        flex-direction: column;

        align-items: flex-start;
    }

    .back-btn {

        width: 100%;
    }

    .feature-grid {

        grid-template-columns: 1fr;
    }

    .sidebar-menu {

        padding-bottom: 10px;
    }
}


@media (max-width: 500px) {

    .page-title {

        font-size: 28px;
    }

    .nl-topbar {

        height: 62px;
    }

    .topbar-role {

        display: none;
    }
}

</style>

</head>


<body>


<!-- ============================================================
     SIDE NAVBAR
     ============================================================ -->

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


    <!-- ========================================================
         SIDEBAR MENU
         ======================================================== -->

    <div class="sidebar-menu">


        <div class="sidebar-section-title">

            Workspace

        </div>


        <!-- DASHBOARD -->

        <a
            class="sidebar-link active"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ▦
            </span>

            Dashboard

        </a>


        <!-- CONTAINERS -->

        <% if (isSuperAdmin || isCompanyAdmin || isOperations) { %>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/containers?action=view">

            <span class="sidebar-icon">
                ▣
            </span>

            Containers

        </a>

        <% } %>


        <!-- ALLOCATION -->

        <% if (isSuperAdmin || isCompanyAdmin || isOperations || isCustomer) { %>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/allocation?action=view">

            <span class="sidebar-icon">
                ⇄
            </span>

            Allocation

        </a>

        <% } %>


        <!-- PRICING -->

        <% if (isSuperAdmin || isCompanyAdmin || isFinance) { %>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing?action=view">

            <span class="sidebar-icon">
                ₹
            </span>

            Pricing

        </a>

        <% } %>


        <!-- PRICING AUDIT -->

        <% if (isSuperAdmin || isCompanyAdmin || isFinance) { %>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing-audit?action=view">

            <span class="sidebar-icon">
                ≡
            </span>

            Pricing Audit

        </a>

        <% } %>


        <!-- DEMAND FORECAST -->

        <% if (isSuperAdmin || isCompanyAdmin) { %>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/forecast?action=view">

            <span class="sidebar-icon">
                ↗
            </span>

            Demand Forecast

        </a>

        <% } %>


        <!-- ADMINISTRATION -->

        <% if (isSuperAdmin || isCompanyAdmin) { %>

        <div class="sidebar-section-title mt-4">

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


    <!-- ========================================================
         SIDEBAR BOTTOM
         ======================================================== -->

    <div class="sidebar-bottom">


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


<!-- ============================================================
     MAIN AREA
     ============================================================ -->

<div class="nl-main">


    <!-- ========================================================
         TOP BAR
         ======================================================== -->

    <header class="nl-topbar">


        <div class="topbar-title">

            Operations Workspace

        </div>


        <div class="topbar-role">

            <span class="role-badge">

                <%= role %>

            </span>

        </div>


    </header>


    <!-- ========================================================
         MAIN CONTENT
         ======================================================== -->

    <main class="nl-content">


        <!-- ====================================================
             PAGE HEADER
             ==================================================== -->

        <div class="page-header">


            <div>

                <div class="page-kicker">

                    Operations Platform

                </div>


                <h1 class="page-title">

                    N Logistics Dashboard

                </h1>


                <p class="page-description">

                    Manage container logistics, allocation and
                    authorized commercial operations from one
                    secure workspace.

                </p>

            </div>


            <!-- BACK -->

            <a
                class="back-btn"
                href="<%= request.getContextPath() %>/app?action=home">

                ← Back to Dashboard

            </a>


        </div>


        <!-- ====================================================
             WELCOME
             ==================================================== -->

        <section class="welcome-panel">


            <div class="welcome-title">

                Welcome

            </div>


            <p class="welcome-text">

                You are signed in as
                <strong><%= role %></strong>.
                The dashboard displays only the functions available
                to your role.

            </p>


        </section>


        <!-- ====================================================
             FEATURE CARDS
             ==================================================== -->

        <div class="feature-grid">


            <!-- =================================================
                 CONTAINER CATALOG
                 CUSTOMER DOES NOT SEE THIS
                 ================================================= -->

            <% if (isSuperAdmin || isCompanyAdmin || isOperations) { %>


            <div class="feature-card">


                <div class="feature-label">

                    Containers

                </div>


                <div class="feature-title">

                    Container Catalog

                </div>


                <div class="feature-text">

                    View and manage container information
                    according to your assigned permissions.

                </div>


                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/containers?action=view">

                    Open Containers

                </a>


            </div>


            <% } %>


            <!-- =================================================
                 CUSTOMER SEE CONTAINER PRICE
                 ================================================= -->

            <% if (isCustomer) { %>


            <div class="feature-card">


                <div class="feature-label">

                    Pricing

                </div>


                <div class="feature-title">

                    See Container Price

                </div>


                <div class="feature-text">

                    View the current container price before
                    proceeding with your allocation.

                </div>


                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/pricing?action=customer-view">

                    See Container Price

                </a>


            </div>


            <% } %>


            <!-- =================================================
                 ALLOCATION
                 ================================================= -->

            <% if (isSuperAdmin || isCompanyAdmin || isOperations || isCustomer) { %>


            <div class="feature-card">


                <div class="feature-label">

                    Allocation

                </div>


                <div class="feature-title">

                    Container Allocation

                </div>


                <div class="feature-text">


                    <% if (isCustomer) { %>

                        Select a company and allocate an
                        available container for your shipment.

                    <% } else { %>

                        Allocate available containers while
                        respecting cargo weight and volume
                        capacity.

                    <% } %>


                </div>


                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/allocation?action=view">

                    Open Allocation

                </a>


            </div>


            <% } %>


            <!-- =================================================
                 PRICING
                 ================================================= -->

            <% if (isSuperAdmin || isCompanyAdmin || isFinance) { %>


            <div class="feature-card">


                <div class="feature-label">

                    Pricing

                </div>


                <div class="feature-title">

                    Pricing Rules

                </div>


                <div class="feature-text">


                    <% if (isFinance) { %>

                        Review authorized pricing information
                        and final prices.

                    <% } else { %>

                        Configure and review container pricing
                        rules.

                    <% } %>


                </div>


                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/pricing?action=view">

                    Open Pricing

                </a>


            </div>


            <% } %>


            <!-- =================================================
                 AUDIT
                 ================================================= -->

            <% if (isSuperAdmin || isCompanyAdmin || isFinance) { %>


            <div class="feature-card">


                <div class="feature-label">

                    Audit

                </div>


                <div class="feature-title">

                    Pricing Audit

                </div>


                <div class="feature-text">

                    Review recorded pricing changes,
                    previous values, new values, reasons
                    and responsible users.

                </div>


                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/pricing-audit?action=view">

                    Open Audit Log

                </a>


            </div>


            <% } %>


            <!-- =================================================
                 DEMAND FORECAST
                 ================================================= -->

            <% if (isSuperAdmin || isCompanyAdmin) { %>


            <div class="feature-card">


                <div class="feature-label">

                    Analytics

                </div>


                <div class="feature-title">

                    Demand Forecast

                </div>


                <div class="feature-text">

                    Review forecasted demand and predicted
                    prices for upcoming periods.

                </div>


                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/forecast?action=view">

                    Open Forecast

                </a>


            </div>


            <% } %>


            <!-- =================================================
                 CONTAINER MANAGEMENT
                 ================================================= -->

            <% if (isSuperAdmin || isCompanyAdmin) { %>


            <div class="feature-card">


                <div class="feature-label">

                    Administration

                </div>


                <div class="feature-title">

                    Container Management

                </div>


                <div class="feature-text">

                    Add, update and delete containers belonging
                    to the authorized company context.

                </div>


                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/containers?action=manage">

                    Manage Containers

                </a>


            </div>


            <% } %>


        </div>


    </main>


</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>
