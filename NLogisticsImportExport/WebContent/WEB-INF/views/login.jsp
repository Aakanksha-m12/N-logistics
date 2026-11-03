<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1">

<title>Sign in — N Logistics</title>


<!-- =====================================================
     GOOGLE FONTS
     ===================================================== -->

<link rel="preconnect"
      href="https://fonts.googleapis.com">

<link rel="preconnect"
      href="https://fonts.gstatic.com"
      crossorigin>

<link
    href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@500;600&display=swap"
    rel="stylesheet">


<!-- =====================================================
     BOOTSTRAP
     ===================================================== -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<style>

/* =====================================================
   N LOGISTICS — CARGO MANIFEST DESIGN SYSTEM
   ===================================================== */

:root {

    --paper: #F0F2F1;

    --surface: #FFFFFF;

    --ink: #10202F;

    --ink-soft: #5C6A78;

    --ink-faint: #8B96A0;

    --line: #DFE3E2;

    --cargo: #D9622B;

    --cargo-soft: #FBE7DB;

    --hold: #B23A2E;
}


/* =====================================================
   GLOBAL
   ===================================================== */

* {
    box-sizing: border-box;
}


html,
body {

    margin: 0;

    padding: 0;

    min-height: 100%;

    background: var(--paper);

    color: var(--ink);

    font-family:
        'IBM Plex Sans',
        sans-serif;

    font-size: 15px;
}


body {

    overflow-x: hidden;
}


h1,
h2,
h3 {

    font-family:
        'Archivo',
        sans-serif;
}


button,
input {

    font-family:
        'IBM Plex Sans',
        sans-serif;
}


/* =====================================================
   NAVIGATION
   ===================================================== */

.nl-nav {

    min-height: 76px;

    background:
        var(--ink);

    border-bottom:
        1px solid
        #243442;

    padding:
        0 34px;
}


.nl-nav-inner {

    width: 100%;

    display: flex;

    align-items: center;

    justify-content: space-between;
}


/* =====================================================
   BRAND
   ===================================================== */

.nl-brand {

    display: flex;

    align-items: center;

    text-decoration: none;

    color: white;
}


.nl-brand-mark {

    width: 38px;

    height: 38px;

    display: flex;

    align-items: center;

    justify-content: center;

    background:
        var(--cargo);

    color: white;

    font-family:
        'Archivo',
        sans-serif;

    font-size: 17px;

    font-weight: 700;

    margin-right: 12px;
}


.nl-brand-copy {

    display: flex;

    flex-direction: column;
}


.nl-brand-name {

    color: white;

    font-family:
        'Archivo',
        sans-serif;

    font-size: 16px;

    font-weight: 600;

    letter-spacing:
        .3px;

    line-height: 1.1;
}


.nl-brand-sub {

    color:
        #91A0AA;

    font-size: 9px;

    font-weight: 600;

    letter-spacing:
        1.6px;

    text-transform:
        uppercase;

    margin-top: 4px;
}


/* =====================================================
   NAV BUTTONS
   ===================================================== */

.nl-nav-action {

    display: flex;

    align-items: center;

    gap: 10px;
}


.nl-nav-link {

    color:
        #D5DEE2;

    font-size:
        14px;

    font-weight:
        500;

    text-decoration:
        none;

    padding:
        9px 13px;

    border:
        1px solid
        transparent;
}


.nl-nav-link:hover {

    color:
        white;

    border-color:
        #50616D;
}


.nl-nav-login {

    color:
        white;

    background:
        transparent;

    border:
        1px solid
        #60717C;

    padding:
        9px 17px;

    font-size:
        14px;

    font-weight:
        500;

    text-decoration:
        none;
}


.nl-nav-login:hover {

    color:
        white;

    background:
        #193346;

    border-color:
        var(--cargo);
}


/* =====================================================
   MAIN AUTH PAGE
   ===================================================== */

.auth-page {

    min-height:
        calc(100vh - 76px);

    padding:
        48px 34px 60px;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;
}


/* =====================================================
   LOGIN SHELL
   ===================================================== */

.login-shell {

    width:
        min(1080px, 100%);

    min-height:
        620px;

    display:
        grid;

    grid-template-columns:
        1fr 1fr;

    background:
        var(--surface);

    border:
        1px solid
        var(--line);
}


