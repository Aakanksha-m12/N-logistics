<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Company Registration — N Logistics</title>

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
        max-width: 820px;
        margin: 13px 0 0;
        color: var(--ink-soft);
        font-size: 15px;
        line-height: 1.65;
    }

    /* =========================
       PANEL
       ========================= */

    .max-760 {
        max-width: 760px;
    }

    .nl-panel {
        width: 100%;
        margin-left: auto;
        margin-right: auto;
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 0;
        box-shadow: none;
    }

    .nl-panel-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 24px;
        padding: 24px 28px;
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

    .role-chip {
        flex-shrink: 0;
        display: inline-flex;
        align-items: center;
        min-height: 32px;
        padding: 6px 10px;
        background: var(--soft-cargo);
        color: var(--orange);
        border: 1px solid #EBC9B8;
        border-radius: 0;
        font-size: 12px;
        font-weight: 600;
        white-space: nowrap;
    }

    .nl-panel-body {
        padding: 30px 28px 32px;
    }

    /* =========================
       FORM SECTIONS
       ========================= */

    .form-section {
        padding-bottom: 28px;
        margin-bottom: 28px;
        border-bottom: 1px solid var(--border);
    }

    .form-section:last-of-type {
        padding-bottom: 0;
        margin-bottom: 30px;
        border-bottom: 0;
    }

    .form-section-title {
        margin-bottom: 18px;
        color: var(--ink);
        font-family: "Archivo", sans-serif;
        font-size: 16px;
        font-weight: 700;
    }

    .form-section-title span {
        display: block;
        margin-top: 4px;
        color: var(--ink-soft);
        font-family: "IBM Plex Sans", sans-serif;
        font-size: 13px;
        font-weight: 400;
    }

    /* =========================
       FORM CONTROLS
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

    textarea.form-control {
        min-height: 105px;
        resize: vertical;
        line-height: 1.5;
    }

    .form-control::placeholder {
        color: #89939B;
    }

    .form-control:focus {
        border-color: var(--orange);
        box-shadow: 0 0 0 1px var(--orange);
    }

    /* =========================
       ACTIONS
       ========================= */

    .action-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 14px;
        padding-top: 2px;
    }

    .action-row .btn {
        min-height: 48px;
        border-radius: 0;
        font-size: 14px;
        font-weight: 600;
        padding: 11px 18px;
    }

    .btn-primary {
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
            flex-direction: column;
            padding: 22px 20px;
        }

        .nl-panel-body {
            padding: 25px 20px 28px;
        }

        .action-row {
            flex-direction: column-reverse;
            align-items: stretch;
        }

        .action-row .btn {
            width: 100%;
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

    <div class="page-header">

        <div class="page-kicker">
            Onboarding / Business
        </div>

        <h1 class="page-title">
            Register a company
        </h1>

        <p class="page-description">
            Submit the company and administrator details required to create a
            N Logistics business account. Company activation is subject to
            Super Admin approval.
        </p>

    </div>


    <section class="nl-panel max-760 mx-auto">

        <div class="nl-panel-header">

            <div>

                <h2>
                    Company details
                </h2>

                <p>
                    Use the official business information for registration.
                </p>

            </div>

            <span class="role-chip mt-0">
                Company account
            </span>

        </div>


        <div class="nl-panel-body">

            <form method="post"
                  action="${pageContext.request.contextPath}/app"
                  autocomplete="on">

                <input type="hidden"
                       name="_csrf"
                       value="<%=session.getAttribute("csrfToken")%>">

                <input type="hidden"
                       name="action"
                       value="register-company">


                <!-- BUSINESS IDENTITY -->

                <div class="form-section">

                    <div class="form-section-title">
                        Business identity
                        <span>Registration and tax identifiers</span>
                    </div>


                    <div class="row g-3">

                        <div class="col-md-6">

                            <label class="form-label"
                                   for="companyName">
                                Company name
                            </label>

                            <input id="companyName"
                                   class="form-control"
                                   name="companyName"
                                   placeholder="Legal company name"
                                   required>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="licenseNo">
                                License number
                            </label>

                            <input id="licenseNo"
                                   class="form-control"
                                   name="licenseNo"
                                   placeholder="Business license number"
                                   required>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="gstNo">
                                GST number
                            </label>

                            <input id="gstNo"
                                   class="form-control"
                                   name="gstNo"
                                   placeholder="GST registration number"
                                   required>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="tinNo">
                                TIN number
                            </label>

                            <input id="tinNo"
                                   class="form-control"
                                   name="tinNo"
                                   placeholder="Tax identification number"
                                   required>

                        </div>


                        <div class="col-12">

                            <label class="form-label"
                                   for="address">
                                Registered address
                            </label>

                            <textarea id="address"
                                      class="form-control"
                                      name="address"
                                      placeholder="Full registered business address"
                                      required></textarea>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="contactEmail">
                                Company email
                            </label>

                            <input id="contactEmail"
                                   class="form-control"
                                   type="email"
                                   name="contactEmail"
                                   placeholder="business@example.com"
                                   autocomplete="email"
                                   required>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="contactPhone">
                                Company phone
                            </label>

                            <input id="contactPhone"
                                   class="form-control"
                                   name="contactPhone"
                                   placeholder="+91 ..."
                                   autocomplete="tel"
                                   required>

                        </div>

                    </div>

                </div>


                <!-- COMPANY ADMINISTRATOR -->

                <div class="form-section">

                    <div class="form-section-title">
                        Company administrator
                        <span>The first administrator account for this company</span>
                    </div>


                    <div class="row g-3">

                        <div class="col-md-6">

                            <label class="form-label"
                                   for="adminUsername">
                                Admin username
                            </label>

                            <input id="adminUsername"
                                   class="form-control"
                                   name="adminUsername"
                                   placeholder="Choose a username"
                                   autocomplete="username"
                                   required>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="adminEmail">
                                Admin email
                            </label>

                            <input id="adminEmail"
                                   class="form-control"
                                   type="email"
                                   name="adminEmail"
                                   placeholder="admin@example.com"
                                   autocomplete="email"
                                   required>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="adminPassword">
                                Admin password
                            </label>

                            <input id="adminPassword"
                                   class="form-control"
                                   type="password"
                                   name="adminPassword"
                                   placeholder="Minimum 8 characters"
                                   autocomplete="new-password"
                                   minlength="8"
                                   required>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label"
                                   for="adminPhone">
                                Admin phone
                            </label>

                            <input id="adminPhone"
                                   class="form-control"
                                   name="adminPhone"
                                   placeholder="+91 ..."
                                   autocomplete="tel"
                                   required>

                        </div>

                    </div>

                </div>


                <!-- ACTIONS -->

                <div class="action-row">

                    <a class="btn btn-secondary"
                       href="${pageContext.request.contextPath}/app?action=login">
                        Back to sign in
                    </a>

                    <button class="btn btn-primary"
                            type="submit">
                        Submit company registration
                    </button>

                </div>

            </form>

        </div>

    </section>

</main>

</body>
</html>