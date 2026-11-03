<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Company" %>

<%
/*
 * =============================================================
 * CSRF
 * =============================================================
 */

controller.Csrf.ensureToken(request);

String csrfToken =
        (String) session.getAttribute("csrfToken");


/*
 * =============================================================
 * ROLE
 * =============================================================
 */

String role =
        (String) session.getAttribute("roleName");

if (role == null) {
    role = "";
}


boolean isSuperAdmin =
        "Super Admin".equals(role);

boolean isCompanyAdmin =
        "Company Admin".equals(role);


/*
 * =============================================================
 * AUTHORIZATION
 * =============================================================
 */

if (!isSuperAdmin && !isCompanyAdmin) {

    response.sendError(
            HttpServletResponse.SC_FORBIDDEN,
            "Access denied."
    );

    return;
}


/*
 * =============================================================
 * ERROR MESSAGE
 * =============================================================
 */

String errorMessage =
        (String) request.getAttribute("errorMessage");


/*
 * =============================================================
 * SELECTED COMPANY ID
 * =============================================================
 */

Object selectedCompanyIdObject =
        request.getAttribute("selectedCompanyId");

String selectedCompanyId =
        selectedCompanyIdObject != null
        ? selectedCompanyIdObject.toString()
        : "";


/*
 * Fallback to request parameter
 */

if (selectedCompanyId.isEmpty()) {

    String requestCompanyId =
            request.getParameter("companyId");

    if (requestCompanyId != null &&
            !requestCompanyId.trim().isEmpty()) {

        selectedCompanyId =
                requestCompanyId.trim();
    }
}


/*
 * =============================================================
 * SELECTED COMPANY
 * =============================================================
 */

Object selectedCompanyObject =
        request.getAttribute("selectedCompany");

Company selectedCompany =
        selectedCompanyObject instanceof Company
        ? (Company) selectedCompanyObject
        : null;


/*
 * =============================================================
 * ACTIVE COMPANIES
 * =============================================================
 */

Object companiesObject =
        request.getAttribute("companies");

List<Company> companies =
        new ArrayList<Company>();

if (companiesObject instanceof List<?>) {

    for (Object item :
            (List<?>) companiesObject) {

        if (item instanceof Company) {

            companies.add(
                    (Company) item
            );
        }
    }
}


/*
 * =============================================================
 * OLD VALUES
 * =============================================================
 */

String oldContainerNumber =
        request.getParameter("containerNumber");

String oldType =
        request.getParameter("type");

String oldSize =
        request.getParameter("size");

String oldTareWeight =
        request.getParameter("tareWeightKg");

String oldMaxGrossWeight =
        request.getParameter("maxGrossWeightKg");

String oldGoodsCapacityKg =
        request.getParameter("goodsCapacityKg");

String oldGoodsCapacityCbm =
        request.getParameter("goodsCapacityCbm");


if (oldContainerNumber == null) {
    oldContainerNumber = "";
}

if (oldType == null) {
    oldType = "";
}

if (oldSize == null) {
    oldSize = "";
}

if (oldTareWeight == null) {
    oldTareWeight = "";
}

if (oldMaxGrossWeight == null) {
    oldMaxGrossWeight = "";
}

if (oldGoodsCapacityKg == null) {
    oldGoodsCapacityKg = "";
}

if (oldGoodsCapacityCbm == null) {
    oldGoodsCapacityCbm = "";
}

%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>N Logistics · Add Container</title>


<!-- =========================================================
     BOOTSTRAP
     ========================================================= -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<style>

/* ============================================================
   N LOGISTICS DESIGN SYSTEM
   ============================================================ */

:root {

    --paper: #F0F2F1;

    --surface: #FFFFFF;

    --ink: #10202F;

    --ink-soft: #5C6A78;

    --ink-faint: #8B96A0;

    --line: #DFE3E2;

    --cargo: #D9622B;

    --cargo-dark: #BC4F20;

    --cargo-soft: #FBE7DB;

    --danger: #B23A2E;

    --success: #2F7D53;

}


/* ============================================================
   GLOBAL
   ============================================================ */

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

    background:
        var(--paper);

    color:
        var(--ink);

    font-family:
        Arial,
        Helvetica,
        sans-serif;

}


