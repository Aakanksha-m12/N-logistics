<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Audit Log — N Logistics</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700&family=IBM+Plex+Mono:wght@500;600&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/* =========================================================
   N LOGISTICS — CARGO MANIFEST DESIGN SYSTEM
   ========================================================= */

:root {
    --paper: #F0F2F1;
    --surface: #FFFFFF;
    --ink: #10202F;
    --ink-soft: #5C6A78;

    --cargo: #D9622B;
    --cleared: #2F7D53;
    --transit: #A66A1E;
    --hold: #B23A2E;

    --border: #DFE3E2;
    --soft-cargo: #FBE7DB;
}

/* =========================================================
   BASE
   ========================================================= */

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
   NAVIGATION
   ========================================================= */

.nl-nav {
    min-height: 76px;
    padding: 0;
    background: var(--ink);
    border-bottom: 1px solid var(--ink);
}

.nl-nav .container {
    max-width: none;
    width: 100%;
    padding-left: 32px;
    padding-right: 32px;
}

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

    background: var(--cargo);
    color: #FFFFFF;

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
    font-family: "Archivo", sans-serif;
    font-size: 17px;
    font-weight: 700;
    letter-spacing: 0.01em;
}

.nl-brand-sub {
    margin-top: 5px;

    color: #BFC8CF;

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 11px;
    font-weight: 500;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

.nl-nav-link {
    color: #FFFFFF !important;
    border: 1px solid transparent;
    border-radius: 0 !important;

    font-size: 14px;
    font-weight: 500;

    padding: 9px 14px;
}

.nl-nav-link:hover {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.20);
}

.nl-nav .btn-outline-light {
    border-radius: 0 !important;
    font-size: 14px;
    font-weight: 500;
    padding: 9px 15px;
}

/* =========================================================
   MAIN CONTENT
   ========================================================= */

.nl-content {
    width: 100%;
    max-width: none;

    margin: 0;
    padding: 0 32px 50px 32px;
}

/* =========================================================
   PAGE HEADER
   ========================================================= */

.page-header {
    padding: 36px 0 30px 0;
    border-bottom: 1px solid var(--border);
}

.page-kicker {
    margin-bottom: 8px;

    color: var(--ink-soft);

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 12px;
    font-weight: 600;

    letter-spacing: 0.10em;
    text-transform: uppercase;
}

.page-title {
    margin: 0;

    color: var(--ink);

    font-family: "Archivo", sans-serif;
    font-size: 42px;
    font-weight: 700;

    line-height: 1.08;
    letter-spacing: -0.025em;
}

.page-description {
    max-width: 720px;

    margin: 12px 0 0 0;

    color: var(--ink-soft);

    font-size: 15px;
    font-weight: 400;
}

/* =========================================================
   PANEL
   ========================================================= */

.nl-panel {
    margin-top: 30px;

    background: var(--surface);
    border: 1px solid var(--border);

    border-radius: 0;
}

.nl-panel-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;

    padding: 24px 26px;

    border-bottom: 1px solid var(--border);
}

.nl-panel-header h2 {
    margin: 0;

    color: var(--ink);

    font-family: "Archivo", sans-serif;
    font-size: 22px;
    font-weight: 600;
}

.nl-panel-header p {
    margin: 7px 0 0 0;

    color: var(--ink-soft);

    font-size: 14px;
}

/* =========================================================
   TABLE
   ========================================================= */

.nl-panel-body {
    background: var(--surface);
}

.table-responsive {
    overflow-x: auto;
}

.table {
    width: 100%;
    margin: 0;

    color: var(--ink);

    border-collapse: collapse;
    font-size: 14px;
}

.table > :not(caption) > * > * {
    padding: 15px 16px;
    border-bottom: 1px solid var(--border);
    vertical-align: middle;
}

.table thead th {
    background: var(--paper);

    color: var(--ink-soft);

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 12px;
    font-weight: 600;

    letter-spacing: 0.07em;
    text-transform: uppercase;

    white-space: nowrap;
}

