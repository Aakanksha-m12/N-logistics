
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>N Logistics — Dashboard</title>


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
         BOOTSTRAP 5
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         BOOTSTRAP ICONS
         ===================================================== -->

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


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

            --line: #D9DEDC;

            --cargo: #D9622B;

            --cargo-soft: #FBE7DB;

            --cleared: #2F7D53;

            --transit: #A66A1E;

            --hold: #B23A2E;
        }


        /* =====================================================
           GLOBAL RESET
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

            font-size: 14px;
        }


        body {

            overflow-x: hidden;
        }


        h1,
        h2,
        h3,
        h4,
        h5,
        h6 {

            font-family:
                'Archivo',
                sans-serif;
        }


        .mono {

            font-family:
                'IBM Plex Mono',
                monospace;
        }


        a {

            text-decoration: none;
        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .nl-sidebar {

            position: fixed;

            top: 0;

            left: 0;

            bottom: 0;

            width: 252px;

            background: var(--ink);

            border-right:
                1px solid
                #263744;

            z-index: 1000;

            overflow-y: auto;

            display: flex;

            flex-direction: column;
        }


        /* =====================================================
           BRAND
           ===================================================== */

        .nl-brand {

            height: 92px;

            padding:
                0 24px;

            display: flex;

            align-items: center;

            text-decoration: none;

            border-bottom:
                1px solid
                #263744;

            flex-shrink: 0;
        }


        .nl-brand-mark {

            width: 36px;

            height: 36px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                var(--cargo);

            color:
                #FFFFFF;

            font-family:
                'Archivo',
                sans-serif;

            font-size: 16px;

            font-weight: 700;

            margin-right: 11px;
        }


        .nl-brand-name {

            color:
                #FFFFFF;

            font-family:
                'Archivo',
                sans-serif;

            font-size: 15px;

            font-weight: 600;

            letter-spacing:
                .3px;

            line-height:
                1.1;
        }


        .nl-brand-sub {

            color:
                #8B9BA5;

            font-size: 8px;

            font-weight: 600;

            letter-spacing:
                1.5px;

            text-transform:
                uppercase;

            margin-top:
                4px;
        }


        /* =====================================================
           SIDEBAR CONTENT
           ===================================================== */

        .nl-sidebar-content {

            padding:
                25px 0;

            flex: 1;
        }


        .nl-nav-section {

            margin-bottom:
                25px;
        }


        .nl-section-label {

            padding:
                0 24px;

            margin-bottom:
                7px;

            color:
                #7F929E;

            font-family:
                'IBM Plex Sans',
                sans-serif;

            font-size:
                10px;

            font-weight:
                600;

            letter-spacing:
                1px;

            text-transform:
                uppercase;
        }


        .nl-nav-link {

            position:
                relative;

            display:
                flex;

            align-items:
                center;

            min-height:
                43px;

            padding:
                0 24px;

            color:
                #D5DEE2;

            text-decoration:
                none;

            font-size:
                13px;

            font-weight:
                500;

            transition:
                background .15s ease,
                color .15s ease;
        }


        .nl-nav-link i {

            width:
                27px;

            margin-right:
                6px;

            color:
                #8EA1AA;

            font-size:
                14px;
        }


        .nl-nav-link:hover {

            background:
                #172E3D;

            color:
                #FFFFFF;
        }


        .nl-nav-link:hover i {

            color:
                var(--cargo);
        }


        .nl-nav-link.active {

            background:
                #193346;

            color:
                #FFFFFF;

            font-weight:
                600;
        }


        .nl-nav-link.active::before {

            content:
                "";

            position:
                absolute;

            left:
                0;

            top:
                0;

            bottom:
                0;

            width:
                3px;

            background:
                var(--cargo);
        }


        .nl-nav-link.active i {

            color:
                var(--cargo);
        }


        /* =====================================================
           SIDEBAR FOOTER
           ===================================================== */

        .nl-sidebar-footer {

            padding:
                17px 18px 20px;

            border-top:
                1px solid
                #263744;

            flex-shrink: 0;
        }


        .nl-sidebar-user-label {

            color:
                #7F929E;

            font-size:
                9px;

            font-weight:
                600;

            letter-spacing:
                1px;

            text-transform:
                uppercase;

            margin-bottom:
                5px;
        }


        .nl-sidebar-user-role {

            color:
                #FFFFFF;

            font-size:
                11px;

            font-weight:
                600;

            margin-bottom:
                13px;

            word-break:
                break-word;
        }


        /* =====================================================
           LOGOUT BUTTON
           ===================================================== */

        .nl-logout-form {

            margin:
                0;
        }


        .nl-logout-btn {

            width:
                100%;

            min-height:
                40px;

            display:
                flex;

            align-items:
                center;

            justify-content:
                flex-start;

            gap:
                9px;

            padding:
                0 13px;

            background:
                transparent;

            border:
                1px solid
                #40515D;

            color:
                #D5DEE2;

            font-family:
                'IBM Plex Sans',
                sans-serif;

            font-size:
                12px;

            font-weight:
                600;

            cursor:
                pointer;

            transition:
                background .15s ease,
                border-color .15s ease,
                color .15s ease;
        }


        .nl-logout-btn i {

            font-size:
                14px;

            color:
                #D5DEE2;
        }


        .nl-logout-btn:hover {

            background:
                var(--cargo);

            border-color:
                var(--cargo);

            color:
                #FFFFFF;
        }


        .nl-logout-btn:hover i {

            color:
                #FFFFFF;
        }


        /* =====================================================
           MAIN AREA
           ===================================================== */

        .nl-main {

            margin-left:
                252px;

            min-height:
                100vh;

            width:
                calc(100% - 252px);
        }


        /* =====================================================
           TOPBAR
           ===================================================== */

        .nl-topbar {

            height:
                70px;

            width:
                100%;

            background:
                var(--surface);

            border-bottom:
                1px solid
                var(--line);

            padding:
                0 30px;

            display:
                flex;

            align-items:
                center;

            justify-content:
                space-between;
        }


        /* =====================================================
           BREADCRUMB
           ===================================================== */

        .nl-breadcrumb {

            margin:
                0;

            --bs-breadcrumb-divider:
                "/";
        }


        .nl-breadcrumb .breadcrumb-item {

            font-size:
                12px;
        }


        .nl-breadcrumb a {

            color:
                var(--ink-soft);

            text-decoration:
                none;
        }


        .nl-breadcrumb a:hover {

            color:
                var(--cargo);
        }


        .nl-breadcrumb .active {

            color:
                var(--ink);

            font-weight:
                600;
        }


        /* =====================================================
           USER
           ===================================================== */

        .nl-user {

            display:
                flex;

            align-items:
                center;

            gap:
                11px;
        }


        .nl-user-info {

            text-align:
                right;
        }


        .nl-user-name {

            color:
                var(--ink);

            font-size:
                12px;

            font-weight:
                600;
        }


        .nl-user-role {

            color:
                var(--ink-faint);

            font-size:
                10px;

            margin-top:
                2px;
        }


        .nl-avatar {

            width:
                36px;

            height:
                36px;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            background:
                var(--cargo-soft);

            color:
                var(--cargo);

            font-family:
                'Archivo',
                sans-serif;

            font-size:
                12px;

            font-weight:
                700;
        }


        /* =====================================================
           MAIN PAGE
           ===================================================== */

        .nl-page {

            width:
                100%;

            padding:
                28px 30px 40px;
        }


        /* =====================================================
           PAGE HEADER
           ===================================================== */

        .nl-page-header {

            width:
                100%;

            display:
                flex;

            align-items:
                flex-end;

            justify-content:
                space-between;

            gap:
                25px;

            margin-bottom:
                20px;
        }


        .nl-eyebrow {

            color:
                var(--cargo);

            font-family:
                'IBM Plex Sans',
                sans-serif;

            font-size:
                10px;

            font-weight:
                600;

            letter-spacing:
                1.2px;

            text-transform:
                uppercase;

            margin-bottom:
                6px;
        }


        .nl-page-title {

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
                -.5px;

            line-height:
                1.1;
        }


        .nl-page-description {

            margin:
                6px 0 0;

            color:
                var(--ink-soft);

            font-size:
                13px;

            line-height:
                1.5;
        }


        /* =====================================================
           ROLE STAMP
           ===================================================== */

        .nl-role-stamp {

            display:
                inline-flex;

            align-items:
                center;

            gap:
                7px;

            padding:
                6px 10px;

            border:
                1px solid
                var(--cargo);

            color:
                var(--cargo);

            font-family:
                'Archivo',
                sans-serif;

            font-size:
                9px;

            font-weight:
                600;

            letter-spacing:
                .6px;

            text-transform:
                uppercase;

            white-space:
                nowrap;
        }


        .nl-role-square {

            width:
                6px;

            height:
                6px;

            background:
                currentColor;
        }


        /* =====================================================
           BACK BUTTON
           ===================================================== */

        .nl-back-btn {

            display:
                inline-flex;

            align-items:
                center;

            gap:
                7px;

            margin-top:
                12px;

            padding:
                8px 13px;

            border:
                1px solid
                var(--line);

            background:
                var(--surface);

            color:
                var(--ink);

            font-size:
                11px;

            font-weight:
                600;

            text-decoration:
                none;

            transition:
                border-color .15s ease,
                color .15s ease,
                background .15s ease;
        }


        .nl-back-btn:hover {

            border-color:
                var(--cargo);

            color:
                var(--cargo);

            background:
                #FFFDFC;
        }


        /* =====================================================
           WORKSPACE
           ===================================================== */

        .nl-workspace {

            width:
                100%;

            background:
                var(--surface);

            border:
                1px solid
                var(--line);
        }


        /* =====================================================
           WORKSPACE HEADER
           ===================================================== */

        .nl-workspace-header {

            padding:
                17px 21px;

            border-bottom:
                1px solid
                var(--line);

            display:
                flex;

            align-items:
                center;

            justify-content:
                space-between;
        }


        .nl-workspace-title {

            margin:
                0;

            font-family:
                'Archivo',
                sans-serif;

            font-size:
                17px;

            font-weight:
                600;

            color:
                var(--ink);
        }


        .nl-workspace-subtitle {

            margin-top:
                3px;

            color:
                var(--ink-faint);

            font-size:
                11px;
        }


        /* =====================================================
           ACTION GRID
           ===================================================== */

        .nl-action-grid {

            padding:
                20px;

            display:
                grid;

            grid-template-columns:
                repeat(3, minmax(0, 1fr));

            gap:
                14px;
        }


        /* =====================================================
           ACTION CARD
           ===================================================== */

        .nl-action-card {

            position:
                relative;

            min-height:
                145px;

            display:
                flex;

            flex-direction:
                column;

            padding:
                17px;

            background:
                var(--surface);

            border:
                1px solid
                var(--line);

            color:
                var(--ink);

            text-decoration:
                none;

            transition:
                border-color .15s ease,
                background .15s ease;
        }


        .nl-action-card:hover {

            border-color:
                #BBC5C4;

            background:
                #FCFDFC;

            color:
                var(--ink);
        }


        /* =====================================================
           ACTION ICON
           ===================================================== */

        .nl-action-icon {

            width:
                36px;

            height:
                36px;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            margin-bottom:
                15px;

            font-size:
                15px;
        }


        .nl-action-icon.orange {

            background:
                var(--cargo-soft);

            color:
                var(--cargo);
        }


        .nl-action-icon.aqua {

            background:
                #E3EFF0;

            color:
                #407E8C;
        }


        .nl-action-icon.gold {

            background:
                #F4EDDF;

            color:
                #98753D;
        }


        .nl-action-icon.green {

            background:
                #E4F2E9;

            color:
                var(--cleared);
        }


        /* =====================================================
           ACTION LABEL
           ===================================================== */

        .nl-action-label {

            color:
                var(--ink-faint);

            font-size:
                9px;

            font-weight:
                600;

            letter-spacing:
                .8px;

            text-transform:
                uppercase;

            margin-bottom:
                5px;
        }


        /* =====================================================
           ACTION TITLE
           ===================================================== */

        .nl-action-title {

            color:
                var(--ink);

            font-family:
                'Archivo',
                sans-serif;

            font-size:
                15px;

            font-weight:
                600;

            line-height:
                1.25;

            margin-bottom:
                5px;
        }


        /* =====================================================
           ACTION COPY
           ===================================================== */

        .nl-action-copy {

            color:
                var(--ink-soft);

            font-size:
                11px;

            line-height:
                1.5;

            padding-right:
                20px;
        }


        /* =====================================================
           ARROW
           ===================================================== */

        .nl-action-arrow {

            position:
                absolute;

            right:
                16px;

            bottom:
                16px;

            color:
                var(--ink-faint);

            font-size:
                13px;

            transition:
                color .15s ease,
                transform .15s ease;
        }


        .nl-action-card:hover
        .nl-action-arrow {

            color:
                var(--cargo);

            transform:
                translateX(3px);
        }


        /* =====================================================
           WORKSPACE FOOTER
           ===================================================== */

        .nl-workspace-footer {

            padding:
                12px 21px;

            border-top:
                1px solid
                var(--line);

            background:
                #FAFBFA;

            color:
                var(--ink-faint);

            font-family:
                'IBM Plex Mono',
                monospace;

            font-size:
                9px;
        }


        .nl-workspace-footer i {

            color:
                var(--cargo);

            margin-right:
                6px;
        }


        /* =====================================================
           LOGGED OUT
           ===================================================== */

        .nl-login-container {

            width:
                100%;

            margin:
                0;
        }


        .nl-login-card {

            width:
                100%;

            background:
                var(--surface);

            border:
                1px solid
                var(--line);

            padding:
                24px 26px;
        }


        .nl-login-grid {

            display:
                grid;

            grid-template-columns:
                repeat(3, minmax(0, 1fr));

            gap:
                14px;

            margin-top:
                20px;
        }


        .nl-login-option {

            display:
                block;

            padding:
                17px;

            border:
                1px solid
                var(--line);

            background:
                var(--surface);

            color:
                var(--ink);

            text-decoration:
                none;

            transition:
                border-color .15s ease,
                background .15s ease;
        }


        .nl-login-option:hover {

            border-color:
                var(--cargo);

            background:
                #FFFDFC;

            color:
                var(--ink);
        }


        .nl-login-option-label {

            color:
                var(--cargo);

            font-size:
                9px;

            font-weight:
                700;

            letter-spacing:
                .9px;

            text-transform:
                uppercase;
        }


        .nl-login-option-title {

            margin-top:
                6px;

            font-family:
                'Archivo',
                sans-serif;

            font-size:
                14px;

            font-weight:
                600;
        }


        .nl-login-option-copy {

            display:
                block;

            margin-top:
                5px;

            color:
                var(--ink-soft);

            font-size:
                11px;

            line-height:
                1.5;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 1100px) {

            .nl-action-grid {

                grid-template-columns:
                    repeat(2, minmax(0, 1fr));
            }


            .nl-login-grid {

                grid-template-columns:
                    repeat(2, minmax(0, 1fr));
            }

        }


        @media (max-width: 800px) {

            .nl-sidebar {

                width:
                    215px;
            }


            .nl-main {

                margin-left:
                    215px;

                width:
                    calc(100% - 215px);
            }


            .nl-topbar {

                padding:
                    0 20px;
            }


            .nl-page {

                padding:
                    24px 20px 35px;
            }


            .nl-page-header {

                align-items:
                    flex-start;

                flex-direction:
                    column;
            }


            .nl-login-grid {

                grid-template-columns:
                    repeat(1, minmax(0, 1fr));
            }

        }


        @media (max-width: 620px) {

            .nl-sidebar {

                position:
                    relative;

                width:
                    100%;

                height:
                    auto;
            }


            .nl-main {

                margin-left:
                    0;

                width:
                    100%;
            }


            .nl-action-grid {

                grid-template-columns:
                    1fr;
            }


            .nl-user-info {

                display:
                    none;
            }


            .nl-topbar {

                height:
                    64px;
            }

        }

    </style>