/* ============================================================
   SIDEBAR
   ============================================================ */

.nl-sidebar {

    position: fixed;

    top: 0;

    left: 0;

    width: 245px;

    height: 100vh;

    background:
        var(--ink);

    color: white;

    z-index: 1000;

    display: flex;

    flex-direction: column;

}


/* ============================================================
   BRAND
   ============================================================ */

.nl-brand {

    display: flex;

    align-items: center;

    padding:
        24px 20px;

    color: white;

    text-decoration: none;

    border-bottom:
        1px solid
        #293A48;

}


.nl-brand-mark {

    width: 40px;

    height: 40px;

    display: flex;

    align-items: center;

    justify-content: center;

    background:
        var(--cargo);

    color: white;

    font-size: 19px;

    font-weight: 800;

    margin-right: 11px;

}


.nl-brand-text {

    display: flex;

    flex-direction: column;

}


.nl-brand-name {

    font-size: 17px;

    font-weight: 700;

}


.nl-brand-sub {

    margin-top: 3px;

    color:
        #9CAAB3;

    font-size: 9px;

    text-transform:
        uppercase;

    letter-spacing:
        1.2px;

}


/* ============================================================
   SIDEBAR ROLE
   ============================================================ */

.nl-sidebar-role {

    padding:
        18px 20px;

    border-bottom:
        1px solid
        #293A48;

}


.nl-role-label {

    color:
        #7F909B;

    font-size: 9px;

    font-weight: 700;

    text-transform:
        uppercase;

    letter-spacing:
        1.2px;

}


.nl-role-value {

    margin-top: 6px;

    color:
        #E5EAED;

    font-size: 12px;

    font-weight: 600;

}


/* ============================================================
   SIDEBAR MENU
   ============================================================ */

.nl-menu {

    padding:
        20px 12px;

    flex: 1;

}


.nl-menu-title {

    padding:
        0 10px 9px;

    color:
        #738590;

    font-size: 9px;

    font-weight: 700;

    text-transform:
        uppercase;

    letter-spacing:
        1.3px;

}


.nl-menu-link {

    display: flex;

    align-items: center;

    width: 100%;

    padding:
        12px 12px;

    margin-bottom: 5px;

    color:
        #C8D1D6;

    text-decoration: none;

    font-size: 13px;

    font-weight: 600;

    border-left:
        3px solid
        transparent;

}


.nl-menu-link:hover {

    color: white;

    background:
        #182E3E;

    border-left-color:
        var(--cargo);

}


.nl-menu-link.active {

    color: white;

    background:
        #182E3E;

    border-left-color:
        var(--cargo);

}


.nl-menu-icon {

    width: 25px;

    margin-right: 8px;

    color:
        #AAB8BF;

    font-size: 14px;

}


/* ============================================================
   SIDEBAR BOTTOM
   ============================================================ */

.nl-sidebar-bottom {

    padding:
        15px 12px 20px;

    border-top:
        1px solid
        #293A48;

}


/* ============================================================
   LOGOUT
   ============================================================ */

.nl-logout {

    width: 100%;

    padding:
        11px 12px;

    background:
        transparent;

    color:
        #D6DEE2;

    border:
        1px solid
        #53636E;

    font-size: 12px;

    font-weight: 600;

    cursor: pointer;

}


.nl-logout:hover {

    background:
        #193346;

    border-color:
        var(--cargo);

    color: white;

}


/* ============================================================
   MAIN AREA
   ============================================================ */

.nl-main {

    margin-left:
        245px;

    min-height:
        100vh;

}


/* ============================================================
   TOP BAR
   ============================================================ */

.nl-topbar {
            height: 72px;
            background: var(--surface);
            border-bottom: 1px solid var(--line);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
        }


.nl-topbar-title {

    font-size: 13px;

    color:
        var(--ink-soft);

}


.nl-topbar-title strong {

    color:
        var(--ink);

}


/* ============================================================
   BACK BUTTON
   ============================================================ */

.nl-back {

    display: inline-flex;

    align-items: center;

    gap: 7px;

    padding:
        8px 13px;

    background:
        white;

    color:
        var(--ink);

    border:
        1px solid
        var(--line);

    text-decoration: none;

    font-size: 12px;

    font-weight: 600;

}


