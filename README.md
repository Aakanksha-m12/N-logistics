\# N-Logistics Management System



A logistics management web application built with Java Servlets, JSP and MySQL.

It was developed as a group project during my internship, and I was responsible

for Module 3 and the role-based access control layer.



\## Overview



N-Logistics covers the operational side of a logistics company. Companies

register and wait for approval, staff members are assigned roles, and containers

move through allocation, pricing and forecasting workflows.



The system runs as two separate web applications on the same Tomcat server:



| Application | Folder | Responsibility |

|---|---|---|

| Module 1 | `NLogisticsImportExport` | Login, company registration and approval, user and role management, audit log, password reset |

| Module 3 | `NLogisticsModule3` | Container management, allocation and release, pricing rules, pricing audit, demand forecasting, RBAC |



Module 1 owns authentication. When a user signs in there, it builds a signed

token containing their user id, role and company, then redirects the browser to

Module 3. Module 3 verifies the HMAC signature and the token age before creating

its own session. The two applications never share a session cookie, so access to

one does not automatically grant access to the other.



\## My contribution



I built Module 3 and the authorization layer that protects it.



The centre of that work is `Module3Authorization.java`. Instead of checking

roles inside JSP pages, every capability has one guard method that runs on the

server before a controller does anything:



```java

public static void requireContainerManagement(HttpSession session) {

&#x20;   requireAnyRole(session, ROLE\_SUPER\_ADMIN, ROLE\_COMPANY\_ADMIN);

}

```



Controllers call the guard first, so a request that is not allowed never reaches

the database. Company scoping works the same way. Staff and company admins get

their `companyId` from the authenticated session, never from a form field, so a

user cannot edit a request parameter to view another company's containers.



I also added CSRF protection to every POST, session timeout handling, and audit

logging for permission denials.



\## Roles



| Role | Purpose |

|---|---|

| Super Admin | Platform-wide administration, company approval |

| Company Admin | Manages their own company, users and pricing |

| Operations Staff | Container operations and allocation |

| Finance Staff | Pricing review and pricing audit |

| Customer | Views their own containers and final prices |



\## Access matrix



Enforced server-side in `Module3Authorization`. The JSPs hide links a user

cannot use, but the real check happens in Java.



| Capability | Super Admin | Company Admin | Operations | Finance | Customer |

|---|:---:|:---:|:---:|:---:|:---:|

| Container catalogue | Yes | Yes | Yes | Yes | Own only |

| Container management (add / edit / delete) | Yes | Yes | - | - | - |

| Allocation and release | Yes | Yes | Yes | - | - |

| Pricing view | Yes | Yes | - | Yes | Final price only |

| Pricing rules (create / update) | Yes | Yes | - | - | - |

| Pricing audit trail | Yes | Yes | - | Yes | - |

| Demand forecast | Yes | Yes | - | - | - |



\## Security



\- \*\*Passwords\*\* are hashed with BCrypt (cost factor 12) and verified with

&#x20; `BCrypt.checkpw`. The database rejects any value that is not a valid BCrypt

&#x20; hash, so plaintext passwords cannot be stored by mistake.

\- \*\*CSRF\*\* - a per-session token is generated on first use and validated

&#x20; centrally in the front controller before any action runs.

\- \*\*Sessions\*\* - HttpOnly cookies, 30 minute timeout. On successful login the

&#x20; old session is invalidated and a fresh session with a new CSRF token is

&#x20; created, which prevents session fixation.

\- \*\*Single Sign-On\*\* - HMAC-SHA256 signed token with a 5 minute validity window.

&#x20; Module 3 rejects anything with a bad signature or an expired timestamp.

\- \*\*Audit trail\*\* - every permission denial is written to `audit\_log` with the

&#x20; user, the attempted action, the IP address and a timestamp.

\- \*\*Secrets\*\* - database credentials, the SSO shared secret and the SMTP

&#x20; credentials are all read from environment variables. Nothing sensitive is

&#x20; stored in the repository.



\## Tech stack



\- Java 8, Java Servlets 3.1, JSP

\- JDBC with MySQL Connector/J

\- MySQL 8 / MariaDB 10.4

\- Apache Tomcat 8.5

\- Eclipse IDE for Enterprise Java Developers

\- Bootstrap 5 and custom CSS for the interface

\- jBCrypt for password hashing



\## Getting started



\### Requirements



\- JDK 8

\- Apache Tomcat 8.5

\- MySQL 8 or MariaDB 10.4

\- Eclipse IDE for Enterprise Java Developers



\### 1. Create the database



