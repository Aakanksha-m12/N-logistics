<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Container" %>
<%@ page import="model.Company" %>
<%@ page import="controller.Csrf" %>

<%
String role = (String) request.getAttribute("role");

if (role == null) {
    role = (String) session.getAttribute("roleName");
}

if (role == null) {
    role = "";
}

boolean isSuperAdmin =
        "Super Admin".equals(role);

boolean isCompanyAdmin =
        "Company Admin".equals(role);

boolean isOperations =
        "Company Staff (Operations)".equals(role);

boolean isCustomer =
        "Customer".equals(role);

boolean releaseOnly =
        Boolean.TRUE.equals(
                request.getAttribute("releaseOnly"));

boolean canAllocate =
        isSuperAdmin ||
        isCompanyAdmin ||
        isOperations ||
        isCustomer;

/*
 * CUSTOMER CAN NOW RELEASE TOO.
 *
 * The controller still verifies that the customer
 * can release ONLY a container allocated by that
 * customer during the current session.
 */
boolean canRelease =
        isSuperAdmin ||
        isCompanyAdmin ||
        isOperations ||
        isCustomer;


/* ==========================================================
   CONTAINER LIST
   ========================================================== */

List<Container> containers =
        new ArrayList<Container>();

Object containerObject =
        request.getAttribute("containers");

if (containerObject instanceof List<?>) {

    for (Object object : (List<?>) containerObject) {

        if (object instanceof Container) {

            containers.add(
                    (Container) object);
        }
    }
}


/* ==========================================================
   COMPANY LIST
   ========================================================== */

List<Company> companies =
        new ArrayList<Company>();

Object companyObject =
        request.getAttribute("companies");

if (companyObject instanceof List<?>) {

    for (Object object : (List<?>) companyObject) {

        if (object instanceof Company) {

            companies.add(
                    (Company) object);
        }
    }
}


Long selectedCompanyId =
        (Long) request.getAttribute(
                "selectedCompanyId");


boolean customerAllocation =
        Boolean.TRUE.equals(
                request.getAttribute(
                        "customerAllocation"));


String success =
        request.getParameter("success");


String csrfToken =
        Csrf.ensureToken(request);


/* ==========================================================
   SHIPMENT ROUTE
   ========================================================== */

String sourcePortName =
        (String) request.getAttribute(
                "originPortName");

String destinationPortName =
        (String) request.getAttribute(
                "destinationPortName");

String shipmentId = null;

Object shipmentIdObject =
        request.getAttribute("shipmentId");

if (shipmentIdObject != null) {

    shipmentId =
            String.valueOf(
                    shipmentIdObject);
}

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    <%= releaseOnly
            ? "Container Release - N Logistics"
            : "Container Allocation - N Logistics" %>
