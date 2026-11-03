<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Company Management — N Logistics</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700&family=IBM+Plex+Mono:wght@500;600&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<style>

/* =========================================================
   N LOGISTICS — CARGO MANIFEST DESIGN SYSTEM
   Company Management
   ========================================================= */

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

/* =========================================================
   BASE
   ========================================================= */

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

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 15px;
    line-height: 1.5;
}

/* =========================================================
   TOP NAVIGATION
   ========================================================= */

.nl-nav {
    height: 72px;

    background: var(--ink);

    border-bottom: 1px solid var(--ink);

    padding: 0;
}

.nl-nav .container-fluid {
    width: 100%;

    padding-left: 34px;
    padding-right: 34px;
}

/* =========================================================
   BRAND
   ========================================================= */

.nl-brand {
    display: inline-flex;
    align-items: center;

    gap: 12px;

    color: #FFFFFF;
    text-decoration: none;
}

.nl-brand:hover {
    color: #FFFFFF;
}

.nl-brand-mark {
    width: 38px;
    height: 38px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    background: var(--orange);

    color: #FFFFFF;

    border: 1px solid var(--orange);

    font-family: "Archivo", sans-serif;
    font-size: 19px;
    font-weight: 700;
}

.nl-brand-copy {
    display: flex;
    flex-direction: column;

    line-height: 1.05;
}

.nl-brand-name {
    color: #FFFFFF;

    font-family: "Archivo", sans-serif;
    font-size: 17px;
    font-weight: 700;
}

.nl-brand-sub {
    margin-top: 4px;

    color: #B9C3CC;

    font-size: 10px;
    font-weight: 500;

    letter-spacing: 0.13em;
    text-transform: uppercase;
}

/* =========================================================
   NAV BUTTONS
   ========================================================= */

.nl-nav-link {
    color: #FFFFFF !important;

    background: transparent;

    border: 1px solid rgba(255,255,255,0.25);

    border-radius: 0;

    padding: 8px 14px;

    font-size: 13px;
    font-weight: 600;
}

.nl-nav-link:hover {
    color: #FFFFFF !important;

    background: rgba(255,255,255,0.08);

    border-color: rgba(255,255,255,0.4);
}

.nl-nav .btn-outline-light {
    border-radius: 0;

    padding: 8px 14px;

    font-size: 13px;
    font-weight: 600;
}

/* =========================================================
   MAIN CONTENT
   ========================================================= */

.nl-content {
    width: 100%;
    max-width: none;

    padding: 34px 34px 60px;
}

/* =========================================================
   PAGE HEADER
   ========================================================= */

.page-header {
    width: 100%;

    padding-bottom: 25px;
    margin-bottom: 26px;

    border-bottom: 1px solid var(--border);
}

.page-kicker {
    margin-bottom: 8px;

    color: var(--orange);

    font-family: "IBM Plex Mono", monospace;
    font-size: 12px;
    font-weight: 600;

    letter-spacing: 0.08em;
    text-transform: uppercase;
}

.page-title {
    margin: 0;

    color: var(--ink);

    font-family: "Archivo", sans-serif;
    font-size: 38px;
    font-weight: 700;

    line-height: 1.1;
    letter-spacing: -0.025em;
}

.page-description {
    max-width: 760px;

    margin: 12px 0 0;

    color: var(--ink-soft);

    font-size: 15px;
}

/* =========================================================
   MAIN PANEL
   ========================================================= */

.nl-panel {
    width: 100%;

    background: var(--surface);

    border: 1px solid var(--border);

    border-radius: 0;
}

/* =========================================================
   PANEL HEADER
   ========================================================= */

.nl-panel-header {
    display: flex;
    align-items: center;
    justify-content: space-between;

    min-height: 92px;

    padding: 22px 24px;

    border-bottom: 1px solid var(--border);
}

.nl-panel-header h2 {
    margin: 0;

    color: var(--ink);

    font-family: "Archivo", sans-serif;
    font-size: 21px;
    font-weight: 700;

    line-height: 1.2;
}

.nl-panel-header p {
    margin: 7px 0 0;

    color: var(--ink-soft);

    font-size: 14px;
}

/* =========================================================
   TABLE
   ========================================================= */

.table-responsive {
    width: 100%;
}

.nl-panel .table {
    width: 100%;

    margin: 0;

    border-collapse: collapse;

    color: var(--ink);

    font-size: 14px;
}

.nl-panel .table thead th {
    background: #F7F8F8;

    color: var(--ink-soft);

    border-bottom: 1px solid var(--border);

    padding: 15px 18px;

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 12px;
    font-weight: 600;

    letter-spacing: 0.06em;
    text-transform: uppercase;

    white-space: nowrap;
}

