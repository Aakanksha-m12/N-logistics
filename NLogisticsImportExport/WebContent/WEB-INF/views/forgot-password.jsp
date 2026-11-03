<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Reset Password — N Logistics</title>

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
        --green: #2F7D53;
        --amber: #A66A1E;
        --red: #B23A2E;
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
       PAGE
       ========================= */

    .auth-page {
        min-height: calc(100vh - 74px);
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding: 68px 24px 80px;
    }

    .auth-card {
        width: 100%;
        max-width: 560px;
    }

    .auth-card .card {
        border: 1px solid var(--border);
        border-radius: 0;
        background: var(--surface);
        box-shadow: none;
    }

    .auth-card .card-body {
        padding: 42px 44px 38px;
    }

    /* =========================
       AUTH BRAND
       ========================= */

    .auth-brand {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 26px;
        color: var(--ink-soft);
        font-size: 13px;
        font-weight: 600;
        letter-spacing: 0.2px;
        text-transform: uppercase;
    }

    .auth-brand-mark {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 30px;
        height: 30px;
        background: var(--soft-cargo);
        color: var(--orange);
        font-family: "Archivo", sans-serif;
        font-size: 16px;
        font-weight: 700;
    }

    /* =========================
       HEADINGS
       ========================= */

    .auth-title {
        margin: 0;
        color: var(--ink);
        font-family: "Archivo", sans-serif;
        font-size: 38px;
        font-weight: 700;
        line-height: 1.08;
        letter-spacing: -0.7px;
    }

    .auth-subtitle {
        margin: 14px 0 30px;
        color: var(--ink-soft);
        font-size: 15px;
        line-height: 1.65;
    }

    /* =========================
       ALERTS
       ========================= */

    .auth-card .alert {
        border-radius: 0;
        margin-bottom: 22px;
        padding: 13px 15px;
        font-size: 14px;
        line-height: 1.5;
    }

    .auth-card .alert-info {
        color: var(--ink);
        background: #EEF1F2;
        border: 1px solid var(--border);
    }

    .auth-card .alert-danger {
        color: var(--red);
        background: #F9E9E7;
        border: 1px solid #E7C5C1;
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
        color: var(--ink);
        background: #FFFFFF;
        font-family: "IBM Plex Sans", sans-serif;
        font-size: 15px;
        padding: 12px 14px;
        box-shadow: none;
    }

    .form-control::placeholder {
        color: #89939B;
    }

    .form-control:focus {
        border-color: var(--orange);
        box-shadow: 0 0 0 1px var(--orange);
    }

    .btn-primary {
        min-height: 50px;
        border: 1px solid var(--orange);
        border-radius: 0;
        background: var(--orange);
        color: #FFFFFF;
        font-family: "IBM Plex Sans", sans-serif;
        font-size: 15px;
        font-weight: 600;
        padding: 12px 18px;
    }

    .btn-primary:hover,
    .btn-primary:focus,
    .btn-primary:active {
        border-color: #C65320 !important;
        background: #C65320 !important;
        color: #FFFFFF !important;
        box-shadow: none !important;
    }

    /* =========================
       FOOTER
       ========================= */

    .auth-footer {
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid var(--border);
        text-align: center;
        font-size: 14px;
    }

    .auth-footer a {
        color: var(--ink);
        font-weight: 600;
        text-decoration: none;
        border-bottom: 1px solid var(--orange);
        padding-bottom: 2px;
    }

    .auth-footer a:hover {
        color: var(--orange);
    }

    /* =========================
       RESPONSIVE
       ========================= */

    @media (max-width: 700px) {

        .nl-nav .container {
            padding: 0 20px;
        }

        .auth-page {
            padding: 36px 16px 50px;
        }

        .auth-card .card-body {
            padding: 32px 26px 30px;
        }

        .auth-title {
            font-size: 32px;
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

        .auth-card .card-body {
            padding: 28px 20px 26px;
        }

        .auth-title {
            font-size: 29px;
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


<main class="auth-page">

    <section class="auth-card">

        <div class="card">

            <div class="card-body">

                <div class="auth-brand">
                    <span class="auth-brand-mark">N</span>
                    <span>N Logistics / Account recovery</span>
                </div>

                <h1 class="auth-title">
                    Reset your password
                </h1>

                <p class="auth-subtitle">
                    Enter your username or email. A single-use 6-digit
                    reset code is generated for 10 minutes.
                </p>


                <% if (request.getAttribute("message") != null) { %>

                    <div class="alert alert-info">
                        <%=request.getAttribute("message")%>
                    </div>

                <% } %>


                <% if (request.getAttribute("error") != null) { %>

                    <div class="alert alert-danger">
                        <%=request.getAttribute("error")%>
                    </div>

                <% } %>


                <form method="post"
                      action="${pageContext.request.contextPath}/app">

                    <input type="hidden"
                           name="_csrf"
                           value="<%=session.getAttribute("csrfToken")%>">

                    <input type="hidden"
                           name="action"
                           value="forgot-password">


                    <div class="mb-3">

                        <label class="form-label"
                               for="login">
                            Username / Email
                        </label>

                        <input id="login"
                               class="form-control"
                               name="login"
                               placeholder="Username or email"
                               autocomplete="username email"
                               required>

                    </div>


                    <button class="btn btn-primary w-100"
                            type="submit">
                        Send reset code
                    </button>

                </form>


                <div class="auth-footer">
                    <a href="${pageContext.request.contextPath}/app?action=login">
                        Return to sign in
                    </a>
                </div>

            </div>

        </div>

    </section>

</main>

</body>
</html>