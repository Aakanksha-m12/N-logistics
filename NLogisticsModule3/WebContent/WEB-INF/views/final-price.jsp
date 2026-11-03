<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    Object finalPrice =
            request.getAttribute("finalPrice");

    String role =
            (String) request.getAttribute("role");

    if (role == null) {
        role = (String) session.getAttribute("roleName");
    }

    if (finalPrice == null) {
        finalPrice = "—";
    }
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>N Logistics · Final Price</title>

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
    --orange-soft: #FBE7DB;
    --border: #DFE3E2;
    --sidebar: #10202F;
    --sidebar-hover: #1B3041;
}

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: var(--paper);
    color: var(--ink);
    font-family: Arial, Helvetica, sans-serif;
}

.nl-sidebar {
    position: fixed;
    inset: 0 auto 0 0;
    width: 245px;
    background: var(--sidebar);
    color: white;
    display: flex;
    flex-direction: column;
    z-index: 1000;
}

.sidebar-brand {
    padding: 24px 20px 22px;
    border-bottom: 1px solid rgba(255,255,255,0.10);
}

.nl-brand {
    color: white;
    font-size: 20px;
    font-weight: 700;
    text-decoration: none;
    display: flex;
    align-items: center;
}

.nl-mark {
    width: 36px;
    height: 36px;
    margin-right: 10px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: var(--orange);
    font-weight: 800;
}

.nl-subtitle {
    color: #AEBAC3;
    font-size: 10px;
    margin: 6px 0 0 46px;
}

.sidebar-menu {
    padding: 22px 12px;
    flex-grow: 1;
}

.sidebar-label {
    color: #71818D;
    font-size: 10px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    padding: 0 12px 9px;
}

.sidebar-link {
    display: flex;
    align-items: center;
    color: #D7DEE3;
    text-decoration: none;
    padding: 11px 12px;
    margin-bottom: 4px;
    font-size: 13px;
    font-weight: 600;
    border-left: 3px solid transparent;
}

.sidebar-link:hover {
    background: var(--sidebar-hover);
    color: white;
}

.sidebar-icon {
    width: 27px;
    margin-right: 7px;
    text-align: center;
}

.sidebar-bottom {
    padding: 16px 12px 18px;
    border-top: 1px solid rgba(255,255,255,0.10);
}

.sidebar-role {
    color: #AEBAC3;
    font-size: 10px;
    text-transform: uppercase;
    padding: 0 12px 7px;
}

.sidebar-role-value {
    color: white;
    font-size: 12px;
    font-weight: 700;
    padding: 0 12px 15px;
}

.logout-btn {
    width: 100%;
    background: transparent;
    color: #D7DEE3;
    border: 1px solid #40515D;
    padding: 10px 12px;
    font-size: 12px;
    font-weight: 700;
}

.logout-btn:hover {
    background: var(--orange);
    border-color: var(--orange);
    color: white;
}

.nl-main {
    margin-left: 245px;
    min-height: 100vh;
}

.nl-topbar {
    height: 68px;
    background: white;
    border-bottom: 1px solid var(--border);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 30px;
}

.topbar-title {
    color: var(--ink-soft);
    font-size: 12px;
    font-weight: 700;
}

.nl-role {
    border: 1px solid var(--border);
    padding: 7px 11px;
    color: var(--ink-soft);
    font-size: 11px;
    font-weight: 700;
}

.nl-content {
    max-width: 1000px;
    margin: 0 auto;
    padding: 42px 24px 60px;
}

.page-kicker {
    color: var(--orange);
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 1.4px;
}

.page-title {
    margin: 7px 0 8px;
    font-size: 32px;
    font-weight: 800;
}

.page-description {
    color: var(--ink-soft);
    line-height: 1.6;
}

.nl-panel {
    margin-top: 28px;
    background: var(--surface);
    border: 1px solid var(--border);
}

.panel-header {
    padding: 20px 22px;
    border-bottom: 1px solid var(--border);
}

.panel-title {
    font-size: 18px;
    font-weight: 800;
}

.price-box {
    padding: 55px 25px;
    text-align: center;
}

.price-label {
    color: var(--ink-soft);
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.price-value {
    margin-top: 12px;
    color: var(--orange);
    font-size: 42px;
    font-weight: 900;
}

.price-note {
    margin: 10px auto 25px;
    color: var(--ink-soft);
    font-size: 12px;
    max-width: 520px;
}

.action-bar {
    display: flex;
    gap: 10px;
    justify-content: center;
    padding: 20px;
    border-top: 1px solid var(--border);
}

.btn-nl {
    background: var(--orange);
    color: white;
    border: 1px solid var(--orange);
    padding: 10px 18px;
    text-decoration: none;
    font-size: 12px;
    font-weight: 800;
}

@media (max-width: 850px) {
    .nl-sidebar {
        position: relative;
        width: 100%;
        min-height: auto;
    }

    .nl-main {
        margin-left: 0;
    }

    .nl-topbar {
        padding: 0 18px;
    }
}

</style>

</head>

<body>

<aside class="nl-sidebar">

    <div class="sidebar-brand">

        <a
            class="nl-brand"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="nl-mark">N</span>
            Logistics

        </a>

        <div class="nl-subtitle">
            Import &amp; Export Management
        </div>

    </div>

    <div class="sidebar-menu">

        <div class="sidebar-label">
            Navigation
        </div>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=home">

            <span class="sidebar-icon">▦</span>
            Dashboard

        </a>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/app?action=containers">

            <span class="sidebar-icon">□</span>
            Containers

        </a>

        <% if (!"Customer".equals(role)) { %>

        <a
            class="sidebar-link"
            href="<%= request.getContextPath() %>/pricing?action=view">

            <span class="sidebar-icon">₹</span>
            Pricing

        </a>

        <% } %>

    </div>

    <div class="sidebar-bottom">

        <div class="sidebar-role">
            Signed in as
        </div>

        <div class="sidebar-role-value">
            <%= role == null ? "" : role %>
        </div>

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

<div class="nl-main">

    <header class="nl-topbar">

        <div class="topbar-title">
            Commercial Controls / Final Price
        </div>

        <div class="nl-role">
            <%= role == null ? "" : role %>
        </div>

    </header>

    <main class="nl-content">

        <div class="page-kicker">
            Customer Pricing
        </div>

        <h1 class="page-title">
            Final Price
        </h1>

        <p class="page-description">
            The server-calculated final price for the selected
            container, size and route.
        </p>

        <section class="nl-panel">

            <div class="panel-header">

                <div class="panel-title">
                    Calculated Price
                </div>

            </div>

            <div class="price-box">

                <div class="price-label">
                    Final Price
                </div>

                <div class="price-value">
                    ₹ <%= finalPrice %>
                </div>

                <div class="price-note">
                    The displayed amount is calculated on the server.
                    Internal pricing inputs are not exposed here.
                </div>

            </div>

            <div class="action-bar">

                <a
                    class="btn-nl"
                    href="<%= request.getContextPath() %>/app?action=home">

                    ← Back to Dashboard

                </a>

            </div>

        </section>

    </main>

</div>

</body>
</html>
