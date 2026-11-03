<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>N Logistics - No Allocated Container</title>

    <!-- Bootstrap 5.3.3 -->

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
            --border: #DFE3E2;
            --sidebar: #10202F;
            --sidebar-hover: #1B3041;
            --soft-cargo: #FBE7DB;

        }


        * {
            box-sizing: border-box;
        }


        body {

            margin: 0;

            background: var(--paper);

            color: var(--ink);

            font-family:
                Arial,
                Helvetica,
                sans-serif;

        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .nl-sidebar {

            position: fixed;

            top: 0;
            left: 0;
            bottom: 0;

            width: 245px;

            background: var(--sidebar);

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 1000;

        }


        /* =====================================================
           BRAND
           ===================================================== */

        .sidebar-brand {

            padding:
                24px 20px 22px;

            border-bottom:
                1px solid rgba(255,255,255,0.10);

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

            width: 36px;
            height: 36px;

            margin-right: 10px;

            display: inline-flex;

            align-items: center;
            justify-content: center;

            background: var(--orange);

            border-radius: 7px;

            font-weight: 800;

        }


        .nl-subtitle {

            color: #AEBAC3;

            font-size: 10px;

            margin-left: 46px;

            margin-top: 5px;

        }


        /* =====================================================
           SIDEBAR MENU
           ===================================================== */

        .sidebar-menu {

            padding:
                22px 12px;

            flex-grow: 1;

        }


        .sidebar-section {

            color: #71818D;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.2px;

            padding:
                0 12px 9px;

        }


        .sidebar-link {

            display: flex;

            align-items: center;

            color: #D7DEE3;

            text-decoration: none;

            padding:
                11px 12px;

            margin-bottom: 4px;

            font-size: 13px;

            font-weight: 600;

            border-radius: 5px;

        }


        .sidebar-link:hover {

            background:
                var(--sidebar-hover);

            color: white;

        }


        .sidebar-link.active {

            background:
                var(--orange);

            color: white;

        }


        .sidebar-icon {

            width: 27px;

            margin-right: 7px;

            text-align: center;

            font-size: 14px;

        }


        /* =====================================================
           SIDEBAR BOTTOM
           ===================================================== */

        .sidebar-bottom {

            padding:
                15px 12px 18px;

            border-top:
                1px solid rgba(255,255,255,0.10);

        }


        .sidebar-role-label {

            color: #71818D;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            padding:
                0 12px 7px;

        }


        .sidebar-role {

            color: white;

            font-size: 12px;

            font-weight: 700;

            padding:
                0 12px 15px;

        }


        /* =====================================================
           LOGOUT
           ===================================================== */

        .logout-btn {

            width: 100%;

            background: transparent;

            color: #D7DEE3;

            border:
                1px solid #40515D;

            border-radius: 5px;

            padding:
                10px 12px;

            font-size: 12px;

            font-weight: 700;

            text-align: left;

            cursor: pointer;

        }


        .logout-btn:hover {

            background:
                #253946;

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

            height: 72px;

            background:
                var(--surface);

            border-bottom:
                1px solid var(--border);

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding:
                0 30px;

        }


        .topbar-title {

            font-size: 14px;

            font-weight: 700;

        }


        .topbar-status {

            color: var(--ink-soft);

            font-size: 12px;

        }


        /* =====================================================
           CONTENT
           ===================================================== */

        .nl-content {

            min-height:
                calc(100vh - 72px);

            display: flex;

            align-items: center;

            justify-content: center;

            padding:
                45px 30px;

        }


        /* =====================================================
           EMPTY CARD
           ===================================================== */

        .empty-card {

            width: 100%;

            max-width: 650px;

            background:
                var(--surface);

            border:
                1px solid var(--border);

            border-radius: 8px;

            padding:
                48px 42px;

            text-align: center;

            box-shadow:
                0 5px 20px
                rgba(16, 32, 47, 0.05);

        }


        /* =====================================================
           ICON
           ===================================================== */

        .empty-icon {

            width: 76px;

            height: 76px;

            margin:
                0 auto 23px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                var(--soft-cargo);

            border-radius: 50%;

            font-size: 34px;

        }


        /* =====================================================
           TITLE
           ===================================================== */

        .empty-title {

            margin:
                0 0 12px;

            font-size: 27px;

            font-weight: 750;

            color: var(--ink);

        }


        /* =====================================================
           DESCRIPTION
           ===================================================== */

        .empty-description {

            margin:
                0 auto 24px;

            max-width: 470px;

            color: var(--ink-soft);

            font-size: 14px;

            line-height: 1.6;

        }


        /* =====================================================
           MESSAGE
           ===================================================== */

        .message-box {

            padding:
                17px 20px;

            margin-bottom: 27px;

            background:
                #F7F8F8;

            border:
                1px solid var(--border);

            border-left:
                4px solid var(--orange);

            color: var(--ink);

            font-size: 14px;

            font-weight: 700;

        }


        /* =====================================================
           BACK BUTTON
           ===================================================== */

        .back-button {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            padding:
                10px 18px;

            background:
                var(--orange);

            border:
                1px solid var(--orange);

            border-radius: 5px;

            color: white;

            text-decoration: none;

            font-size: 12px;

            font-weight: 700;

        }


        .back-button:hover {

            background:
                #BC4F20;

            border-color:
                #BC4F20;

            color: white;

        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 750px) {

            .nl-sidebar {

                position: relative;

                width: 100%;

            }


            .nl-main {

                margin-left: 0;

            }


            .nl-topbar {

                padding:
                    0 18px;

            }


            .nl-content {

                min-height:
                    calc(100vh - 72px);

                padding:
                    30px 18px;

            }


            .empty-card {

                padding:
                    38px 25px;

            }

        }


        @media (max-width: 500px) {

            .nl-topbar {

                height: 62px;

            }


            .topbar-status {

                display: none;

            }


            .empty-title {

                font-size: 23px;

            }

        }

    </style>

</head>


<body>


<!-- ============================================================
     SIDE NAVBAR
     ============================================================ -->

<aside class="nl-sidebar">


    <!-- BRAND -->

    <div class="sidebar-brand">

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

    <div class="sidebar-menu">


        <div class="sidebar-section">
            Workspace
        </div>


        <!-- DASHBOARD -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">
                ▦
            </span>

            Dashboard

        </a>


        <!-- CONTAINERS -->

        <a
            class="sidebar-link active"
            href="<%= request.getContextPath() %>/containers?action=view">

            <span class="sidebar-icon">
                ▣
            </span>

            Containers

        </a>


        <!-- ALLOCATION -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/allocation?action=view">

            <span class="sidebar-icon">
                ⇄
            </span>

            Allocation

        </a>


        <!-- PRICING -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing?action=view">

            <span class="sidebar-icon">
                ₹
            </span>

            Pricing

        </a>


        <!-- DEMAND FORECAST -->

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/forecast?action=view">

            <span class="sidebar-icon">
                ↗
            </span>

            Demand Forecast

        </a>

    </div>


    <!-- SIDEBAR BOTTOM -->

    <div class="sidebar-bottom">


        <div class="sidebar-role-label">

            Signed in

        </div>


        <div class="sidebar-role">

            N Logistics User

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


<!-- ============================================================
     MAIN
     ============================================================ -->

<div class="nl-main">


    <!-- TOP BAR -->

    <header class="nl-topbar">

        <div class="topbar-title">

            Container Services

        </div>


        <div class="topbar-status">

            N Logistics

        </div>

    </header>


    <!-- CONTENT -->

    <main class="nl-content">


        <div class="empty-card">


            <!-- ICON -->

            <div class="empty-icon">

                📦

            </div>


            <!-- TITLE -->

            <h1 class="empty-title">

                No Allocated Container

            </h1>


            <!-- DESCRIPTION -->

            <p class="empty-description">

                Your account currently does not have
                an allocated container.

            </p>


            <!-- MESSAGE -->

            <div class="message-box">

                No allocated container to you.

            </div>


            <!-- BACK BUTTON -->

            <a
                class="back-button"
                href="<%= request.getContextPath() %>/app?action=home">

                ← &nbsp; Back to Dashboard

            </a>


        </div>


    </main>


</div>


<!-- Bootstrap JavaScript -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>