/* =====================================================
   LEFT VISUAL PANEL
   ===================================================== */

.login-visual {

    position:
        relative;

    background:
        var(--ink);

    color:
        white;

    padding:
        48px;

    display:
        flex;

    flex-direction:
        column;

    justify-content:
        space-between;

    overflow:
        hidden;
}


/*
 * Subtle structural lines.
 * No gradient and no shadow.
 */

.login-visual::before {

    content: "";

    position:
        absolute;

    left:
        48px;

    right:
        48px;

    top:
        180px;

    height:
        1px;

    background:
        #293C49;
}


.login-visual::after {

    content: "";

    position:
        absolute;

    width:
        330px;

    height:
        330px;

    border:
        1px solid
        rgba(217,98,43,.20);

    border-radius:
        50%;

    right:
        -150px;

    bottom:
        -150px;
}


/* =====================================================
   VISUAL BRAND
   ===================================================== */

.login-visual-brand {

    position:
        relative;

    z-index:
        2;

    display:
        flex;

    align-items:
        center;

    font-family:
        'Archivo',
        sans-serif;

    font-size:
        15px;

    font-weight:
        600;

    line-height:
        1.3;
}


.login-visual-mark {

    width:
        42px;

    height:
        42px;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;

    margin-right:
        13px;

    background:
        var(--cargo);

    color:
        white;

    font-size:
        18px;

    font-weight:
        700;
}


/* =====================================================
   VISUAL COPY
   ===================================================== */

.login-visual-copy {

    position:
        relative;

    z-index:
        2;

    max-width:
        430px;
}


.login-visual-kicker {

    color:
        var(--cargo);

    font-size:
        12px;

    font-weight:
        600;

    letter-spacing:
        1.4px;

    text-transform:
        uppercase;

    margin-bottom:
        17px;
}


.login-visual h1 {

    margin:
        0;

    color:
        white;

    font-family:
        'Archivo',
        sans-serif;

    font-size:
        clamp(38px, 4vw, 50px);

    font-weight:
        600;

    line-height:
        1.08;

    letter-spacing:
        -.8px;
}


.login-visual-copy p {

    margin:
        20px 0 0;

    color:
        #B8C4CA;

    font-size:
        15px;

    line-height:
        1.7;

    max-width:
        410px;
}


/* =====================================================
   ROUTE
   ===================================================== */

.login-route {

    position:
        relative;

    z-index:
        2;

    display:
        flex;

    align-items:
        center;

    gap:
        14px;

    color:
        #AEBBC1;

    font-family:
        'IBM Plex Mono',
        monospace;

    font-size:
        12px;

    font-weight:
        500;

    text-transform:
        uppercase;

    letter-spacing:
        .7px;
}


.login-route-line {

    width:
        90px;

    height:
        1px;

    background:
        #566773;

    position:
        relative;
}


.login-route-line::after {

    content: "";

    position:
        absolute;

    right:
        0;

    top:
        -3px;

    width:
        7px;

    height:
        7px;

    background:
        var(--cargo);
}


/* =====================================================
   RIGHT FORM
   ===================================================== */

.login-form {

    background:
        var(--surface);

    padding:
        48px 52px;

    display:
        flex;

    align-items:
        center;
}


.login-form-inner {

    width:
        100%;

    max-width:
        440px;

    margin:
        0 auto;
}


/* =====================================================
   FORM HEADER
   ===================================================== */

.card-header-custom {

    margin-bottom:
        30px;
}


.card-header-custom h2 {

    margin:
        0;

    color:
        var(--ink);

    font-family:
        'Archivo',
        sans-serif;

    font-size:
        30px;

    font-weight:
        600;

    letter-spacing:
        -.3px;
}


.card-header-custom p {

    margin:
        9px 0 0;

    color:
        var(--ink-soft);

    font-size:
        14px;

    line-height:
        1.6;
}


/* =====================================================
   ALERTS
   ===================================================== */

.alert {

    border-radius:
        0;

    font-size:
        13px;

    padding:
        12px 14px;

    margin-bottom:
        20px;
}


.alert-success {

    color:
        #2F7D53;

    background:
        #E4F2E9;

    border:
        1px solid
        #B9D8C5;
}


.alert-danger {

    color:
        var(--hold);

    background:
        #FBEAE7;

    border:
        1px solid
        #E7BDB8;
}