.nl-back:hover {

    background:
        #F6F7F7;

    color:
        var(--ink);

    border-color:
        #C5CDCF;

}


/* ============================================================
   PAGE CONTENT
   ============================================================ */

.nl-content {

    max-width:
        1050px;

    margin:
        0 auto;

    padding:
        38px 30px 65px;

}


/* ============================================================
   PAGE HEADER
   ============================================================ */

.page-kicker {

    color:
        var(--cargo);

    font-size:
        11px;

    font-weight:
        700;

    text-transform:
        uppercase;

    letter-spacing:
        1.5px;

    margin-bottom:
        8px;

}


.page-title {

    margin:
        0;

    font-size:
        34px;

    font-weight:
        750;

    letter-spacing:
        -.5px;

}


.page-description {

    margin:
        9px 0 27px;

    color:
        var(--ink-soft);

    font-size:
        14px;

    line-height:
        1.6;

}


/* ============================================================
   PANEL
   ============================================================ */

.nl-panel {

    background:
        var(--surface);

    border:
        1px solid
        var(--line);

    padding:
        28px;

    box-shadow:
        0 3px 15px
        rgba(16,32,47,.035);

}


/* ============================================================
   INFO BOX
   ============================================================ */

.info-box {

    padding:
        14px 16px;

    margin-bottom:
        25px;

    background:
        #F7F8F8;

    border:
        1px solid
        var(--line);

    border-left:
        4px solid
        var(--cargo);

    color:
        var(--ink-soft);

    font-size:
        13px;

    line-height:
        1.55;

}


/* ============================================================
   ERROR
   ============================================================ */

.validation-error {

    padding:
        14px 16px;

    margin-bottom:
        24px;

    background:
        #FFF1F0;

    border:
        1px solid
        #E8A7A0;

    border-left:
        4px solid
        var(--danger);

    color:
        #8B2E25;

    font-size:
        13px;

    line-height:
        1.5;

}


.validation-error-title {

    margin-bottom:
        4px;

    font-weight:
        700;

    font-size:
        14px;

}


/* ============================================================
   LABEL
   ============================================================ */

.form-label {

    color:
        var(--ink);

    font-size:
        12px;

    font-weight:
        700;

    margin-bottom:
        7px;

}


.required {

    color:
        var(--danger);

}


/* ============================================================
   FORM INPUTS
   ============================================================ */

.form-control,
.form-select {

    min-height:
        45px;

    border:
        1px solid
        #CBD2D5;

    border-radius:
        0;

    color:
        var(--ink);

    font-size:
        13px;

    box-shadow:
        none;

}


.form-control:focus,
.form-select:focus {

    border-color:
        var(--cargo);

    box-shadow:
        0 0 0
        .15rem
        rgba(217,98,43,.12);

}


.form-text {

    color:
        var(--ink-faint);

    font-size:
        11px;

}


/* ============================================================
   COMPANY BOX
   ============================================================ */

.company-box {

    padding:
        14px 16px;

    background:
        var(--cargo-soft);

    border:
        1px solid
        #F2C7B2;

}


.company-name {

    color:
        var(--ink);

    font-size:
        14px;

    font-weight:
        700;

}


/* ============================================================
   EMPTY COMPANY
   ============================================================ */

.empty-company {

    padding:
        13px 15px;

    background:
        #FFF4F1;

    border:
        1px solid
        #F2C7B2;

    color:
        #8B3E2C;

    font-size:
        12px;

}


/* ============================================================
   IMAGE UPLOAD
   ============================================================ */

.image-upload-box {

    padding:
        17px;

    background:
        #FAFBFB;

    border:
        1px dashed
        #C8D0D4;

}


.image-upload-box:hover {

    border-color:
        var(--cargo);

}


.image-preview {

    display:
        none;

    margin-top:
        15px;

    max-width:
        270px;

    max-height:
        180px;

    object-fit:
        cover;

    border:
        1px solid
        var(--line);

}


.image-selected {

    display:
        none;

    margin-top:
        8px;

    color:
        var(--ink-soft);

    font-size:
        11px;

}


/* ============================================================
   BUTTON AREA
   ============================================================ */

