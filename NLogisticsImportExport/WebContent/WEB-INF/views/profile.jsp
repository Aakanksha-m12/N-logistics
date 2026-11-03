<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>My Profile — N Logistics</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700&family=IBM+Plex+Mono:wght@500;600&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">

<style>

    :root {
        --paper: #F0F2F1;
        --surface: #FFFFFF;
        --ink: #10202F;
        --ink-soft: #5C6A78;
        --orange: #D9622B;
        --border: #DFE3E2;
        --soft-cargo: #FBE7DB;
        --cleared: #2F7D53;
    }

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
    }

    /* =========================
       NAVIGATION
       ========================= */

    .nl-nav {
        min-height: 74px;
        padding: 0;
        background: var(--ink);
        border-bottom: 1px solid var(--ink);
    }

    .nl-nav .container {
        width: 100%;
        max-width: none;
        padding: 0 34px;
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
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 38px;
        height: 38px;
        background: var(--orange);
        color: #FFFFFF;
        font-family: "Archivo", sans-serif;
        font-size: 20px;
        font-weight: 700;
        line-height: 1;
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
        letter-spacing: -0.2px;
    }

    .nl-brand-sub {
        margin-top: 4px;
        color: #C8D0D6;
        font-size: 11px;
        font-weight: 500;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }

    .nl-nav-link {
        color: #FFFFFF;
        border: 1px solid transparent;
        border-radius: 0;
        font-size: 14px;
        font-weight: 500;
        padding: 9px 13px;
    }

    .nl-nav-link:hover {
        color: #FFFFFF;
        background: rgba(255,255,255,0.08);
        border-color: rgba(255,255,255,0.18);
    }

    .nl-nav .btn-outline-light {
        border-radius: 0;
        font-size: 14px;
        font-weight: 500;
        padding: 9px 14px;
    }

    /* =========================
       MAIN CONTENT
       ========================= */

    .nl-content {
        width: 100%;
        max-width: 1180px;
        margin: 0 auto;
        padding: 48px 30px 70px;
    }

    .page-header {
        padding-bottom: 28px;
        border-bottom: 1px solid var(--border);
        margin-bottom: 28px;
    }

    .page-kicker {
        margin-bottom: 9px;
        color: var(--orange);
        font-family: "Archivo", sans-serif;
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 0.8px;
        text-transform: uppercase;
    }

    .page-title {
        margin: 0;
        color: var(--ink);
        font-family: "Archivo", sans-serif;
        font-size: 40px;
        font-weight: 700;
        line-height: 1.1;
        letter-spacing: -0.8px;
    }

    .page-description {
        max-width: 720px;
        margin: 13px 0 0;
        color: var(--ink-soft);
        font-size: 15px;
        line-height: 1.65;
    }

    /* =========================
       PROFILE GRID
       ========================= */

    .nl-profile-grid {
        display: grid;
        grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
        gap: 20px;
        width: 100%;
    }

    /* =========================
       PANELS
       ========================= */

    .nl-panel {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 0;
        box-shadow: none;
    }

    .nl-panel-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 20px;
        padding: 24px 26px;
        border-bottom: 1px solid var(--border);
    }

    .nl-panel-header h2 {
        margin: 0;
        color: var(--ink);
        font-family: "Archivo", sans-serif;
        font-size: 21px;
        font-weight: 700;
        line-height: 1.25;
    }

    .nl-panel-header p {
        margin: 7px 0 0;
        color: var(--ink-soft);
        font-size: 14px;
        line-height: 1.5;
    }

    .nl-panel-body {
        padding: 26px;
    }

    /* =========================
       PROFILE INFORMATION
       ========================= */

    .profile-meta {
        display: grid;
        gap: 0;
    }

    .meta-item {
        padding: 16px 0;
        border-bottom: 1px solid var(--border);
    }

    .meta-item:first-child {
        padding-top: 0;
    }

    .meta-item:last-child {
        border-bottom: 0;
        padding-bottom: 0;
    }

    .meta-label {
        margin-bottom: 6px;
        color: var(--ink-soft);
        font-size: 12px;
        font-weight: 600;
        letter-spacing: 0.4px;
        text-transform: uppercase;
    }

    .meta-value {
        color: var(--ink);
        font-size: 16px;
        font-weight: 500;
        line-height: 1.45;
    }

    .meta-item:first-child .meta-value {
        font-family: "IBM Plex Mono", monospace;
        font-size: 15px;
        font-weight: 600;
    }

    /* =========================
       STATUS
       ========================= */

    .status-value {
        display: inline-flex;
        align-items: center;
        min-height: 28px;
        padding: 5px 9px;
        border: 1px solid #B8D2C2;
        background: #EAF3ED;
        color: var(--cleared);
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }

    /* =========================
       RULE
       ========================= */

    .nl-rule {
        margin: 26px 0;
        border: 0;
        border-top: 1px solid var(--border);
        opacity: 1;
    }

    /* =========================
       FORM
       ========================= */

    .form-label {
        margin-bottom: 8px;
        color: var(--ink);
        font-size: 14px;
        font-weight: 600;
    }

    .form-control {
        min-height: 50px;
        border: 1px solid #BFC7C9;
        border-radius: 0;
        background: #FFFFFF;
        color: var(--ink);
        font-family: "IBM Plex Sans", sans-serif;
        font-size: 15px;
        padding: 12px 14px;
        box-shadow: none;
    }

    .form-control:focus {
        border-color: var(--orange);
        box-shadow: 0 0 0 1px var(--orange);
    }

    .form-control::placeholder {
        color: #89939B;
    }

    /* =========================
       BUTTONS
       ========================= */

    .action-row {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 14px;
        padding-top: 4px;
    }

    .btn {
        border-radius: 0;
        font-size: 14px;
        font-weight: 600;
    }

    .btn-primary {
        min-height: 48px;
        padding: 11px 18px;
        border: 1px solid var(--orange);
        background: var(--orange);
        color: #FFFFFF;
    }

    .btn-primary:hover,
    .btn-primary:focus,
    .btn-primary:active {
        border-color: #C65320 !important;
        background: #C65320 !important;
        color: #FFFFFF !important;
        box-shadow: none !important;
    }

    .btn-secondary {
        min-height: 46px;
        padding: 10px 17px;
        border: 1px solid #BFC7C9;
        background: #FFFFFF;
        color: var(--ink);
    }

    .btn-secondary:hover,
    .btn-secondary:focus,
    .btn-secondary:active {
        border-color: var(--ink);
        background: var(--ink);
        color: #FFFFFF;
        box-shadow: none;
    }

    /* =========================
       RESPONSIVE
       ========================= */

    @media (max-width: 900px) {

        .nl-profile-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 760px) {

        .nl-nav .container {
            padding: 0 20px;
        }

        .nl-content {
            padding: 34px 18px 50px;
        }

        .page-title {
            font-size: 33px;
        }

        .nl-panel-header {
            padding: 22px 20px;
        }

        .nl-panel-body {
            padding: 24px 20px 28px;
        }
    }

    @media (max-width: 480px) {

        .nl-brand-sub {
            display: none;
        }

        .nl-brand-name {
            font-size: 16px;
        }

        .nl-brand-mark {
            width: 34px;
            height: 34px;
        }

        .nl-nav-link {
            display: none;
        }

        .page-title {
            font-size: 29px;
        }

        .page-description {
            font-size: 14px;
        }

        .action-row {
            justify-content: stretch;
        }

        .action-row .btn {
            width: 100%;
        }
    }