/* =====================================================
   FORM GROUP
   ===================================================== */

.mb-3 {

    margin-bottom:
        22px !important;
}


.form-label {

    color:
        var(--ink);

    font-size:
        14px;

    font-weight:
        600;

    margin-bottom:
        8px;
}


/* =====================================================
   INPUTS
   ===================================================== */

.form-control {

    height:
        50px;

    border:
        1px solid
        #C9D0D2;

    border-radius:
        0;

    background:
        white;

    color:
        var(--ink);

    font-size:
        15px;

    padding:
        0 14px;

    box-shadow:
        none;
}


.form-control::placeholder {

    color:
        #98A2A8;

    font-size:
        14px;
}


.form-control:hover {

    border-color:
        #AAB5B9;
}


.form-control:focus {

    border-color:
        var(--cargo);

    box-shadow:
        0 0 0 2px
        rgba(217,98,43,.12);

    outline:
        none;
}


/* =====================================================
   SIGN IN BUTTON
   ===================================================== */

.login-btn {

    width:
        100%;

    height:
        50px;

    border:
        1px solid
        var(--cargo);

    border-radius:
        0;

    background:
        var(--cargo);

    color:
        white;

    font-family:
        'IBM Plex Sans',
        sans-serif;

    font-size:
        15px;

    font-weight:
        600;

    letter-spacing:
        .1px;

    margin-top:
        2px;
}


.login-btn:hover {

    background:
        #BE4F21;

    border-color:
        #BE4F21;

    color:
        white;
}


/* =====================================================
   FORGOT PASSWORD
   ===================================================== */

.forgot-link {

    display:
        block;

    text-align:
        center;

    margin-top:
        17px;

    color:
        var(--ink-soft);

    font-size:
        14px;

    text-decoration:
        none;
}


.forgot-link:hover {

    color:
        var(--cargo);

    text-decoration:
        underline;
}


/* =====================================================
   REGISTER SECTION
   ===================================================== */

.register-section {

    margin-top:
        32px;

    padding-top:
        24px;

    border-top:
        1px solid
        var(--line);

    text-align:
        center;
}


.register-section p {

    margin:
        0 0 16px;

    color:
        var(--ink-soft);

    font-size:
        14px;

    line-height:
        1.55;
}


.register-btn {

    width:
        100%;

    min-height:
        44px;

    margin-top:
        9px;

    border-radius:
        0;

    border:
        1px solid
        #BFC8CA;

    color:
        var(--ink);

    background:
        white;

    font-size:
        14px;

    font-weight:
        500;
}


.register-btn:hover {

    color:
        var(--cargo);

    border-color:
        var(--cargo);

    background:
        white;
}


/* =====================================================
   RESPONSIVE
   ===================================================== */

@media (max-width: 900px) {

    .login-shell {

        grid-template-columns:
            1fr;

        max-width:
            650px;
    }


    .login-visual {

        min-height:
            400px;

        padding:
            36px;
    }


    .login-visual::before {

        left:
            36px;

        right:
            36px;

        top:
            150px;
    }


    .login-form {

        padding:
            42px 36px;
    }

}


@media (max-width: 600px) {

    .nl-nav {

        padding:
            0 18px;
    }


    .nl-nav-link {

        display:
            none;
    }


    .auth-page {

        padding:
            25px 15px 40px;

        align-items:
            flex-start;
    }


    .login-visual {

        padding:
            30px 24px;

        min-height:
            360px;
    }


    .login-visual h1 {

        font-size:
            36px;
    }


    .login-form {

        padding:
            35px 24px;
    }


    .card-header-custom h2 {

        font-size:
            27px;
    }

}

</style>

</head>


<body>


<!-- =====================================================
     NAVIGATION
     ===================================================== -->

<nav class="nl-nav">

    <div class="nl-nav-inner">


        <!-- BRAND -->

        <a
            class="nl-brand"
            href="${pageContext.request.contextPath}/app?action=home">

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


        <!-- NAV ACTIONS -->

        <div class="nl-nav-action">

            <% if (session.getAttribute("userId") != null) { %>

                <a
                    class="nl-nav-link"
                    href="${pageContext.request.contextPath}/app?action=profile">

                    Profile

                </a>


                <form
                    method="post"
                    action="${pageContext.request.contextPath}/app"
                    class="m-0">

                    <input
                        type="hidden"
                        name="action"
                        value="logout">

                    <input
                        type="hidden"
                        name="_csrf"
                        value="<%=session.getAttribute("csrfToken")%>">

                    <button
                        type="submit"
                        class="nl-nav-login">

                        Logout

                    </button>

                </form>

            <% } else { %>

                <a
                    class="nl-nav-login"
                    href="${pageContext.request.contextPath}/app?action=login">

                    Login

                </a>

            <% } %>

        </div>

    </div>

