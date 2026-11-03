<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Request Error — N Logistics</title>

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
   ERROR AREA
   ========================================================= */

.nl-error {
    margin-top: 36px;

    background: var(--surface);
    border: 1px solid var(--border);

    border-radius: 0;

    padding: 34px 36px;
}

.nl-error-code {
    margin-bottom: 10px;

    color: var(--hold);

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 12px;
    font-weight: 600;

    letter-spacing: 0.10em;
    text-transform: uppercase;
}

.nl-error h2 {
    margin: 0;

    color: var(--ink);

    font-family: "Archivo", sans-serif;
    font-size: 30px;
    font-weight: 600;

    line-height: 1.15;
}

.nl-error p {
    max-width: 850px;

    margin: 14px 0 24px 0;

    color: var(--ink-soft);

    font-size: 15px;
}

/* =========================================================
   RETURN BUTTON
   ========================================================= */

.nl-return-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;

    min-height: 46px;

    padding: 10px 18px;

    background: var(--cargo);
    color: #FFFFFF;

    border: 1px solid var(--cargo);
    border-radius: 0;

    font-family: "IBM Plex Sans", sans-serif;
    font-size: 14px;
    font-weight: 600;

    text-decoration: none;
}

.nl-return-button:hover {
    background: #B94F21;
    border-color: #B94F21;
    color: #FFFFFF;
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

    .nl-error {
        margin-top: 24px;
        padding: 26px 22px;
    }

    .nl-error h2 {
        font-size: 26px;
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


<!-- =========================================================
     MAIN CONTENT
     ========================================================= -->

<main class="container nl-content">

    <section class="nl-error">

        <div class="nl-error-code">
            Request not completed
        </div>

        <h2>
            Something prevented this action.
        </h2>

        <p>
            <%=request.getAttribute("error") == null
                ? "Unexpected error."
                : request.getAttribute("error")%>
        </p>

        <a class="nl-return-button"
           href="${pageContext.request.contextPath}/app?action=home">
            Return to home
        </a>

    </section>

</main>

</body>
</html>