</style>
</head>

<body>

<nav class="navbar nl-nav">

    <div class="container">

        <a class="nl-brand"
           href="${pageContext.request.contextPath}/app?action=home"
           aria-label="N Logistics home">

            <span class="nl-brand-mark">N</span>

            <span class="nl-brand-copy">
                <span class="nl-brand-name">N Logistics</span>
                <span class="nl-brand-sub">Import &amp; Export</span>
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


<main class="container nl-content">

    <%
        model.User u = (model.User) request.getAttribute("user");
    %>


    <div class="page-header">

        <div class="page-kicker">
            Account
        </div>

        <h1 class="page-title">
            My profile
        </h1>

        <p class="page-description">
            Your identity, access level and contact details in N Logistics.
        </p>

    </div>


    <section class="nl-profile-grid">


        <!-- ACCOUNT IDENTITY -->

        <div class="nl-panel">

            <div class="nl-panel-header">

                <div>

                    <h2>
                        Account identity
                    </h2>

                    <p>
                        Read-only access information.
                    </p>

                </div>

            </div>


            <div class="nl-panel-body">

                <div class="profile-meta">

                    <div class="meta-item">

                        <div class="meta-label">
                            Username
                        </div>

                        <div class="meta-value">
                            <%=u.getUsername()%>
                        </div>

                    </div>


                    <div class="meta-item">

                        <div class="meta-label">
                            Role
                        </div>

                        <div class="meta-value">
                            <%=u.getRoleName()%>
                        </div>

                    </div>


                    <div class="meta-item">

                        <div class="meta-label">
                            Status
                        </div>

                        <div class="meta-value">

                            <span class="status-value">
                                <%=u.getStatus()%>
                            </span>

                        </div>

                    </div>

                </div>


                <hr class="nl-rule">


                <a class="btn btn-secondary"
                   href="${pageContext.request.contextPath}/app?action=forgot-password">
                    Reset password
                </a>

            </div>

        </div>


        <!-- CONTACT INFORMATION -->

        <div class="nl-panel">

            <div class="nl-panel-header">

                <div>

                    <h2>
                        Contact information
                    </h2>

                    <p>
                        Update the details associated with your account.
                    </p>

                </div>

            </div>


            <div class="nl-panel-body">

                <form method="post"
                      action="${pageContext.request.contextPath}/app">

                    <input type="hidden"
                           name="_csrf"
                           value="<%=session.getAttribute("csrfToken")%>">

                    <input type="hidden"
                           name="action"
                           value="update-profile">


                    <div class="mb-3">

                        <label class="form-label"
                               for="email">
                            Email
                        </label>

                        <input id="email"
                               class="form-control"
                               type="email"
                               name="email"
                               value="<%=u.getEmail()%>"
                               placeholder="Email"
                               autocomplete="email"
                               required>

                    </div>


                    <div class="mb-3">

                        <label class="form-label"
                               for="phone">
                            Phone
                        </label>

                        <input id="phone"
                               class="form-control"
                               name="phone"
                               value="<%=u.getPhone() == null ? "" : u.getPhone()%>"
                               placeholder="Phone"
                               autocomplete="tel">

                    </div>


                    <div class="action-row">

                        <button class="btn btn-primary"
                                type="submit">
                            Save changes
                        </button>

                    </div>

                </form>

            </div>

        </div>


    </section>

</main>

</body>
</html>