</nav>



<!-- =====================================================
     MAIN
     ===================================================== -->

<main class="auth-page">


    <section
        class="login-shell"
        aria-label="N Logistics sign in">


        <!-- =================================================
             LEFT PANEL
             ================================================= -->

        <div class="login-visual">


            <!-- BRAND -->

            <div class="login-visual-brand">

                <span class="login-visual-mark">
                    N
                </span>

                <span>

                    N Logistics

                    <br>

                    <small
                        style="
                            font-family:'IBM Plex Sans',sans-serif;
                            font-size:10px;
                            font-weight:500;
                            letter-spacing:1.5px;
                            color:#8FA0AA;
                            text-transform:uppercase;
                        ">

                        Import &amp; Export

                    </small>

                </span>

            </div>



            <!-- COPY -->

            <div class="login-visual-copy">


                <div class="login-visual-kicker">

                    Secure operations platform

                </div>


                <h1>

                    One system.<br>

                    Every movement.

                </h1>


                <p>

                    Centralized access for company
                    administration, operations, finance
                    and customers — built around
                    controlled permissions.

                </p>

            </div>



            <!-- ROUTE -->

            <div class="login-route">

                <span>
                    India
                </span>

                <span class="login-route-line"></span>

                <span>
                    Global
                </span>

            </div>


        </div>



        <!-- =================================================
             RIGHT FORM
             ================================================= -->

        <div class="login-form">


            <div class="login-form-inner">


                <!-- HEADER -->

                <div class="card-header-custom">

                    <h2>
                        Welcome back
                    </h2>

                    <p>

                        Sign in to continue to your
                        N Logistics workspace.

                    </p>

                </div>



                <!-- SUCCESS MESSAGE -->

                <% if (request.getAttribute("message") != null) { %>

                    <div class="alert alert-success">

                        <%= request.getAttribute("message") %>

                    </div>

                <% } %>



                <!-- ERROR MESSAGE -->

                <% if (request.getAttribute("error") != null) { %>

                    <div class="alert alert-danger">

                        <%= request.getAttribute("error") %>

                    </div>

                <% } %>



                <!-- LOGIN FORM -->

                <form
                    method="post"
                    action="${pageContext.request.contextPath}/app"
                    autocomplete="on">


                    <input
                        type="hidden"
                        name="_csrf"
                        value="<%=session.getAttribute("csrfToken")%>">


                    <input
                        type="hidden"
                        name="action"
                        value="login">



                    <!-- USERNAME -->

                    <div class="mb-3">

                        <label
                            class="form-label"
                            for="login">

                            Username / Email

                        </label>

                        <input
                            id="login"
                            class="form-control"
                            name="login"
                            placeholder="Enter your username or email"
                            autocomplete="username"
                            required>

                    </div>



                    <!-- PASSWORD -->

                    <div class="mb-3">

                        <label
                            class="form-label"
                            for="password">

                            Password

                        </label>

                        <input
                            id="password"
                            class="form-control"
                            type="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required>

                    </div>



                    <!-- SIGN IN -->

                    <button
                        class="login-btn"
                        type="submit">

                        Sign in

                    </button>



                    <!-- FORGOT PASSWORD -->

                    <a
                        class="forgot-link"
                        href="${pageContext.request.contextPath}/app?action=forgot-password">

                        Forgot your password?

                    </a>



                    <!-- REGISTER -->

                    <div class="register-section">

                        <p>

                            New to N Logistics?
                            Choose an account type
                            to get started.

                        </p>


                        <a
                            class="btn register-btn"
                            href="${pageContext.request.contextPath}/app?action=register-company">

                            Register a company

                        </a>


                        <a
                            class="btn register-btn"
                            href="${pageContext.request.contextPath}/app?action=register-customer">

                            Register as customer

                        </a>

                    </div>


                </form>


            </div>


        </div>


    </section>


</main>


</body>

</html>