.form-actions {

    display:
        flex;

    justify-content:
        space-between;

    align-items:
        center;

    gap:
        10px;

    margin-top:
        30px;

    padding-top:
        22px;

    border-top:
        1px solid
        var(--line);

}


/* ============================================================
   ADD BUTTON
   ============================================================ */

.btn-nl {

    background:
        var(--cargo);

    color:
        white;

    border:
        1px solid
        var(--cargo);

    border-radius:
        0;

    padding:
        11px 20px;

    font-size:
        12px;

    font-weight:
        700;

}


.btn-nl:hover {

    background:
        var(--cargo-dark);

    border-color:
        var(--cargo-dark);

    color:
        white;

}


/* ============================================================
   CANCEL
   ============================================================ */

.btn-cancel {

    background:
        white;

    color:
        var(--ink);

    border:
        1px solid
        var(--line);

    border-radius:
        0;

    padding:
        11px 20px;

    font-size:
        12px;

    font-weight:
        700;

    text-decoration:
        none;

}


.btn-cancel:hover {

    background:
        #F6F7F7;

    color:
        var(--ink);

}


/* ============================================================
   MOBILE SIDEBAR
   ============================================================ */

@media (max-width: 850px) {

    .nl-sidebar {

        width:
            70px;

    }


    .nl-brand {

        justify-content:
            center;

        padding:
            17px 10px;

    }


    .nl-brand-mark {

        margin:
            0;

    }


    .nl-brand-text,
    .nl-sidebar-role,
    .nl-menu-title {

        display:
            none;

    }


    .nl-menu {

        padding:
            15px 9px;

    }


    .nl-menu-link {

        justify-content:
            center;

        padding:
            13px 5px;

    }


    .nl-menu-icon {

        margin:
            0;

        width:
            auto;

    }


    .nl-menu-text {

        display:
            none;

    }


    .nl-sidebar-bottom {

        padding:
            10px;

    }


    .nl-logout {

        font-size:
            0;

        padding:
            11px 5px;

    }


    .nl-logout:before {

        content:
            "↪";

        font-size:
            17px;

    }


    .nl-main {

        margin-left:
            70px;

    }


    .nl-topbar {

        padding:
            0 18px;

    }


    .nl-content {

        padding:
            28px 18px 50px;

    }

}


@media (max-width: 550px) {

    .nl-topbar-title {

        display:
            none;

    }


    .nl-content {

        padding:
            23px 12px 40px;

    }


    .nl-panel {

        padding:
            19px;

    }


    .page-title {

        font-size:
            29px;

    }


    .form-actions {

        flex-direction:
            column-reverse;

        align-items:
            stretch;

    }


    .form-actions > div {

        width:
            100%;

    }


    .btn-nl,
    .btn-cancel {

        display:
            block;

        width:
            100%;

        text-align:
            center;

    }

}


.topbar-title {
    font-size: 15px;
    font-weight: 700;
    color: var(--ink);
}
.topbar-role {
    font-size: 12px;
    font-weight: 700;
    color: var(--ink-soft);
    border: 1px solid var(--border);
    padding: 7px 10px;
    background: white;
}
</style>

</head>


<body>


<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<aside class="nl-sidebar">


    <!-- BRAND -->

    <a
        href="<%= request.getContextPath() %>/app?action=home"
        class="nl-brand">

        <span class="nl-brand-mark">
            N
        </span>

        <span class="nl-brand-text">

            <span class="nl-brand-name">
                N Logistics
            </span>

            <span class="nl-brand-sub">
                Import &amp; Export
            </span>

        </span>

    </a>


    <!-- ROLE -->

    <div class="nl-sidebar-role">

        <div class="nl-role-label">
            Active role
        </div>

        <div class="nl-role-value">
            <%= role %>
        </div>

    </div>


    <!-- MENU -->

    <div class="nl-menu">

        <div class="nl-menu-title">
            Navigation
        </div>


        <a
            href="<%= request.getContextPath() %>/app?action=home"
            class="nl-menu-link">

            <span class="nl-menu-icon">
                ◼
            </span>

            <span class="nl-menu-text">
                Dashboard
            </span>

        </a>


        <a
            href="<%= request.getContextPath() %>/app?action=home"
            class="nl-menu-link active">

            <span class="nl-menu-icon">
                ▣
            </span>

            <span class="nl-menu-text">
                Containers
            </span>

        </a>


        <a
            href="<%= request.getContextPath() %>/pricing?action=view"
            class="nl-menu-link">

            <span class="nl-menu-icon">
                ₹
            </span>

            <span class="nl-menu-text">
                Pricing
            </span>

        </a>


        <a
            href="<%= request.getContextPath() %>/forecast?action=view"
            class="nl-menu-link">

            <span class="nl-menu-icon">
                ↗
            </span>

            <span class="nl-menu-text">
                Forecast
            </span>

        </a>

    </div>


    <!-- LOGOUT -->

    <div class="nl-sidebar-bottom">

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
                class="nl-logout">


                Logout

            </button>

        </form>

    </div>


