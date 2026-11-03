<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>N Logistics · Error</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1">


<!-- =====================================================
     BOOTSTRAP
     ===================================================== -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- =====================================================
     N LOGISTICS DESIGN SYSTEM
     ===================================================== -->

<style>

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

    --hold: #B23A2E;
}


/* =====================================================
   PAGE
   ===================================================== */

* {
    box-sizing: border-box;
}


body {

    margin: 0;

    min-height: 100vh;

    background: var(--paper);

    color: var(--ink);

    font-family:
        Arial,
        Helvetica,
        sans-serif;

    display: flex;

    align-items: center;

    justify-content: center;

    padding: 30px;
}


/* =====================================================
   ERROR CARD
   ===================================================== */

.error-card {

    width: 100%;

    max-width: 620px;

    background: var(--surface);

    border:
        1px solid var(--line);

    border-radius: 0;

    padding: 0;

    overflow: hidden;
}


/* =====================================================
   CARD HEADER
   ===================================================== */

.error-header {

    background: var(--ink);

    padding:
        22px 28px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 15px;
}


.logo {

    display: flex;

    align-items: center;

    color: white;

    font-size: 19px;

    font-weight: 700;
}


.logo-mark {

    width: 34px;

    height: 34px;

    display: inline-flex;

    align-items: center;

    justify-content: center;

    background: var(--cargo);

    color: white;

    margin-right: 9px;

    font-weight: 800;
}


.logo-subtitle {

    color: #AEB9C1;

    font-size: 9px;

    text-transform: uppercase;

    letter-spacing: 0.8px;

    margin-top: 3px;
}


/* =====================================================
   ERROR CONTENT
   ===================================================== */

.error-content {

    padding:
        42px 42px 36px;

    text-align: center;
}


/* =====================================================
   ERROR ICON
   ===================================================== */

.error-icon {

    width: 64px;

    height: 64px;

    margin:
        0 auto 22px;

    background:
        var(--cargo-soft);

    border:
        1px solid #E9BBA4;

    color:
        var(--hold);

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 29px;

    font-weight: 800;
}


/* =====================================================
   KICKER
   ===================================================== */

.error-kicker {

    color:
        var(--cargo);

    font-size: 10px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 1.4px;

    margin-bottom: 8px;
}


/* =====================================================
   TITLE
   ===================================================== */

.error-title {

    font-size: 27px;

    font-weight: 750;

    color: var(--ink);

    margin-bottom: 13px;

    letter-spacing: -0.3px;
}


/* =====================================================
   MESSAGE
   ===================================================== */

.error-message {

    font-size: 13px;

    color: var(--ink-soft);

    line-height: 1.7;

    margin:
        0 auto 28px;

    max-width: 480px;
}


/* =====================================================
   ERROR MESSAGE EMPHASIS
   ===================================================== */

.error-message::first-line {

    color: var(--ink-soft);
}


/* =====================================================
   BACK BUTTON
   ===================================================== */

.back-btn {

    display: inline-flex;

    align-items: center;

    justify-content: center;

    gap: 7px;

    padding:
        11px 19px;

    border:
        1px solid var(--cargo);

    border-radius: 0;

    background:
        var(--cargo);

    color: white;

    text-decoration: none;

    font-size: 11px;

    font-weight: 700;

    transition:
        background 0.15s ease,
        border-color 0.15s ease;
}


.back-btn:hover {

    background:
        var(--cargo-dark);

    border-color:
        var(--cargo-dark);

    color: white;
}


/* =====================================================
   FOOTER STRIP
   ===================================================== */

.error-footer {

    border-top:
        1px solid var(--line);

    background:
        #FAFBFB;

    padding:
        13px 20px;

    text-align: center;

    color:
        var(--ink-faint);

    font-size: 10px;

    letter-spacing: 0.2px;
}


/* =====================================================
   RESPONSIVE
   ===================================================== */

@media (max-width: 600px) {

    body {

        padding: 18px;
    }


    .error-header {

        padding:
            18px 20px;
    }


    .error-content {

        padding:
            34px 22px 30px;
    }


    .error-title {

        font-size: 23px;
    }


    .error-message {

        font-size: 12px;
    }

}

</style>

</head>


<body>


<!-- =====================================================
     ERROR CARD
     ===================================================== -->

<div class="error-card">


    <!-- =================================================
         HEADER
         ================================================= -->

    <div class="error-header">


        <div>

            <div class="logo">

                <span class="logo-mark">
                    N
                </span>

                N Logistics

            </div>


            <div class="logo-subtitle">

                Import &amp; Export Management

            </div>

        </div>

    </div>


    <!-- =================================================
         ERROR CONTENT
         ================================================= -->

    <div class="error-content">


        <div class="error-icon">

            !

        </div>


        <div class="error-kicker">

            Request Error

        </div>


        <div class="error-title">

            Invalid Container Details

        </div>


        <div class="error-message">

            <%
                String errorMessage =
                        (String) request.getAttribute("errorMessage");

                if (errorMessage == null ||
                        errorMessage.trim().isEmpty()) {

                    errorMessage =
                            "Unable to process your request.";
                }

                String backUrl =
                        request.getContextPath()
                        + "/containers?action=view";
            %>


            <%= errorMessage %>

            <br>

            Please check the information you entered
            and try again.

        </div>


        <!-- =================================================
             BACK BUTTON
             ================================================= -->

        <a
            href="<%= backUrl %>"
            class="back-btn">

            ← Back to Containers

        </a>


    </div>


    <!-- =================================================
         FOOTER
         ================================================= -->

    <div class="error-footer">

        N Logistics · Container Management

    </div>


</div>


</body>

</html>
