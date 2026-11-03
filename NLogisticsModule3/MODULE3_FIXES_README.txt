N LOGISTICS - MODULE 1 + MODULE 3 FIX PACKAGE
================================================

This package preserves the existing database tables/columns and the existing
five Module 3 Java packages:
    controller
    db_config
    implementors
    model
    operations

Main fixes included
-------------------

1. Module 3 logout
   - All Module 3 logout forms use GET /app?action=logout.
   - Module 3 invalidates its session.
   - Module 3 redirects to Module 1 logout.
   - Module 1 then returns the user to the sign-in page.

2. Session timeout
   - Module 1: 30 minutes.
   - Module 3 SSO session: 30 minutes.
   - Module 3 web.xml now also declares a 30-minute session timeout.
   - An expired Module 3 /app session is redirected into the Module 1
     sign-in flow instead of showing a raw login-session 403.

3. Customer flow
   - Customer does not need companyId.
   - Customer opening the container catalogue is sent to the dedicated
     "No container allocated" screen because the supplied database has no
     customer-to-container allocation relationship.
   - Customer cannot open the allocation/release screen. Direct access is
     redirected to the dashboard.
   - Customer does not receive internal allocation controls.

4. Super Admin container catalogue
   - Super Admin sees all containers by default.
   - Containers are ordered by container_number ASC.
   - Company filtering still uses the company-name dropdown.
   - Company IDs are not displayed as visible labels.

5. Container management
   - "Add Container" is kept in Container Management, not the normal
     Container Catalogue.
   - Add/update/delete return to Container Management.
   - Super Admin edit no longer asks for companyId. The owner company is
     taken from the selected container record.
   - Company Admin gets company context from the authenticated session.
   - Image URL entry has been removed from the update page.
   - Existing image is displayed from the stored image path.
   - New images are uploaded directly with the file chooser.
   - No image path is requested from the user.
   - Catalogue and edit images use fixed dimensions/object-fit for a neat UI.

6. Container deletion
   - Delete remains ownership checked server-side.
   - The old status restriction in the Java DELETE statement was removed so
     the CRUD delete operation is not silently blocked by the old
     Available/Allocated status condition.
   - Database foreign-key constraints, if any exist outside this project,
     can still prevent deletion.

7. Allocation/release
   - Allocation and release are separate screens/flows:
       /allocation?action=view
       /allocation?action=releaseView
   - The same JSP template is rendered in two different modes; the user
     never gets allocation and release controls together on one screen.
   - Super Admin selects a company by name.
   - Company Admin / Operations get companyId only from the authenticated
     session; they are not asked to type it.
   - Company IDs are not shown as visible UI values.

8. Source/destination and port
   - The supplied Module 3 database has current_port_id on containers but
     no port master table.
   - It also has no allocation source/destination fields or route master
     containing source/destination names.
   - Therefore this package does NOT fabricate port names, source ports,
     destinations, or routes.
   - The allocation screen explicitly explains this limitation.
   - A real port/source/destination flow requires an existing authoritative
     data source or an explicitly approved database change.

9. Pricing surcharge
   - The existing Java pricing implementation calculates:
       Final Price =
       Base Price * Seasonal Multiplier * Demand Multiplier
       + Configured Surcharge
   - The surcharge is application configuration because the supplied
     pricing_rules table has no surcharge column.
   - Configure it at JVM startup with:
       -Dnlogistics.pricing.surcharge=VALUE
   - Example:
       -Dnlogistics.pricing.surcharge=250.00
   - IMPORTANT: the exact surcharge amount was not present in the supplied
     project/source, so this package does not invent an amount.
   - The existing database trigger/procedure must also accept the
     @pricing_surcharge session variable for a non-zero surcharge to be
     persisted successfully. No database schema was changed by this package.

10. Back buttons
    - Module 3 back buttons now return to:
        /app?action=home

Important deployment steps
--------------------------

1. Stop Tomcat.
2. Remove the old deployed Module 3 application from Tomcat/webapps if
   Eclipse has a stale deployment copy.
3. In Eclipse:
      Project -> Clean -> Clean all projects
      Project -> Build Automatically
4. Clean the Tomcat server/work directory if Eclipse continues serving an
   old JSP copy.
5. Re-publish the projects to Tomcat.
6. Start Module 1 first.
7. Open Module 1, sign in, then enter Module 3 through the Module 3 link.
8. Do NOT open an old bookmarked Module 3 URL after the Module 3 session has
   expired; the fixed flow redirects the expired session to Module 1 login.

Database note
-------------

No tables or columns are changed by this package.

The existing database must contain the procedures/triggers already required
by the original Module 3 project. In particular, if a non-zero configured
pricing surcharge is used, the existing pricing validation logic must use
@pricing_surcharge. If the installed database still validates final_price
as only base_price * seasonal_multiplier * demand_multiplier, a non-zero
surcharge cannot be persisted without an explicitly approved database
procedure/trigger change.

Java compatibility
------------------

The Module 3 sources compile with Java 8 source/target settings using the
Servlet 3.1 API and the supplied MySQL JDBC driver.