</head>


<body>


<!-- =========================================================
     SIDEBAR
     ========================================================= -->

<aside class="nl-sidebar">


    <!-- =====================================================
         BRAND
         ===================================================== -->

    <a
        href="${pageContext.request.contextPath}/app?action=home"
        class="nl-brand">

        <span class="nl-brand-mark">
            N
        </span>

        <span>

            <span class="nl-brand-name d-block">
                N LOGISTICS
            </span>

            <span class="nl-brand-sub d-block">
                Import &amp; Export
            </span>

        </span>

    </a>



    <!-- =====================================================
         SIDEBAR CONTENT
         ===================================================== -->

    <div class="nl-sidebar-content">


        <!-- =================================================
             MAIN
             ================================================= -->

        <div class="nl-nav-section">

            <div class="nl-section-label">
                Main
            </div>


            <a
                href="${pageContext.request.contextPath}/app?action=home"
                class="nl-nav-link active">

                <i class="bi bi-grid-1x2"></i>

                Dashboard

            </a>

        </div>



        <!-- =================================================
             ADMINISTRATION
             ================================================= -->

        <% if ("Company Admin".equals(session.getAttribute("roleName"))
                || "Super Admin".equals(session.getAttribute("roleName"))) { %>


        <div class="nl-nav-section">

            <div class="nl-section-label">
                Administration
            </div>


            <a
                href="${pageContext.request.contextPath}/app?action=company-users"
                class="nl-nav-link">

                <i class="bi bi-people"></i>

                Company Users

            </a>

        </div>


        <% } %>



        <!-- =================================================
             GOVERNANCE
             ================================================= -->

        <% if ("Super Admin".equals(session.getAttribute("roleName"))) { %>


        <div class="nl-nav-section">

            <div class="nl-section-label">
                Governance
            </div>


            <a
                href="${pageContext.request.contextPath}/app?action=pending-companies"
                class="nl-nav-link">

                <i class="bi bi-building-check"></i>

                Company Management

            </a>

        </div>


        <% } %>



        <!-- =================================================
             SECURITY
             ================================================= -->

        <% if ("Super Admin".equals(session.getAttribute("roleName"))) { %>


        <div class="nl-nav-section">

            <div class="nl-section-label">
                Security
            </div>


            <a
                href="${pageContext.request.contextPath}/app?action=audit"
                class="nl-nav-link">

                <i class="bi bi-shield-check"></i>

                Audit Log

            </a>

        </div>


        <% } %>



        <!-- =================================================
             OPERATIONS
             ================================================= -->

        <% if (session.getAttribute("userId") != null) { %>


        <div class="nl-nav-section">

            <div class="nl-section-label">
                Operations
            </div>


            <a
                href="${pageContext.request.contextPath}/app?action=module3"
                class="nl-nav-link">

                <i class="bi bi-box-seam"></i>

                Module 3

            </a>

        </div>


        <% } %>


    </div>



    <!-- =====================================================
         SIDEBAR FOOTER
         LOGOUT
         ===================================================== -->

    <div class="nl-sidebar-footer">


        <div class="nl-sidebar-user-label">

            Signed in as

        </div>


        <div class="nl-sidebar-user-role">

            <%= session.getAttribute("roleName") %>

        </div>


        <!-- =================================================
             LOGOUT BUTTON
             ================================================= -->

        <form
            method="get"
            action="<%= request.getContextPath() %>/app"
            class="nl-logout-form">

            <input
                type="hidden"
                name="action"
                value="logout">


            <button
                type="submit"
                class="nl-logout-btn">

                <i class="bi bi-box-arrow-right"></i>

                Logout

            </button>

        </form>


    </div>

