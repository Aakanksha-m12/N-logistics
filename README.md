# N-Logistics

A logistics management system built with Java Servlets, JSP and MySQL. It was a
group project during my internship and I worked on Module 3, including the
role-based access control.

## What it is

The system covers the usual logistics company work. Companies register and wait
to be approved, staff members are given roles, and containers go through
allocation, pricing and forecasting.

It runs as two web applications on the same Tomcat server:

| App | Folder | Handles |
|---|---|---|
| Module 1 | `NLogisticsImportExport` | Login, company approval, users and roles, audit log, password reset |
| Module 3 | `NLogisticsModule3` | Containers, allocation, pricing, pricing audit, forecasting, RBAC |

Module 1 does the login. After signing in it creates a signed token and sends the
browser to Module 3, which checks the signature before starting its own session.
The two applications do not share a session cookie.

## What I built

Module 3 and the authorization layer that protects it.

The authorization lives in `Module3Authorization.java`. Every feature has one
guard method that runs on the server before the controller touches the database:

```java
public static void requireContainerManagement(HttpSession session) {
    requireAnyRole(session, ROLE_SUPER_ADMIN, ROLE_COMPANY_ADMIN);
}
```

Company scoping works the same way. Staff get their `companyId` from the session,
not from a form field, so changing a request parameter does not give access to
another company's data.

I also added CSRF tokens to every POST, session timeout handling, and permission
logging in Module 1.

## Roles

| Role | What they do |
|---|---|
| Super Admin | Approves companies, sees everything |
| Company Admin | Runs their own company and users |
| Operations Staff | Containers and allocation |
| Finance Staff | Pricing and pricing audit |
| Customer | Sees their own containers and final price |

Access is checked in Java, not just hidden in the JSP. This is what
`Module3Authorization` actually enforces:

| Feature | Super Admin | Company Admin | Operations | Finance | Customer |
|---|:---:|:---:|:---:|:---:|:---:|
| Container catalogue | Yes | Yes | Yes | Yes | Own only |
| Add / edit / delete containers | Yes | Yes | - | - | - |
| Allocation and release | Yes | Yes | Yes | - | - |
| Pricing | Yes | Yes | - | Yes | Final price |
| Pricing rules | Yes | Yes | - | - | - |
| Pricing audit | Yes | Yes | - | Yes | - |
| Demand forecast | Yes | Yes | - | - | - |

## Security notes

- Passwords are hashed with BCrypt (cost 12) and checked with `BCrypt.checkpw`.
  The database also rejects any value that is not a valid BCrypt hash.
- CSRF tokens are per session and checked in the front controller before any
  action runs.
- Session cookies are HttpOnly, sessions expire after 30 minutes, and a fresh
  session is created after login so session fixation does not work.
- The SSO token is signed with HMAC-SHA256 and expires after 5 minutes.
- Module 1 writes permission denials to the audit log with the user, the action,
  the IP address and a timestamp. Module 3 keeps a separate audit trail for
  pricing changes.
- Credentials and secrets come from environment variables. Nothing sensitive is
  committed to this repository.

## Tech

Java 8, Servlets 3.1, JSP, JDBC, MySQL 8 / MariaDB 10.4, Tomcat 8.5, Eclipse,
Bootstrap 5, jBCrypt.

## Running it

You need JDK 8, Tomcat 8.5, MySQL 8 or MariaDB, and Eclipse for Enterprise Java
Developers.

```bash
mysql -u root -p -e "CREATE DATABASE logistics_db"
mysql -u root -p logistics_db < database/schema.sql
mysql -u root -p logistics_db < database/seed.sql
```

`seed.sql` is optional. It creates a demo Super Admin so you have something to
log in with.

Next, copy `config/setenv.example.bat` to `<TOMCAT_HOME>\bin\setenv.bat` and
fill in your values. The SSO secret has to be the same for both applications.

Import both projects into Eclipse, deploy Module 1 first and then Module 3, and
open <http://localhost:8081/NLogisticsImportExport/>.

If you ran `seed.sql`, the login is `superadmin` / `Admin@12345`. That account is
for local testing only.

## Configuration

| Variable | Needed | Default |
|---|---|---|
| `NLOGISTICS_SSO_SECRET` | Yes | none |
| `NLOGISTICS_DB_URL` | No | `jdbc:mysql://localhost:3306/logistics_db` |
| `NLOGISTICS_DB_USER` | No | `root` |
| `NLOGISTICS_DB_PASSWORD` | No | empty |
| `NLOGISTICS_SMTP_HOST` | No | none |
| `NLOGISTICS_SMTP_PORT` | No | none |
| `NLOGISTICS_SMTP_USER` | No | none |
| `NLOGISTICS_SMTP_PASS` | No | none |
| `NLOGISTICS_SMTP_FROM` | No | none |

Without the SMTP settings, password reset codes are printed to the Tomcat
console instead of being emailed.

## Known issues

- No automated tests. Everything was checked by hand in the browser.
- Business logic is split between Java and MySQL stored procedures, which makes
  it harder to follow than a single-layer design.
- `ContainerController` is around 1400 lines and several JSPs carry their own
  styling.
- Module 2 of the original project is not in this repository.
- `schema.sql` is structure only. The role rows are included because the stored
  procedures need them, but there are no user accounts until you run `seed.sql`.

## Note

This is an internship group project. My part was Module 3 and the RBAC
implementation. I put it here to keep a record of what I built and what I
learned.