.nl-panel .table tbody td {
    padding: 17px 18px;

    border-bottom: 1px solid var(--border);

    vertical-align: middle;

    font-size: 15px;
}

.nl-panel .table tbody tr:last-child td {
    border-bottom: 0;
}

.nl-panel .table tbody tr:hover {
    background: #FAFBFB;
}

/* =========================================================
   COMPANY ID
   ========================================================= */

.company-id {
    color: var(--ink-soft);

    font-family: "IBM Plex Mono", monospace;
    font-size: 13px;
    font-weight: 500;

    white-space: nowrap;
}

/* =========================================================
   COMPANY NAME
   ========================================================= */

.company-name {
    color: var(--ink);

    font-size: 15px;
    font-weight: 600;
}

/* =========================================================
   LICENSE / GST
   ========================================================= */

.company-code {
    color: var(--ink-soft);

    font-family: "IBM Plex Mono", monospace;
    font-size: 13px;
    font-weight: 500;

    white-space: nowrap;
}

/* =========================================================
   STATUS BADGES
   ========================================================= */

.status-badge {
    display: inline-flex;
    align-items: center;

    min-height: 29px;

    padding: 5px 10px;

    border: 1px solid;

    border-radius: 0;

    font-family: "IBM Plex Mono", monospace;
    font-size: 11px;
    font-weight: 600;

    letter-spacing: 0.04em;
    text-transform: uppercase;

    white-space: nowrap;
}

/* Pending = Amber */

.status-pending {
    color: var(--amber);

    background: rgba(166,106,30,0.08);

    border-color: rgba(166,106,30,0.25);
}

/* Active = Green */

.status-active {
    color: var(--green);

    background: rgba(47,125,83,0.08);

    border-color: rgba(47,125,83,0.25);
}

/* Other status */

.status-other {
    color: var(--ink-soft);

    background: #F3F5F5;

    border-color: var(--border);
}

/* =========================================================
   ACTION BUTTONS
   ========================================================= */

.action-cell {
    white-space: nowrap;
}

.action-btn {
    min-width: 92px;

    border-radius: 0;

    padding: 8px 13px;

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 13px;
    font-weight: 600;
}

/*
 * Approve uses the cargo orange action accent.
 * Status green is reserved for status indicators.
 */

.btn-approve {
    color: #FFFFFF;

    background: var(--orange);

    border: 1px solid var(--orange);
}

.btn-approve:hover,
.btn-approve:focus {
    color: #FFFFFF;

    background: #BE5121;

    border-color: #BE5121;
}

/*
 * Suspend uses the reserved hold/delete red.
 */

.btn-suspend {
    color: #FFFFFF;

    background: var(--red);

    border: 1px solid var(--red);
}

.btn-suspend:hover,
.btn-suspend:focus {
    color: #FFFFFF;

    background: #962F25;

    border-color: #962F25;
}

/* =========================================================
   NO ACTION
   ========================================================= */

.no-action {
    color: var(--ink-soft);

    font-size: 13px;
}

/* =========================================================
   EMPTY STATE
   ========================================================= */

.empty-state {
    padding: 46px 24px !important;

    color: var(--ink-soft);

    text-align: center;

    font-size: 15px;
}

/* =========================================================
   RESPONSIVE
   ========================================================= */

@media (max-width: 768px) {

    .nl-nav .container-fluid {
        padding-left: 18px;
        padding-right: 18px;
    }

    .nl-content {
        padding: 26px 18px 45px;
    }

    .page-title {
        font-size: 32px;
    }

    .page-description {
        font-size: 14px;
    }

    .nl-panel-header {
        padding: 19px;
    }

    .nl-panel .table thead th,
    .nl-panel .table tbody td {
        padding-left: 14px;
        padding-right: 14px;
    }
}

@media (max-width: 576px) {

    .nl-brand-sub {
        display: none;
    }

    .nl-nav-link {
        display: none;
    }

    .page-title {
        font-size: 29px;
    }

}

</style>
</head>

<body>

<!-- =====================================================
     TOP NAVIGATION
     ===================================================== -->

<nav class="navbar nl-nav">

    <div class="container-fluid">

        <a class="nl-brand"
           href="${pageContext.request.contextPath}/app?action=home"
           aria-label="N Logistics home">

            <span class="nl-brand-mark">
                N
            </span>

            <span class="nl-brand-copy">

                <span class="nl-brand-name">
                    N Logistics
                </span>

                <span class="nl-brand-sub">
                    Import &amp; Export
                </span>

            </span>

        </a>


        <div class="d-flex align-items-center gap-2">

            <% if (session.getAttribute("userId") != null) { %>

                <a class="btn btn-sm nl-nav-link"
                   href="${pageContext.request.contextPath}/app?action=profile">
                    Profile
                </a>

                <form method="post"
                      action="${pageContext.request.contextPath}/app"
                      class="d-inline m-0">

                    <input type="hidden"
                           name="action"
                           value="logout">

                    <input type="hidden"
                           name="_csrf"
                           value="<%=session.getAttribute("csrfToken")%>">

                    <button type="submit"
                            class="btn btn-sm btn-outline-light">
                        Logout
                    </button>

                </form>

            <% } else { %>

                <a class="btn btn-sm btn-outline-light"
                   href="${pageContext.request.contextPath}/app?action=login">
                    Login
                </a>

            <% } %>

        </div>

    </div>