</aside>



<!-- ============================================================
     MAIN
     ============================================================ -->

<div class="nl-main">


    <!-- ========================================================
         TOP BAR
         ======================================================== -->

    <header class="nl-topbar">

        <div class="topbar-title">
            Container Management
        </div>

        <div class="topbar-role">
            <%= role == null ? "" : role %>
        </div>

    </header>


    <!-- ========================================================
         PAGE CONTENT
         ======================================================== -->

    <main class="nl-content">


        <div class="page-kicker">

            Container Operations

        </div>


        <h1 class="page-title">

            Add Container

        </h1>


        <p class="page-description">

            Add a new container to the authorized company
            catalog.

        </p>



        <!-- ====================================================
             FORM PANEL
             ==================================================== -->

        <section class="nl-panel">


            <!-- ERROR -->

            <% if (errorMessage != null &&
                    !errorMessage.trim().isEmpty()) { %>


                <div class="validation-error">

                    <div class="validation-error-title">

                        ⚠ Invalid Container Details

                    </div>

                    <%= errorMessage %>

                </div>


            <% } %>



            <!-- INFORMATION -->

            <div class="info-box">

                <strong>System controlled fields:</strong>

                The container ID, owner company and initial
                status are controlled by the system.

                The new container will start with
                <strong>Available</strong> status.

            </div>



            <!-- =================================================
                 FORM
                 ================================================= -->

            <form
                method="post"
                action="<%= request.getContextPath() %>/containers"
                enctype="multipart/form-data">


                <!-- ACTION -->

                <input
                    type="hidden"
                    name="action"
                    value="add">


                <!-- CSRF -->

                <input
                    type="hidden"
                    name="csrfToken"
                    value="<%= csrfToken %>">



                <!-- =================================================
                     OWNER COMPANY
                     ================================================= -->

                <% if (isSuperAdmin) { %>


                    <div class="mb-4">


                        <label
                            for="companyId"
                            class="form-label">

                            Owner Company
                            <span class="required">*</span>

                        </label>


                        <% if (!selectedCompanyId.isEmpty()
                                && selectedCompany != null) { %>


                            <div class="company-box">

                                <div class="company-name">

                                    <%= selectedCompany.getCompanyName() %>

                                </div>


                                <div class="form-text mt-1 d-none">

                                    Company ID:
                                    <%= selectedCompanyId %>

                                </div>

                            </div>


                            <input
                                type="hidden"
                                name="companyId"
                                value="<%= selectedCompanyId %>">


                        <% } else { %>


                            <% if (!companies.isEmpty()) { %>


                                <select
                                    name="companyId"
                                    id="companyId"
                                    class="form-select"
                                    required>


                                    <option value="">

                                        Select company

                                    </option>


                                    <% for (Company company :
                                            companies) { %>


                                        <option
                                            value="<%= company.getCompanyId() %>">

                                            <%= company.getCompanyName() %>

                                        </option>


                                    <% } %>


                                </select>


                                <div class="form-text mt-1">

                                    Select the company that will
                                    own this container.

                                </div>


                            <% } else { %>


                                <div class="empty-company">

                                    No active companies are available
                                    for container ownership.

                                </div>


                            <% } %>


                        <% } %>


                    </div>


                <% } else { %>


                    <!-- COMPANY ADMIN -->

                    <div class="company-box mb-4">


                        <div class="form-label">

                            Owner Company

                        </div>


                        <% if (selectedCompany != null) { %>


                            <div class="company-name">

                                <%= selectedCompany.getCompanyName() %>

                            </div>


                            <div class="form-text mt-1 d-none">

                                Company ID:
                                <%= selectedCompanyId %>

                            </div>


                        <% } else { %>


                            <div class="company-name">

                                Your authorized company

                            </div>


                        <% } %>


                    </div>


                <% } %>



                <!-- =================================================
                     CONTAINER DETAILS
                     ================================================= -->

                <div class="row g-4">


                    <!-- CONTAINER NUMBER -->

                    <div class="col-md-6">

                        <label
                            for="containerNumber"
                            class="form-label">

                            Container Number
                            <span class="required">*</span>

                        </label>


                        <input
                            type="text"
                            name="containerNumber"
                            id="containerNumber"
                            class="form-control"
                            maxlength="50"
                            value="<%= oldContainerNumber %>"
                            required>


                        <div class="form-text mt-1">

                            Enter the unique container
                            identification number.

                        </div>

                    </div>



                    <!-- TYPE -->

                    <div class="col-md-3">

                        <label
                            for="type"
                            class="form-label">

                            Type
                            <span class="required">*</span>

                        </label>


                        <select
                            name="type"
                            id="type"
                            class="form-select"
                            required>


                            <option value="">
                                Select type
                            </option>


                            <option value="Dry"
                                <%= "Dry".equals(oldType)
                                    ? "selected" : "" %>>

                                Dry

                            </option>


                            <option value="Reefer"
                                <%= "Reefer".equals(oldType)
                                    ? "selected" : "" %>>

                                Reefer

                            </option>


                            <option value="Open Top"
                                <%= "Open Top".equals(oldType)
                                    ? "selected" : "" %>>

                                Open Top

                            </option>


                            <option value="Flat Rack"
                                <%= "Flat Rack".equals(oldType)
                                    ? "selected" : "" %>>

                                Flat Rack

                            </option>


                            <option value="Tank"
                                <%= "Tank".equals(oldType)
                                    ? "selected" : "" %>>

                                Tank

                            </option>


                        </select>

                    </div>



                    <!-- SIZE -->

                    <div class="col-md-3">

                        <label
                            for="size"
                            class="form-label">

                            Size
                            <span class="required">*</span>

                        </label>


                        <select
                            name="size"
                            id="size"
                            class="form-select"
                            required>


                            <option value="">
                                Select size
                            </option>


                            <option value="20ft"
                                <%= "20ft".equals(oldSize)
                                    ? "selected" : "" %>>

                                20ft

                            </option>


                            <option value="40ft"
                                <%= "40ft".equals(oldSize)
                                    ? "selected" : "" %>>

                                40ft

                            </option>


                            <option value="40ft HC"
                                <%= "40ft HC".equals(oldSize)
                                    ? "selected" : "" %>>

                                40ft HC

                            </option>


                            <option value="45ft"
                                <%= "45ft".equals(oldSize)
                                    ? "selected" : "" %>>

                                45ft

                            </option>


                        </select>

                    </div>



                    <!-- =================================================
                         IMAGE
                         ================================================= -->

                    <div class="col-12">

                        <label
                            for="imageFile"
                            class="form-label">

                            Container Image

                        </label>


                        <div class="image-upload-box">


                            <input
                                type="file"
                                name="imageFile"
                                id="imageFile"
                                class="form-control"
                                accept="image/jpeg,image/png,image/webp,image/gif">


                            <div class="form-text mt-2">

                                Supported:
                                JPG, JPEG, PNG, WEBP and GIF.

                                <br>

                                Maximum size: 5 MB.

                            </div>


                            <div
                                id="imageSelected"
                                class="image-selected">
                            </div>


                            <img
                                id="imagePreview"
                                class="image-preview"
                                alt="Container image preview">


                        </div>

                    </div>



                    <!-- =================================================
                         TARE WEIGHT
                         ================================================= -->

                    <div class="col-md-4">

                        <label
                            for="tareWeightKg"
                            class="form-label">

                            Tare Weight (kg)
                            <span class="required">*</span>

                        </label>


                        <input
                            type="number"
                            name="tareWeightKg"
                            id="tareWeightKg"
                            class="form-control"
                            min="0"
                            step="0.01"
                            value="<%= oldTareWeight %>"
                            required>

                    </div>



                    <!-- =================================================
                         MAX GROSS
                         ================================================= -->

                    <div class="col-md-4">

                        <label
                            for="maxGrossWeightKg"
                            class="form-label">

                            Max Gross Weight (kg)
                            <span class="required">*</span>

                        </label>


                        <input
                            type="number"
                            name="maxGrossWeightKg"
                            id="maxGrossWeightKg"
                            class="form-control"
                            min="0"
                            step="0.01"
                            value="<%= oldMaxGrossWeight %>"
                            required>

                    </div>



                    <!-- =================================================
                         GOODS CAPACITY KG
                         ================================================= -->

                    <div class="col-md-4">

                        <label
                            for="goodsCapacityKg"
                            class="form-label">

                            Goods Capacity (kg)
                            <span class="required">*</span>

                        </label>


                        <input
                            type="number"
                            name="goodsCapacityKg"
                            id="goodsCapacityKg"
                            class="form-control"
                            min="0"
                            step="0.01"
                            value="<%= oldGoodsCapacityKg %>"
                            required>

                    </div>



                    <!-- =================================================
                         GOODS CAPACITY CBM
                         ================================================= -->

                    <div class="col-md-4">

                        <label
                            for="goodsCapacityCbm"
                            class="form-label">

                            Goods Capacity (CBM)
                            <span class="required">*</span>

                        </label>


                        <input
                            type="number"
                            name="goodsCapacityCbm"
                            id="goodsCapacityCbm"
                            class="form-control"
                            min="0"
                            step="0.01"
                            value="<%= oldGoodsCapacityCbm %>"
                            required>

                    </div>


                </div>



                <!-- =================================================
                     BUTTONS
                     ================================================= -->

                <div class="form-actions">


                    <div>

                        <a
                            href="<%= request.getContextPath() %>/app?action=home"" : "&companyId=" + selectedCompanyId %>"
                            class="btn-cancel">

                            ← Cancel

                        </a>

                    </div>


                    <div>

                        <button
                            type="submit"
                            class="btn-nl">

                            Add Container

                        </button>

                    </div>


                </div>


            </form>


        </section>


    </main>