.table tbody td {
    color: var(--ink);
    font-size: 14px;
}

.table tbody tr:last-child td {
    border-bottom: 0;
}

.table tbody tr:hover {
    background: #FAFBFB;
}

.table strong {
    font-weight: 600;
}

/* =========================================================
   MONOSPACE VALUES
   ========================================================= */

.audit-time,
.audit-ip,
.audit-id {
    font-family: "IBM Plex Mono", monospace;
    font-size: 13px;
    font-weight: 500;
}

.audit-time {
    white-space: nowrap;
}

.audit-ip {
    color: var(--ink-soft);
    white-space: nowrap;
}

.audit-id {
    color: var(--ink-soft);
}

/* =========================================================
   EMPTY STATE
   ========================================================= */

.empty-state {
    padding: 48px 20px !important;

    color: var(--ink-soft) !important;

    text-align: center;
    font-size: 14px !important;
}

/* =========================================================
   RESPONSIVE
   ========================================================= */

@media (max-width: 768px) {

    .nl-nav .container {
        padding-left: 18px;
        padding-right: 18px;
    }

    .nl-content {
        padding-left: 18px;
        padding-right: 18px;
    }

    .page-header {
        padding-top: 28px;
        padding-bottom: 24px;
    }

    .page-title {
        font-size: 34px;
    }

    .nl-panel-header {
        padding: 20px;
    }

    .table > :not(caption) > * > * {
        padding: 13px 12px;
    }

    .nl-brand-sub {
        display: none;
    }
}

</style>

</head>

<body>

<!-- =========================================================
     NAVIGATION
     ========================================================= -->

<nav class="navbar nl-nav">

    <div class="container">

        <a class="nl-brand"
           href="${pageContext.request.contextPath}/app?action=home"
           aria-label="N Logistics home">

            <span class="nl-brand-mark">N</span>

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


<!-- =========================================================
     MAIN CONTENT
     ========================================================= -->

<main class="container nl-content">

    <div class="page-header">

        <div class="page-kicker">
            Security / Super Admin
        </div>

        <h1 class="page-title">
            Audit log
        </h1>

        <p class="page-description">
            Recorded authentication, authorization and administrative events.
        </p>

    </div>


    <!-- =====================================================
         AUDIT EVENT HISTORY
         ===================================================== -->

    <section class="nl-panel">

        <div class="nl-panel-header">

            <div>

                <h2>
                    Event history
                </h2>

                <p>
                    Use this record to review system activity and administrative changes.
                </p>

            </div>

        </div>


        <div class="nl-panel-body p-0">

            <div class="table-responsive border-0">

                <table class="table">

                    <thead>

                        <tr>

                            <th>Time</th>
                            <th>User</th>
                            <th>Action</th>
                            <th>Entity</th>
                            <th>Old</th>
                            <th>New</th>
                            <th>IP</th>

                        </tr>

                    </thead>


                    <tbody>

                    <%
                    java.util.List<model.AuditLog> ls =
                        (java.util.List<model.AuditLog>)
                        request.getAttribute("logs");

                    if (ls == null || ls.isEmpty()) {
                    %>

                        <tr>

                            <td colspan="7"
                                class="empty-state">

                                No audit events are available.

                            </td>

                        </tr>

                    <%
                    } else {

                        for (model.AuditLog a : ls) {
                    %>

                        <tr>

                            <td class="audit-time">
                                <%=a.getTimestamp()%>
                            </td>

                            <td>
                                <strong>
                                    <%=a.getUsername()%>
                                </strong>
                            </td>

                            <td>
                                <%=a.getAction()%>
                            </td>

                            <td>

                                <%=a.getEntityName()%>

                                <span class="audit-id">
                                    #<%=a.getEntityId()%>
                                </span>

                            </td>

                            <td>
                                <%=a.getOldValue()%>
                            </td>

                            <td>
                                <%=a.getNewValue()%>
                            </td>

                            <td class="audit-ip">
                                <%=a.getIpAddress()%>
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