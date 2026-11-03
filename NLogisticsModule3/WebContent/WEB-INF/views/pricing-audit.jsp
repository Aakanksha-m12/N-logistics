<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.PricingAudit"%>

<%
String role = (String) request.getAttribute("role");

List<?> auditObjects =
        (List<?>) request.getAttribute("audits");

List<PricingAudit> audits =
        new ArrayList<PricingAudit>();

if (auditObjects != null) {
    for (Object object : auditObjects) {
        if (object instanceof PricingAudit) {
            audits.add((PricingAudit) object);
        }
    }
}

boolean isSuperAdmin =
        "Super Admin".equals(role);

boolean isCompanyAdmin =
        "Company Admin".equals(role);

boolean isFinance =
        "Company Staff (Finance)".equals(role);

boolean canViewAudit =
        isSuperAdmin || isCompanyAdmin || isFinance;
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
    content="width=device-width, initial-scale=1.0">

<title>N Logistics · Pricing Audit</title>

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

    max-width: 1200px;

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

    letter-spacing: -0.5px;
}

.page-description {

    color: var(--ink-soft);

    max-width: 800px;

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

    margin-bottom: 22px;

    line-height: 1.5;
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
        16px 17px;

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
   TABLE
   ===================================================== */

.table-wrapper {

    width: 100%;

    overflow-x: auto;
}

.audit-table {

    width: 100%;

    min-width: 900px;

    border-collapse: collapse;
}

.audit-table th {

    background: var(--ink);

    color: white;

    font-size: 11px;

    text-transform: uppercase;

    letter-spacing: .7px;

    font-weight: 700;

    padding:
        14px 12px;

    border: none;

    white-space: nowrap;
}

.audit-table td {

    padding:
        15px 12px;

    border-bottom:
        1px solid var(--border);

    vertical-align: middle;

    font-size: 13px;

    color: var(--ink);
}

.audit-table tr:last-child td {

    border-bottom: none;
}

.audit-table tbody tr:hover {

    background: #F8F9F9;
}


/* =====================================================
   AUDIT VALUES
   ===================================================== */

.audit-id {

    display: inline-block;

    color: var(--ink-soft);

    font-family:
        "Courier New",
        monospace;

    font-size: 12px;

    background: #F7F8F8;

    border:
        1px solid var(--border);

    padding:
        4px 7px;
}

.price-old {

    color: var(--red);

    font-weight: 800;

    white-space: nowrap;
}

.price-new {

    color: var(--green);

    font-weight: 800;

    white-space: nowrap;
}

.reason {

    display: block;

    max-width: 280px;

    color: var(--ink-soft);

    line-height: 1.5;
}


/* =====================================================
   EMPTY STATE
   ===================================================== */

.empty-state {

    text-align: center;

    padding:
        55px 20px;

    color: var(--ink-soft);
}

.empty-title {

    color: var(--ink);

    font-size: 18px;

    font-weight: 700;

    margin-bottom: 7px;
}


/* =====================================================
   ACCESS RESTRICTED
   ===================================================== */

.access-box {

    text-align: center;

    padding:
        55px 20px;
}

.access-title {

    font-size: 20px;

    font-weight: 700;

    margin-bottom: 8px;
}

.access-text {

    color: var(--ink-soft);

    line-height: 1.6;
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

    .nl-panel {

        padding: 20px;
    }

}


@media (max-width: 500px) {

    .page-title {

        font-size: 28px;
    }

    .nl-role {

        font-size: 11px;

        padding:
            6px 8px;
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
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ₹
            </span>

            Pricing

        </a>


        <a
            class="sidebar-link active"
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

            Commercial Controls / Pricing / Audit

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
                    Pricing Audit Log
                </h1>


                <p class="page-description">
                    Review changes made to pricing values, including the
                    previous value, new value, reason and responsible user.
                </p>

            </div>


            <!-- BACK BUTTON -->

            <a
                class="back-button"
                href="<%= request.getContextPath() %>/app?action=home">

                ← Back to Pricing

            </a>

        </div>


        <% if (!canViewAudit) { %>


            <!-- =================================================
                 ACCESS RESTRICTED
                 ================================================= -->

            <section class="nl-panel">

                <div class="access-box">

                    <div class="access-title">
                        Access Restricted
                    </div>

                    <div class="access-text">
                        Pricing audit information is available only
                        to authorized administrative and finance users.
                    </div>

                </div>

            </section>


        <% } else { %>


            <!-- =================================================
                 AUDIT PANEL
                 ================================================= -->

            <section class="nl-panel">


                <div class="panel-title">
                    Pricing Change History
                </div>


                <div class="panel-description">
                    Every recorded pricing change is displayed
                    according to your authorized access.
                </div>


                <!-- INFORMATION -->

                <div class="info-box">

                    <div class="info-title">
                        Audit Information
                    </div>

                    <p class="info-text">
                        Audit records contain the pricing rule,
                        previous price, new price, responsible user,
                        reason and timestamp.
                    </p>

                </div>


                <% if (audits.isEmpty()) { %>


                    <!-- EMPTY STATE -->

                    <div class="empty-state">

                        <div class="empty-title">
                            No audit records found
                        </div>

                        <div>
                            No pricing changes have been recorded
                            for this view.
                        </div>

                    </div>


                <% } else { %>


                    <!-- TABLE -->

                    <div class="table-wrapper">


                        <table class="audit-table">


                            <thead>

                                <tr>

                                    <th>
                                        Audit ID
                                    </th>

                                    <th>
                                        Pricing ID
                                    </th>

                                    <th>
                                        Previous Price
                                    </th>

                                    <th>
                                        New Price
                                    </th>

                                    <th>
                                        Changed By
                                    </th>

                                    <th>
                                        Reason
                                    </th>

                                    <th>
                                        Changed At
                                    </th>

                                </tr>

                            </thead>


                            <tbody>


                            <% for (PricingAudit audit : audits) { %>


                                <tr>


                                    <td>

                                        <span class="audit-id">
                                            <%= audit.getAuditId() %>
                                        </span>

                                    </td>


                                    <td>

                                        <span class="audit-id">
                                            <%= audit.getPricingId() %>
                                        </span>

                                    </td>


                                    <td>

                                        <span class="price-old">
                                            ₹ <%= audit.getOldPrice() %>
                                        </span>

                                    </td>


                                    <td>

                                        <span class="price-new">
                                            ₹ <%= audit.getNewPrice() %>
                                        </span>

                                    </td>


                                    <td>

                                        <span class="audit-id">
                                            <%= audit.getChangedBy() %>
                                        </span>

                                    </td>


                                    <td>

                                        <span class="reason">
                                            <%= audit.getReason() %>
                                        </span>

                                    </td>


                                    <td>
                                        <%= audit.getChangedAt() %>
                                    </td>


                                </tr>


                            <% } %>


                            </tbody>


                        </table>


                    </div>


                <% } %>


            </section>


        <% } %>


    </main>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>