<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Company Users — N Logistics</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700&family=IBM+Plex+Mono:wght@500;600&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/* =========================================================
   N LOGISTICS — CARGO MANIFEST DESIGN SYSTEM
   Company Users
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

/* ---------- Base ---------- */

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

/* ---------- Top Navigation ---------- */

.nl-nav {
    height: 72px;
    background: var(--ink);
    border-bottom: 1px solid var(--ink);
    padding: 0;
}

.nl-nav .container {
    max-width: none;
    width: 100%;
    padding-left: 34px;
    padding-right: 34px;
}

/* ---------- Brand ---------- */

.nl-brand {
    display: inline-flex;
    align-items: center;
    gap: 12px;
    text-decoration: none;
    color: #FFFFFF;
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

    font-family: "Archivo", sans-serif;
    font-size: 19px;
    font-weight: 700;

    border: 1px solid var(--orange);
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
    letter-spacing: -0.01em;
}

.nl-brand-sub {
    margin-top: 4px;

    color: #B9C3CC;

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 10px;
    font-weight: 500;

    letter-spacing: 0.13em;
    text-transform: uppercase;
}

/* ---------- Navigation Buttons ---------- */

.nl-nav-link {
    color: #FFFFFF !important;

    border: 1px solid rgba(255,255,255,0.25);
    background: transparent;

    border-radius: 0;

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 13px;
    font-weight: 600;

    padding: 8px 14px;
}

.nl-nav-link:hover {
    color: #FFFFFF !important;
    background: rgba(255,255,255,0.08);
    border-color: rgba(255,255,255,0.4);
}

.nl-nav .btn-outline-light {
    border-radius: 0;

    font-size: 13px;
    font-weight: 600;

    padding: 8px 14px;
}

/* ---------- Main Workspace ---------- */

.nl-content {
    max-width: none;
    width: 100%;

    padding: 34px 34px 60px;
}

/* ---------- Page Header ---------- */

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
    font-weight: 400;
}

/* ---------- Main Panel ---------- */

.nl-panel {
    width: 100%;

    background: var(--surface);

    border: 1px solid var(--border);
    border-radius: 0;
}

/* ---------- Panel Header ---------- */

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

/* ---------- Table ---------- */

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

/* ---------- User ID ---------- */

.user-id {
    color: var(--ink-soft);

    font-family: "IBM Plex Mono", monospace;
    font-size: 13px;
    font-weight: 500;
}

/* ---------- Username ---------- */

.username {
    color: var(--ink);

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 15px;
    font-weight: 600;
}

/* ---------- Email ---------- */

.user-email {
    color: var(--ink-soft);
}

/* ---------- Role ---------- */

.user-role {
    color: var(--ink);
    font-weight: 500;
}

/* ---------- Status Badges ---------- */

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
}

.status-active {
    color: var(--green);
    background: rgba(47,125,83,0.08);
    border-color: rgba(47,125,83,0.25);
}

.status-other {
    color: var(--ink-soft);
    background: #F3F5F5;
    border-color: var(--border);
}

/* ---------- Empty State ---------- */

.empty-state {
    padding: 46px 24px !important;

    color: var(--ink-soft);

    text-align: center;

    font-size: 15px;
}

/* ---------- Responsive ---------- */

@media (max-width: 768px) {

    .nl-nav .container {
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


<!-- =====================================================
     MAIN CONTENT
     ===================================================== -->

<main class="nl-content">

    <!-- Page Header -->

    <div class="page-header">

        <div class="page-kicker">
            Administration
        </div>

        <h1 class="page-title">
            Company users
        </h1>

        <p class="page-description">
            Review user identities, roles and account status available to your access level.
        </p>

    </div>


    <!-- User Directory -->

    <section class="nl-panel">

        <div class="nl-panel-header">

            <div>

                <h2>
                    User directory
                </h2>

                <p>
                    Role-based access is enforced on the server.
                </p>

            </div>

        </div>


        <div class="nl-panel-body p-0">

            <div class="table-responsive">

                <table class="table">

                    <thead>

                        <tr>

                            <th>ID</th>

                            <th>Username</th>

                            <th>Email</th>

                            <th>Role</th>

                            <th>Status</th>

                        </tr>

                    </thead>


                    <tbody>

                    <%

                    java.util.List<model.User> us =
                        (java.util.List<model.User>)
                        request.getAttribute("users");

                    if (us == null || us.isEmpty()) {

                    %>

                        <tr>

                            <td colspan="5"
                                class="empty-state">

                                No users are available.

                            </td>

                        </tr>

                    <%

                    } else {

                        for (model.User u : us) {

                    %>

                        <tr>

                            <!-- User ID -->

                            <td>

                                <span class="user-id">
                                    #<%=u.getUserId()%>
                                </span>

                            </td>


                            <!-- Username -->

                            <td>

                                <span class="username">
                                    <%=u.getUsername()%>
                                </span>

                            </td>


                            <!-- Email -->

                            <td>

                                <span class="user-email">
                                    <%=u.getEmail()%>
                                </span>

                            </td>


                            <!-- Role -->

                            <td>

                                <span class="user-role">
                                    <%=u.getRoleName()%>
                                </span>

                            </td>


                            <!-- Status -->

                            <td>

                                <% if ("Active".equals(u.getStatus())) { %>

                                    <span class="status-badge status-active">
                                        Active
                                    </span>

                                <% } else { %>

                                    <span class="status-badge status-other">
                                        <%=u.getStatus()%>
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