</div>



<!-- ============================================================
     IMAGE PREVIEW
     ============================================================ -->

<script>

document.addEventListener(
    "DOMContentLoaded",
    function () {


        var imageInput =
            document.getElementById("imageFile");


        var imagePreview =
            document.getElementById("imagePreview");


        var imageSelected =
            document.getElementById("imageSelected");


        if (!imageInput) {

            return;

        }


        imageInput.addEventListener(
            "change",
            function () {


                if (!imageInput.files ||
                    imageInput.files.length === 0) {


                    imagePreview.style.display =
                        "none";


                    imagePreview.removeAttribute(
                        "src"
                    );


                    imageSelected.style.display =
                        "none";


                    imageSelected.textContent =
                        "";


                    return;

                }


                var file =
                    imageInput.files[0];


                var allowedTypes = [
                    "image/jpeg",
                    "image/png",
                    "image/webp",
                    "image/gif"
                ];


                if (
                    allowedTypes.indexOf(
                        file.type
                    ) === -1
                ) {


                    alert(
                        "Please select a JPG, JPEG, PNG, WEBP or GIF image."
                    );


                    imageInput.value =
                        "";


                    imagePreview.style.display =
                        "none";


                    imageSelected.style.display =
                        "none";


                    return;

                }


                if (
                    file.size >
                    5 * 1024 * 1024
                ) {


                    alert(
                        "Image size cannot exceed 5 MB."
                    );


                    imageInput.value =
                        "";


                    imagePreview.style.display =
                        "none";


                    imageSelected.style.display =
                        "none";


                    return;

                }


                imageSelected.textContent =
                    "Selected image: "
                    + file.name;


                imageSelected.style.display =
                    "block";


                var reader =
                    new FileReader();


                reader.onload =
                    function (event) {


                        imagePreview.src =
                            event.target.result;


                        imagePreview.style.display =
                            "block";

                    };


                reader.readAsDataURL(
                    file
                );

            }
        );

    }
);

</script>



<!-- ============================================================
     BOOTSTRAP JS
     ============================================================ -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


</body>

</html>