</nav>


<!-- =====================================================
     MAIN CONTENT
     ===================================================== -->

<main class="nl-content">


    <!-- =================================================
         PAGE HEADER
         ================================================= -->

    <div class="page-header">

        <div class="page-kicker">
            Governance / Super Admin
        </div>

        <h1 class="page-title">
            Company management
        </h1>

        <p class="page-description">
            Review registered companies and manage approval status.
        </p>

    </div>


    <!-- =================================================
         REGISTERED COMPANIES
         ================================================= -->

    <section class="nl-panel">

        <div class="nl-panel-header">

            <div>

                <h2>
                    Registered companies
                </h2>

                <p>
                    Approval and suspension actions are controlled by Super Admin authorization.
                </p>

            </div>

        </div>


        <div class="nl-panel-body p-0">

            <div class="table-responsive">

                <table class="table">

                    <thead>

                        <tr>

                            <th>
                                ID
                            </th>

                            <th>
                                Name
                            </th>

                            <th>
                                License
                            </th>

                            <th>
                                GST
                            </th>

                            <th>
                                Status
                            </th>

                            <th class="text-end">
                                Action
                            </th>

                        </tr>

                    </thead>


                    <tbody>

                    <%

                    java.util.List<model.Company> cs =
                        (java.util.List<model.Company>)
                        request.getAttribute("companies");

                    if (cs == null || cs.isEmpty()) {

                    %>

                        <tr>

                            <td colspan="6"
                                class="empty-state">

                                No companies are currently available.

                            </td>

                        </tr>

                    <%

                    } else {

                        for (model.Company c : cs) {

                    %>

                        <tr>

                            <!-- Company ID -->

                            <td>

                                <span class="company-id">
                                    #<%=c.getCompanyId()%>
                                </span>

                            </td>


                            <!-- Company Name -->

                            <td>

                                <span class="company-name">
                                    <%=c.getCompanyName()%>
                                </span>

                            </td>


                            <!-- License -->

                            <td>

                                <span class="company-code">
                                    <%=c.getLicenseNo()%>
                                </span>

                            </td>


                            <!-- GST -->

                            <td>

                                <span class="company-code">
                                    <%=c.getGstNo()%>
                                </span>

                            </td>


                            <!-- Status -->

                            <td>

                                <% if ("Pending".equals(c.getApprovalStatus())) { %>

                                    <span class="status-badge status-pending">
                                        Pending
                                    </span>

                                <% } else if ("Active".equals(c.getApprovalStatus())) { %>

                                    <span class="status-badge status-active">
                                        Active
                                    </span>

                                <% } else { %>

                                    <span class="status-badge status-other">
                                        <%=c.getApprovalStatus()%>
                                    </span>

                                <% } %>

                            </td>


                            <!-- Action -->

                            <td class="text-end action-cell">

                                <% if ("Pending".equals(c.getApprovalStatus())) { %>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/app"
                                          class="d-inline">

                                        <input type="hidden"
                                               name="_csrf"
                                               value="<%=session.getAttribute("csrfToken")%>">

                                        <input type="hidden"
                                               name="action"
                                               value="approve-company">

                                        <input type="hidden"
                                               name="companyId"
                                               value="<%=c.getCompanyId()%>">

                                        <button type="submit"
                                                class="btn action-btn btn-approve">
                                            Approve
                                        </button>

                                    </form>

                                <% } else if ("Active".equals(c.getApprovalStatus())) { %>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/app"
                                          class="d-inline">

                                        <input type="hidden"
                                               name="_csrf"
                                               value="<%=session.getAttribute("csrfToken")%>">

                                        <input type="hidden"
                                               name="action"
                                               value="suspend-company">

                                        <input type="hidden"
                                               name="companyId"
                                               value="<%=c.getCompanyId()%>">

                                        <button type="submit"
                                                class="btn action-btn btn-suspend">
                                            Suspend
                                        </button>

                                    </form>

                                <% } else if ("Suspended".equals(c.getApprovalStatus())) { %>

                                    <span class="no-action">
                                        No action
                                    </span>

                                <% } %>

                            </td>

                        </tr>

                    <%

                        }

                    }

                    %>

                    </tbody>

                </table>

            </div>

        </div>

    </section>

</main>

</body>
</html>