</aside>



<!-- =========================================================
     MAIN AREA
     ========================================================= -->

<div class="nl-main">


    <!-- =====================================================
         TOPBAR
         ===================================================== -->

    <header class="nl-topbar">


        <!-- BREADCRUMB -->

        <nav aria-label="breadcrumb">

            <ol class="breadcrumb nl-breadcrumb">

                <li class="breadcrumb-item">

                    <a
                        href="${pageContext.request.contextPath}/app?action=home">

                        N Logistics

                    </a>

                </li>

                <li
                    class="breadcrumb-item active"
                    aria-current="page">

                    Dashboard

                </li>

            </ol>

        </nav>



        <!-- USER -->

        <div class="nl-user">


            <% if (session.getAttribute("userId") != null) { %>


            <div class="nl-user-info">

                <div class="nl-user-name">

                    <%= session.getAttribute("username") %>

                </div>

                <div class="nl-user-role">

                    <%= session.getAttribute("roleName") %>

                </div>

            </div>


            <%
                String username =
                    (String) session.getAttribute("username");

                String initial = "N";

                if (username != null
                        && !username.trim().isEmpty()) {

                    initial =
                        username.substring(0, 1)
                                .toUpperCase();
                }
            %>


            <div class="nl-avatar">

                <%= initial %>

            </div>


            <% } %>


        </div>

    </header>



    <!-- =====================================================
         PAGE
         ===================================================== -->

    <main class="nl-page">


        <% if (session.getAttribute("userId") != null) { %>


        <!-- =================================================
             PAGE HEADER
             ================================================= -->

        <div class="nl-page-header">


            <div>

                <div class="nl-eyebrow">

                    Operations Platform

                </div>


                <h1 class="nl-page-title">

                    Dashboard

                </h1>


                <p class="nl-page-description">

                    Manage your N Logistics workspace
                    according to your assigned access level.

                </p>


                <!-- BACK BUTTON -->

                <a
                    href="${pageContext.request.contextPath}/app?action=home"
                    class="nl-back-btn">

                    <i class="bi bi-arrow-left"></i>

                    Back to Dashboard

                </a>

            </div>


            <div class="nl-role-stamp">

                <span class="nl-role-square"></span>

                <%= session.getAttribute("roleName") %>

            </div>


        </div>



        <!-- =================================================
             WORKSPACE
             ================================================= -->

        <section class="nl-workspace">


            <!-- WORKSPACE HEADER -->

            <div class="nl-workspace-header">

                <div>

                    <h2 class="nl-workspace-title">

                        Workspace

                    </h2>

                    <div class="nl-workspace-subtitle">

                        Select an area to continue.

                    </div>

                </div>

            </div>



            <!-- =================================================
                 ACTION CARDS
                 ================================================= -->

            <div class="nl-action-grid">


                <!-- PROFILE -->

                <a
                    href="${pageContext.request.contextPath}/app?action=profile"
                    class="nl-action-card">


                    <div class="nl-action-icon aqua">

                        <i class="bi bi-person"></i>

                    </div>


                    <div class="nl-action-label">

                        Account

                    </div>


                    <div class="nl-action-title">

                        My Profile

                    </div>


                    <div class="nl-action-copy">

                        Review your account details
                        and update your contact information.

                    </div>


                    <i class="bi bi-arrow-right nl-action-arrow"></i>


                </a>



                <!-- COMPANY USERS -->

                <% if ("Company Admin".equals(session.getAttribute("roleName"))
                        || "Super Admin".equals(session.getAttribute("roleName"))) { %>


                <a
                    href="${pageContext.request.contextPath}/app?action=company-users"
                    class="nl-action-card">


                    <div class="nl-action-icon aqua">

                        <i class="bi bi-people"></i>

                    </div>


                    <div class="nl-action-label">

                        Administration

                    </div>


                    <div class="nl-action-title">

                        Company Users

                    </div>


                    <div class="nl-action-copy">

                        Review users and their assigned
                        roles within the company.

                    </div>


                    <i class="bi bi-arrow-right nl-action-arrow"></i>


                </a>


                <% } %>



                <!-- COMPANY MANAGEMENT -->

                <% if ("Super Admin".equals(session.getAttribute("roleName"))) { %>


                <a
                    href="${pageContext.request.contextPath}/app?action=pending-companies"
                    class="nl-action-card">


                    <div class="nl-action-icon gold">

                        <i class="bi bi-building-check"></i>

                    </div>


                    <div class="nl-action-label">

                        Governance

                    </div>


                    <div class="nl-action-title">

                        Company Management

                    </div>


                    <div class="nl-action-copy">

                        Review company registration
                        and approval activities.

                    </div>


                    <i class="bi bi-arrow-right nl-action-arrow"></i>


                </a>


                <% } %>



                <!-- AUDIT -->

                <% if ("Super Admin".equals(session.getAttribute("roleName"))) { %>


                <a
                    href="${pageContext.request.contextPath}/app?action=audit"
                    class="nl-action-card">


                    <div class="nl-action-icon green">

                        <i class="bi bi-shield-check"></i>

                    </div>


                    <div class="nl-action-label">

                        Security

                    </div>


                    <div class="nl-action-title">

                        Audit Log

                    </div>


                    <div class="nl-action-copy">

                        Review recorded authentication
                        and administrative events.

                    </div>


                    <i class="bi bi-arrow-right nl-action-arrow"></i>


                </a>


                <% } %>



                <!-- MODULE 3 -->

                <a
                    href="${pageContext.request.contextPath}/app?action=module3"
                    class="nl-action-card">


                    <div class="nl-action-icon orange">

                        <i class="bi bi-box-seam"></i>

                    </div>


                    <div class="nl-action-label">

                        Operations

                    </div>


                    <div class="nl-action-title">

                        Container Allocation &amp; Pricing

                    </div>


                    <div class="nl-action-copy">

                        Access Module 3 container,
                        allocation, pricing and forecasting
                        features available to your role.

                    </div>


                    <i class="bi bi-arrow-right nl-action-arrow"></i>


                </a>


            </div>



            <!-- =================================================
                 FOOTER
                 ================================================= -->

            <div class="nl-workspace-footer">

                <i class="bi bi-shield-check"></i>

                Access is controlled according to your
                assigned role.

            </div>


        </section>


        <% } else { %>



        <!-- =================================================
             LOGGED OUT
             ================================================= -->

        <div class="nl-page-header">

            <div>

                <div class="nl-eyebrow">

                    N Logistics

                </div>


                <h1 class="nl-page-title">

                    Welcome

                </h1>


                <p class="nl-page-description">

                    Secure access to the N Logistics
                    Import &amp; Export platform.

                </p>

            </div>

        </div>


        <div class="nl-login-container">


            <div class="nl-login-card">


                <h2 class="nl-workspace-title">

                    Access your workspace

                </h2>


                <div class="nl-workspace-subtitle">

                    Sign in or create an account to continue.

                </div>


                <div class="nl-login-grid">


                    <!-- SIGN IN -->

                    <a
                        href="${pageContext.request.contextPath}/app?action=login"
                        class="nl-login-option">

                        <div class="nl-login-option-label">

                            Existing User

                        </div>

                        <div class="nl-login-option-title">

                            Sign In

                        </div>

                        <span class="nl-login-option-copy">

                            Access your N Logistics workspace.

                        </span>

                    </a>



                    <!-- REGISTER COMPANY -->

                    <a
                        href="${pageContext.request.contextPath}/app?action=register-company"
                        class="nl-login-option">

                        <div class="nl-login-option-label">

                            Business

                        </div>

                        <div class="nl-login-option-title">

                            Register a Company

                        </div>

                        <span class="nl-login-option-copy">

                            Submit company details
                            for approval.

                        </span>

                    </a>



                    <!-- REGISTER CUSTOMER -->

                    <a
                        href="${pageContext.request.contextPath}/app?action=register-customer"
                        class="nl-login-option">

                        <div class="nl-login-option-label">

                            Customer

                        </div>

                        <div class="nl-login-option-title">

                            Register as Customer

                        </div>

                        <span class="nl-login-option-copy">

                            Create a customer /
                            consumer account.

                        </span>

                    </a>


                </div>


            </div>

        </div>


        <% } %>


    </main>


</div>



<!-- =========================================================
     BOOTSTRAP JAVASCRIPT
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>