</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<style>

    :root {
        --paper: #F0F2F1;
        --surface: #FFFFFF;
        --ink: #10202F;
        --ink-soft: #5C6A78;
        --border: #DFE3E2;
        --orange: #D9622B;
        --orange-dark: #BE4F21;
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


    /* ======================================================
       SIDEBAR
       ====================================================== */

    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 240px;
        height: 100vh;
        background: var(--ink);
        color: white;
        padding: 20px 15px;
        z-index: 1000;
    }

    .brand {
        display: flex;
        align-items: center;
        color: white;
        text-decoration: none;
        margin-bottom: 35px;
        padding: 5px;
    }

    .brand:hover {
        color: white;
    }

    .brand-box {
        width: 42px;
        height: 42px;
        background: var(--orange);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        font-weight: bold;
        margin-right: 10px;
    }

    .brand-text {
        font-size: 17px;
        font-weight: bold;
    }

    .brand-small {
        display: block;
        color: #91A0AA;
        font-size: 9px;
        letter-spacing: 1px;
        margin-top: 3px;
    }

    .sidebar-title {
        color: #8FA0AA;
        font-size: 10px;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin: 20px 10px 8px;
    }

    .sidebar-link {
        display: block;
        color: #D5DEE2;
        text-decoration: none;
        padding: 12px 13px;
        margin-bottom: 4px;
        font-size: 14px;
        border-left: 3px solid transparent;
    }

    .sidebar-link:hover,
    .sidebar-link.active {
        color: white;
        background: #193346;
        border-left-color: var(--orange);
    }

    .sidebar-role {
        position: absolute;
        left: 15px;
        right: 15px;
        bottom: 80px;
        border-top: 1px solid #2A3B48;
        padding: 15px 8px;
    }

    .role-label {
        color: #8FA0AA;
        font-size: 9px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .role-name {
        color: white;
        font-size: 12px;
        margin-top: 5px;
    }

    .logout-area {
        position: absolute;
        left: 15px;
        right: 15px;
        bottom: 20px;
    }

    .logout-button {
        width: 100%;
        border: 1px solid #52636E;
        background: transparent;
        color: white;
        padding: 10px;
        font-size: 13px;
    }

    .logout-button:hover {
        background: var(--orange);
        border-color: var(--orange);
    }


    /* ======================================================
       MAIN
       ====================================================== */

    .main-content {
        margin-left: 240px;
        min-height: 100vh;
        padding: 35px;
    }

    .top-bar {
        display: flex;
        justify-content: flex-start;
        margin-bottom: 25px;
    }

    .back-button {
        display: inline-flex;
        align-items: center;
        color: var(--ink);
        background: white;
        border: 1px solid var(--border);
        padding: 9px 16px;
        text-decoration: none;
        font-size: 13px;
    }

    .back-button:hover {
        background: var(--ink);
        color: white;
    }

    .page-kicker {
        color: var(--orange);
        font-size: 11px;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        margin-bottom: 7px;
    }

    .page-title {
        font-size: 36px;
        font-weight: bold;
        margin: 0;
    }

    .page-description {
        color: var(--ink-soft);
        font-size: 14px;
        max-width: 700px;
        line-height: 1.6;
        margin-top: 10px;
    }


    /* ======================================================
       ACTION BUTTONS
       ====================================================== */

    .page-actions {
        display: flex;
        gap: 10px;
        margin-bottom: 25px;
    }

    .primary-button {
        display: inline-block;
        background: var(--orange);
        border: 1px solid var(--orange);
        color: white;
        text-decoration: none;
        padding: 11px 18px;
        font-size: 12px;
        font-weight: bold;
    }

    .primary-button:hover {
        background: var(--orange-dark);
        border-color: var(--orange-dark);
        color: white;
    }

    .secondary-button {
        display: inline-block;
        background: white;
        border: 1px solid var(--border);
        color: var(--ink);
        text-decoration: none;
        padding: 11px 18px;
        font-size: 12px;
        font-weight: bold;
    }

    .secondary-button:hover {
        background: var(--ink);
        color: white;
    }


    /* ======================================================
       COMPANY SELECTION
       ====================================================== */

    .company-selection {
        background: white;
        border: 1px solid var(--border);
        padding: 24px;
        margin-bottom: 25px;
    }

    .company-selection-title {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .company-selection-description {
        color: var(--ink-soft);
        font-size: 12px;
        line-height: 1.6;
        margin-bottom: 20px;
    }

    .company-label {
        display: block;
        font-size: 11px;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: .7px;
        margin-bottom: 8px;
    }

    .company-select {
        min-height: 48px;
        border: 1px solid #C9D0D2;
        border-radius: 0;
        font-size: 13px;
        background: white;
        width: 100%;
        padding: 0 14px;
    }

    .company-select:focus {
        outline: none;
        border-color: var(--orange);
        box-shadow: 0 0 0 0.15rem rgba(217, 98, 43, .12);
    }

    .company-help {
        color: #8B96A0;
        font-size: 10px;
        margin-top: 7px;
    }

    .company-submit {
        min-height: 48px;
        margin-top: 27px;
        background: var(--orange);
        border: 1px solid var(--orange);
        color: white;
        padding: 0 22px;
        font-size: 12px;
        font-weight: bold;
        width: 100%;
        cursor: pointer;
    }

    .company-submit:hover {
        background: var(--orange-dark);
        border-color: var(--orange-dark);
    }


    /* ======================================================
       PANEL
       ====================================================== */

    .panel {
        background: white;
        border: 1px solid var(--border);
    }

    .panel-header {
        padding: 20px 22px;
        border-bottom: 1px solid var(--border);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .panel-title {
        margin: 0;
        font-size: 19px;
        font-weight: bold;
    }

    .panel-description {
        margin: 5px 0 0;
        color: var(--ink-soft);
        font-size: 12px;
    }

    .count-badge {
        background: var(--ink);
        color: white;
        padding: 8px 11px;
        font-size: 11px;
        font-weight: bold;
        white-space: nowrap;
    }


    /* ======================================================
       TABLE
       ====================================================== */

    .table {
        margin: 0;
    }

    .table thead th {
        background: var(--ink);
        color: white;
        border: none;
        padding: 14px;
        font-size: 10px;
        text-transform: uppercase;
        letter-spacing: .7px;
        white-space: nowrap;
    }

    .table tbody td {
        padding: 16px 14px;
        border-color: var(--border);
        vertical-align: middle;
        font-size: 12px;
    }

    .table tbody tr:hover {
        background: #FAFBFA;
    }

    .container-image {
        width: 115px;
        height: 72px;
        object-fit: cover;
        display: block;
        border: 1px solid var(--border);
        background: #F7F8F8;
    }

    .no-image {
        width: 115px;
        height: 72px;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 1px solid var(--border);
        background: #F7F8F8;
        color: #8B96A0;
        font-size: 10px;
    }

    .container-number {
        font-family: "Courier New", monospace;
        font-weight: bold;
        font-size: 13px;
    }

    .capacity {
        line-height: 1.7;
        color: var(--ink-soft);
    }

    .capacity strong {
        color: var(--ink);
    }

    .status {
        display: inline-block;
        padding: 6px 9px;
        font-size: 9px;
        font-weight: bold;
        text-transform: uppercase;
    }

    .status-available {
        background: #E4F2E9;
        color: #2F7D53;
    }

    .status-allocated {
        background: #FFF3D8;
        color: #8A5A00;
    }

    .status-transit {
        background: #E6EFF7;
        color: #315E83;
    }

    .status-maintenance {
        background: #FBEAE7;
        color: #B23A2E;
    }


    /* ======================================================
       ACTIONS
       ====================================================== */

    .allocate-button {
        display: inline-block;
        background: var(--orange);
        color: white;
        text-decoration: none;
        border: 1px solid var(--orange);
        padding: 9px 14px;
        font-size: 11px;
        font-weight: bold;
        white-space: nowrap;
    }

    .allocate-button:hover {
        background: var(--orange-dark);
        color: white;
    }

    .release-form {
        margin: 0;
    }

    .release-button {
        background: var(--ink);
        color: white;
        border: 1px solid var(--ink);
        padding: 9px 14px;
        font-size: 11px;
        font-weight: bold;
    }

    .release-button:hover {
        background: #193346;
    }


    /* ======================================================
       EMPTY STATE
       ====================================================== */

    .empty-state {
        text-align: center;
        padding: 65px 20px;
    }

    .empty-icon {
        width: 55px;
        height: 55px;
        margin: 0 auto 18px;
        background: var(--ink);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        font-weight: bold;
    }

    .empty-title {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 7px;
    }

    .empty-text {
        color: var(--ink-soft);
        font-size: 13px;
    }

    .success-message {
        background: #E4F2E9;
        border: 1px solid #B9DEC5;
        color: #2F7D53;
        padding: 13px 16px;
        margin-bottom: 20px;
        font-size: 12px;
    }


    /* ======================================================
       SECURITY NOTE
       ====================================================== */

    .security-note {
        margin-top: 20px;
        background: white;
        border-left: 3px solid var(--orange);
        border-top: 1px solid var(--border);
        border-right: 1px solid var(--border);
        border-bottom: 1px solid var(--border);
        padding: 15px 17px;
        color: var(--ink-soft);
        font-size: 12px;
        line-height: 1.6;
    }

    .security-note strong {
        color: var(--ink);
    }


    /* ======================================================
       MOBILE
       ====================================================== */

    @media (max-width: 900px) {

        .sidebar {
            position: relative;
            width: 100%;
            height: auto;
        }

        .sidebar-role,
        .logout-area {
            position: relative;
            left: auto;
            right: auto;
            bottom: auto;
            margin-top: 15px;
        }

        .main-content {
            margin-left: 0;
            padding: 20px;
        }

        .page-title {
            font-size: 29px;
        }
    }

    @media (max-width: 767px) {

        .company-submit {
            margin-top: 0;
        }
    }

    @media (max-width: 600px) {

        .page-actions {
            flex-direction: column;
        }
    }

</style>

</head>

<body>

<!-- ============================================================
     SIDEBAR
     ============================================================ -->

<div class="sidebar">

<a
    href="<%= request.getContextPath() %>/app?action=home"
    class="brand">

    <span class="brand-box">
        N
    </span>

    <span>

        <span class="brand-text">
            N Logistics
        </span>

        <span class="brand-small">
            IMPORT &amp; EXPORT
        </span>

    </span>

</a>


<div class="sidebar-title">
    Navigation
</div>


<a
    href="<%= request.getContextPath() %>/app?action=home"
    class="sidebar-link">

    Dashboard

</a>


<a
    href="<%= request.getContextPath() %>/app?action=containers"
    class="sidebar-link">

    Containers

</a>


<a
    href="<%= request.getContextPath() %>/allocation?action=view"
    class="sidebar-link active">

    Allocation

</a>


<a
    href="<%= request.getContextPath() %>/pricing?action=view"
    class="sidebar-link">

    Pricing

</a>


<a
    href="<%= request.getContextPath() %>/forecast?action=view"
    class="sidebar-link">

    Demand Forecast

</a>


<div class="sidebar-role">

    <div class="role-label">
        Active role
    </div>

    <div class="role-name">
        <%= role %>
    </div>

</div>


<div class="logout-area">

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
            class="logout-button">

            Logout

        </button>

    </form>

</div>

</div>

<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<main class="main-content">

<div class="top-bar">

    <a
        href="<%= request.getContextPath() %>/app?action=home"
        class="back-button">

        &larr; Back to Dashboard

    </a>

</div>


<div class="page-kicker">
    Container Operations
</div>


<h1 class="page-title">

    <%= releaseOnly
            ? "Release Container"
            : "Container Allocation" %>

</h1>


<p class="page-description">

    <%= releaseOnly
            ? isCustomer
                ? "View only the containers you allocated and release them when required."
                : "Select an allocated container to release it back to Available status."
            : isCustomer
                ? "Select a company to view its available containers and allocate a container for yourself."
                : "Select an available container to open its dedicated allocation page." %>

</p>


<% if (success != null &&
       !success.trim().isEmpty()) { %>

    <div class="success-message">

        <strong>
            Operation completed:
        </strong>

        <%= success %>

    </div>

<% } %>


<!-- ========================================================
     CUSTOMER COMPANY SELECTION
     ======================================================== -->

<% if (isCustomer && !releaseOnly) { %>

    <section class="company-selection">

        <div class="company-selection-title">
            Select Company
        </div>


        <div class="company-selection-description">

            Choose a company to view only its currently
            available containers. You can then select a
            container and allocate it for yourself.

        </div>


        <form
            method="get"
            action="<%= request.getContextPath() %>/allocation">

            <input
                type="hidden"
                name="action"
                value="customerView">


            <div class="row g-3 align-items-start">


                <div class="col-md-9">

                    <label
                        for="companyId"
                        class="company-label">

                        Company

                    </label>


                    <select
                        id="companyId"
                        name="companyId"
                        class="company-select"
                        required>

                        <option value="">

                            Select a company

                        </option>


                        <%
                            for (Company company :
                                    companies) {

                                boolean selected =
                                        selectedCompanyId != null &&
                                        company.getCompanyId() != null &&
                                        selectedCompanyId.equals(
                                                company.getCompanyId());
                        %>

                            <option
                                value="<%= company.getCompanyId() %>"
                                <%= selected ? "selected" : "" %>>

                                <%= company.getCompanyName() %>

                            </option>

                        <%
                            }
                        %>

                    </select>


                    <div class="company-help">

                        Only active companies are available
                        for selection.

                    </div>

                </div>


                <div class="col-md-3">

                    <button
                        type="submit"
                        class="company-submit">

                        View Available Containers

                    </button>

                </div>

            </div>

        </form>

    </section>

<% } %>


<!-- ========================================================
     ACTION BUTTONS
     ======================================================== -->

<div class="page-actions">

    <% if (canAllocate && !releaseOnly && !isCustomer) { %>

        <a
            href="<%= request.getContextPath() %>/allocation?action=view"
            class="primary-button">

            Allocate Container

        </a>

    <% } %>


    <% if (canRelease) { %>

        <a
            href="<%= request.getContextPath() %>/allocation?action=releaseView"
            class="secondary-button">

            <%= isCustomer
                    ? "My Allocated Containers"
                    : "Release Container" %>

        </a>

    <% } %>

</div>


<!-- ========================================================
     CUSTOMER INFORMATION
     ======================================================== -->

<% if (isCustomer &&
       selectedCompanyId != null &&
       !releaseOnly) { %>

    <div
        class="security-note"
        style="margin-top: 0; margin-bottom: 20px;">

        <strong>
            Selected Company:
        </strong>


        <% for (Company company :
                companies) {

            if (company.getCompanyId() != null &&
                selectedCompanyId.equals(
                        company.getCompanyId())) {
        %>

            <%= company.getCompanyName() %>

        <%
                break;
            }
        } %>


        <span style="margin-left: 12px;">

            Only containers with
            <strong>Available</strong>
            status are displayed.

        </span>

    </div>

<% } %>


<!-- ========================================================
     CUSTOMER RELEASE INFORMATION
     ======================================================== -->

<% if (isCustomer && releaseOnly) { %>

    <div
        class="security-note"
        style="margin-top: 0; margin-bottom: 20px;">

        <strong>
            Customer Release:
        </strong>

        Only containers allocated by your current
        customer session are displayed here.

    </div>

<% } %>


<!-- ========================================================
     SHIPMENT ROUTE
     ======================================================== -->

<% if (sourcePortName != null
        && !sourcePortName.trim().isEmpty()
        && destinationPortName != null
        && !destinationPortName.trim().isEmpty()) { %>

    <div
        class="security-note"
        style="margin-top: 0; margin-bottom: 20px;">

        <strong>
            Shipment Route:
        </strong>


        <span style="margin-left: 12px;">

            Source:

            <strong>
                <%= sourcePortName %>
            </strong>

        </span>


        <span style="margin: 0 12px;">
            &rarr;
        </span>


        <span>

            Destination:

            <strong>
                <%= destinationPortName %>
            </strong>

        </span>


        <% if (shipmentId != null
                && !shipmentId.trim().isEmpty()) { %>

            <span style="margin-left: 20px;">

                Shipment:

                <strong>
                    #<%= shipmentId %>
                </strong>

            </span>

        <% } %>

    </div>

<% } %>


<!-- ========================================================
     INVENTORY PANEL
     ======================================================== -->

<section class="panel">


    <div class="panel-header">

        <div>

            <h2 class="panel-title">

                <%= releaseOnly
                        ? isCustomer
                            ? "My Allocated Containers"
                            : "Allocated Containers"
                        : isCustomer
                            ? selectedCompanyId == null
                                ? "Available Container Inventory"
                                : "Available Containers"
                            : "Available Container Inventory" %>

            </h2>


            <p class="panel-description">

                <%= releaseOnly
                        ? isCustomer
                            ? "Only containers allocated by you are shown."
                            : "Choose an allocated container to release."
                        : isCustomer
                            ? selectedCompanyId == null
                                ? "Select a company above to view its available containers."
                                : "Only Available containers belonging to the selected company are shown."
                            : "Choose one available container to continue to allocation." %>

            </p>

        </div>


        <span class="count-badge">

            <%= containers.size() %>

            container<%= containers.size() == 1
                    ? ""
                    : "s" %>

        </span>

    </div>


    <!-- ====================================================
         EMPTY STATE
         ==================================================== -->

    <% if (containers.isEmpty()) { %>

        <div class="empty-state">

            <div class="empty-icon">
                N
            </div>


            <div class="empty-title">

                <% if (isCustomer &&
                       selectedCompanyId == null &&
                       !releaseOnly) { %>

                    Select a company

                <% } else if (releaseOnly) { %>

                    <%= isCustomer
                            ? "No containers allocated by you"
                            : "No allocated containers" %>

                <% } else { %>

                    No available containers

                <% } %>

            </div>


            <div class="empty-text">

                <% if (isCustomer &&
                       selectedCompanyId == null &&
                       !releaseOnly) { %>

                    Select a company from the dropdown
                    above to view its available containers.

                <% } else if (releaseOnly) { %>

                    <%= isCustomer
                            ? "You currently have no allocated containers available for release."
                            : "There are currently no allocated containers in your authorized scope." %>

                <% } else if (isCustomer) { %>

                    The selected company currently has no
                    available containers.

                <% } else { %>

                    There are currently no available containers
                    in your authorized scope.

                <% } %>

            </div>

        </div>


    <% } else { %>


        <!-- =================================================
             TABLE
             ================================================= -->

        <div class="table-responsive">

            <table class="table table-hover align-middle">

                <thead>

                    <tr>

                        <th>
                            Image
                        </th>

                        <th>
                            Container
                        </th>

                        <th>
                            Type
                        </th>

                        <th>
                            Size
                        </th>

                        <th>
                            Goods Capacity
                        </th>

                        <th>
                            Port
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                </thead>


                <tbody>


                <% for (Container container :
                        containers) { %>

                    <%

                        String status =
                                container.getStatus();

                        boolean available =
                                "Available".equalsIgnoreCase(
                                        status);

                        boolean allocated =
                                "Allocated".equalsIgnoreCase(
                                        status);

                    %>


                    <% if (
                            (!releaseOnly && available) ||
                            (releaseOnly && allocated)
                    ) { %>


                    <tr>


                        <!-- IMAGE -->

                        <td>

                            <% if (
                                    container.getImageUrl() != null &&
                                    !container.getImageUrl()
                                            .trim()
                                            .isEmpty()
                            ) { %>

                                <img
                                    src="<%= request.getContextPath() %>/<%= container.getImageUrl() %>"
                                    class="container-image"
                                    alt="Container image">

                            <% } else { %>

                                <div class="no-image">

                                    NO IMAGE

                                </div>

                            <% } %>

                        </td>


                        <!-- CONTAINER -->

                        <td>

                            <div class="container-number">

                                <%= container.getContainerNumber() %>

                            </div>

                        </td>


                        <!-- TYPE -->

                        <td>

                            <strong>

                                <%= container.getType() %>

                            </strong>

                        </td>


                        <!-- SIZE -->

                        <td>

                            <span
                                class="badge border text-dark rounded-0">

                                <%= container.getSize() %>

                            </span>

                        </td>


                        <!-- CAPACITY -->

                        <td>

                            <div class="capacity">

                                <div>

                                    <strong>
                                        KG
                                    </strong>

                                    <%= container.getGoodsCapacityKg() %>

                                </div>


                                <div>

                                    <strong>
                                        CBM
                                    </strong>

                                    <%= container.getGoodsCapacityCbm() %>

                                </div>

                            </div>

                        </td>


                        <!-- PORT -->

                        <td>

                            <%= container.getCurrentPortId() == null
                                    ? "-"
                                    : container.getCurrentPortId() %>

                        </td>


                        <!-- STATUS -->

                        <td>

                            <% if (available) { %>

                                <span
                                    class="status status-available">

                                    Available

                                </span>

                            <% } else if (allocated) { %>

                                <span
                                    class="status status-allocated">

                                    Allocated

                                </span>

                            <% } else if (
                                    "In-Transit".equalsIgnoreCase(
                                            status)
                            ) { %>

                                <span
                                    class="status status-transit">

                                    In-Transit

                                </span>

                            <% } else { %>

                                <span
                                    class="status status-maintenance">

                                    <%= status %>

                                </span>

                            <% } %>

                        </td>


                        <!-- ACTION -->

                        <td>


                            <% if (
                                    !releaseOnly &&
                                    available &&
                                    canAllocate
                            ) { %>


                                <a
                                    href="<%= request.getContextPath() %>/allocation?action=allocateView&containerId=<%= container.getContainerId() %>"
                                    class="allocate-button">

                                    Allocate

                                </a>


                            <% } else if (
                                    releaseOnly &&
                                    allocated &&
                                    canRelease
                            ) { %>


                                <form
                                    method="post"
                                    action="<%= request.getContextPath() %>/allocation"
                                    class="release-form"
                                    onsubmit="return confirmRelease();">


                                    <input
                                        type="hidden"
                                        name="action"
                                        value="release">


                                    <input
                                        type="hidden"
                                        name="containerId"
                                        value="<%= container.getContainerId() %>">


                                    <input
                                        type="hidden"
                                        name="csrfToken"
                                        value="<%= csrfToken == null
                                                ? ""
                                                : csrfToken %>">


                                    <button
                                        type="submit"
                                        class="release-button">

                                        Release

                                    </button>

                                </form>


                            <% } %>

                        </td>

                    </tr>


                    <% } %>


                <% } %>


                </tbody>

            </table>

        </div>


    <% } %>


</section>


<!-- ========================================================
     SERVER VALIDATION NOTE
     ======================================================== -->

<div class="security-note">

    <strong>
        Server-side validation:
    </strong>


    <% if (isCustomer && releaseOnly) { %>

        Customers can release only containers allocated
        by their current authenticated session. The server
        verifies the container before releasing it.

    <% } else if (isCustomer) { %>

        Customers can select an active company and view
        only its Available containers. Allocation is performed
        only for an Available container. Cargo weight and
        cargo volume are validated against the registered
        goods capacity before allocation.

    <% } else { %>

        Allocation is performed only for Available containers.
        Cargo weight and cargo volume are validated against the
        registered goods capacity before the container
        is allocated.

    <% } %>

</div>

</main>

<script>

    function confirmRelease() {

        return confirm(
            "Are you sure you want to release this container?"
        );

    }

</script>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>