```bash

mysql -u root -p -e "CREATE DATABASE logistics\_db"

mysql -u root -p logistics\_db < database/schema.sql

```



`schema.sql` contains the table definitions, the stored procedures and the two

validation triggers. It contains structure only, no data.



\### 2. Import the projects



In Eclipse: \*\*File -> Import -> General -> Existing Projects into Workspace\*\*,

then select the `NLogisticsImportExport` and `NLogisticsModule3` folders.



Both projects target Java 8 and the Tomcat 8.5 runtime. If Eclipse shows a

build path error, open the project properties and point the JRE and server

runtime at your own installation.



\### 3. Configure the environment



The applications read their configuration from environment variables. For

Tomcat, create `<TOMCAT\_HOME>/bin/setenv.bat`:



```bat

set NLOGISTICS\_SSO\_SECRET=replace-with-a-long-random-string

set NLOGISTICS\_DB\_URL=jdbc:mysql://localhost:3306/logistics\_db

set NLOGISTICS\_DB\_USER=root

set NLOGISTICS\_DB\_PASSWORD=

```



The SSO secret must be identical in both applications, otherwise Module 3 will

reject every token.



\### 4. Deploy and run



Deploy \*\*Module 1 first\*\*, then Module 3, and start Tomcat on port 8081.



Open <http://localhost:8081/NLogisticsImportExport/>



You will need a Super Admin account before you can approve companies. Create one

directly in the database, or register a company and approve it from an existing

administrator account.



\## Configuration



| Variable | Required | Default | Purpose |

|---|---|---|---|

| `NLOGISTICS\_SSO\_SECRET` | Yes | none | HMAC key shared by both applications |

| `NLOGISTICS\_DB\_URL` | No | `jdbc:mysql://localhost:3306/logistics\_db` | JDBC connection URL |

| `NLOGISTICS\_DB\_USER` | No | `root` | Database user |

| `NLOGISTICS\_DB\_PASSWORD` | No | empty | Database password |

| `NLOGISTICS\_SMTP\_HOST` | No | none | SMTP host for password reset email |

| `NLOGISTICS\_SMTP\_PORT` | No | none | SMTP port (465 for Gmail SSL) |

| `NLOGISTICS\_SMTP\_USER` | No | none | SMTP username |

| `NLOGISTICS\_SMTP\_PASS` | No | none | SMTP password |

| `NLOGISTICS\_SMTP\_FROM` | No | none | Sender address |



If the SMTP variables are not set, password reset codes are printed to the

Tomcat console instead of being emailed. That is intentional for local

development.



\## Project structure



```

N-Logistics/

├── database/

│   └── schema.sql              tables, stored procedures, triggers

├── docs/                       screenshots and notes

├── NLogisticsImportExport/     Module 1

│   ├── src/

│   │   ├── controller/         servlets, front controller, auth, CSRF

│   │   ├── operations/         operation interfaces

│   │   ├── implementors/       JDBC implementations

│   │   ├── model/              data classes

│   │   └── db\_config/          connection factory

│   └── WebContent/WEB-INF/views/

└── NLogisticsModule3/          Module 3

&#x20;   ├── src/

&#x20;   │   ├── controller/         servlets, Module3Authorization, SSO

&#x20;   │   ├── operations/

&#x20;   │   ├── implementors/

&#x20;   │   ├── model/

&#x20;   │   └── db\_config/

&#x20;   └── WebContent/WEB-INF/views/

```



\## Known limitations



\- No automated tests. Everything was verified manually through the browser.

\- `schema.sql` contains structure only. No user accounts are included, so a

&#x20; Super Admin has to be created before the application is usable.

\- Business logic is split between Java and MySQL stored procedures, which makes

&#x20; it harder to follow than a single-layer design.

\- A few classes are larger than they should be. `ContainerController` is around

&#x20; 1400 lines and several JSPs carry their own styling.

\- Module 2 of the original project is not included in this repository.

\- `getCompaniesForManagement()` in Module 1 is unused and points at a stored

&#x20; procedure that does not exist. It is not called anywhere, so it has no effect

&#x20; at runtime.



\## What I learned



Working on this project showed me how the pieces of a real Java web application

fit together: how a servlet container handles sessions, how authorization has to

be enforced on the server rather than hidden in the UI, and how two applications

can trust each other without sharing a session.



It also taught me that integration is the hard part of group work. Agreeing on a

token format and a database schema early saved a lot of rework later.



\## Note



This is an internship group project. My individual contribution was Module 3 and

its RBAC implementation. The repository is shared to document what I built and

what I learned.

