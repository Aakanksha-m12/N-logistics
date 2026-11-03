N Logistics Module 1

Java source structure:
src/controller    - controller/servlet layer, actions, auth, reset mailer/store, service coordinator
src/operations    - operation interfaces
src/implementors  - operation implementation classes
src/model         - model classes
src/db_config     - database connection configuration

JSP view structure:
WebContent/WEB-INF/views

Runtime:
Java 8 + Apache Tomcat 8.5

Keep the Gmail SMTP environment variables configured in Eclipse/Tomcat; they are machine/server settings and are intentionally not stored in this project archive.

SECURITY HARDENING ADDED
- Central CSRF token generation and validation for every POST through the Front Controller.
- CSRF hidden fields added to all Module 1 POST forms.
- Logout changed from GET link to CSRF-protected POST.
- Session is invalidated and a fresh session/CSRF token is created after successful login.
- Permission/security denials are recorded through the existing audit operation when a logged-in user triggers them.
- Home navigation is role-aware: Company Users is no longer shown to Operations, Finance, or Customer/Consumer users.
- Fixed the stale sp_get_pending_companies() JDBC call to pass its actor parameter.
