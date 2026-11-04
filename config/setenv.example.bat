@echo off
REM ---------------------------------------------------------------------------
REM N-Logistics environment template
REM
REM Copy this file to <TOMCAT_HOME>\bin\setenv.bat and fill in your values.
REM Tomcat reads setenv.bat at startup, before the web applications load.
REM
REM Do not commit the real setenv.bat. It contains secrets and is listed in
REM .gitignore.
REM ---------------------------------------------------------------------------

REM Shared secret used to sign the Module 1 -> Module 3 SSO token.
REM Must be identical for both applications. Use a long random string.
set NLOGISTICS_SSO_SECRET=replace-with-a-long-random-string

REM Database connection.
set NLOGISTICS_DB_URL=jdbc:mysql://localhost:3306/logistics_db
set NLOGISTICS_DB_USER=root
set NLOGISTICS_DB_PASSWORD=

REM Password reset email (optional).
REM If these are left empty, reset codes are printed to the Tomcat console
REM instead of being emailed.
set NLOGISTICS_SMTP_HOST=smtp.gmail.com
set NLOGISTICS_SMTP_PORT=465
set NLOGISTICS_SMTP_USER=
set NLOGISTICS_SMTP_PASS=
set NLOGISTICS_SMTP_FROM=
