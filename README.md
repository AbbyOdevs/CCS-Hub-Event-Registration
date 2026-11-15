# CCS Event Hub

A web-based event management and registration system for the **College of Computer Studies (CCS), Laguna State Polytechnic University**. Administrators create and manage events, and students browse, register, and track their attendance, all in one place.

Built with **Flask (Python)** and **MySQL**, with a plain HTML/CSS/JavaScript front end. The back end is organized around the four pillars of Object-Oriented Programming, and the admin side uses classic data structures and algorithms (hash table, merge sort, binary search, queue).

---

## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [Getting Started](#getting-started)
5. [Configuration](#configuration)
6. [Database](#database)
7. [Usage Guide](#usage-guide)
8. [API Reference](#api-reference)
9. [OOP Concepts Applied](#oop-concepts-applied)
10. [Data Structures and Algorithms](#data-structures-and-algorithms)
11. [Security Notes](#security-notes)
12. [Authors](#authors)

---

## Features

### Participant (student)
- Sign up and log in (student ID, name, email, password).
- Save course, year level, and section once in **My Profile**. It is reused automatically for every registration.
- Browse upcoming events, filter by category, and search by title, location, or description.
- Register for an event (answer **Yes** or **No** to "Will you attend?").
- **Waitlist:** if an event is full, the student joins a queue and is registered automatically when a spot opens.
- Cancel a registration (not allowed after attending or once the event has finished).
- **Notifications bell:** new events, event updates, cancellations, registration confirmations, waitlist promotions, and automatic "starts within 24 hours" reminders.
- **Attended Events** page listing events the admin marked them present for.

### Administrator
- Dashboard with totals for events, student accounts, registrations, and attendance.
- Create, edit, and delete events. Past dates are blocked, and capacity cannot be lowered below the number of reserved spots.
- Mark an event as **finished** or **reopen** it. Events also finish automatically once their date and time pass.
- View and filter all registrations by event, year level, and section.
- **Attendance management:** mark each registrant as attended or absent.
- **Printable attendance sheets:** grouped by year, course, and section, with signature column (official list for finished events).
- Manage student accounts (delete an account together with its records).
- **Database backup:** export the whole database as a `.sql` file or restore from one. A safety copy is saved on the server before every import.

### General
- Single login form for both roles. Admins are redirected to `/admin`.
- Browser Back/Forward navigation support, no-cache headers, and field-level form validation.
- Responsive purple/gold theme.

---

## Tech Stack

| Layer      | Technology                                      |
|------------|--------------------------------------------------|
| Back end   | Python 3, Flask 3                                |
| Database   | MySQL (via `mysql-connector-python`, pooled)     |
| Front end  | HTML5, CSS3, vanilla JavaScript                  |
| Auth       | Flask sessions, Werkzeug password hashing        |
| Config     | `python-dotenv` (`.env` file)                    |

---

## Project Structure

```
ccs-event-hub/
├── app.py                  # Flask app: models, repositories, services, routes
├── backup_route.py         # Database export/import endpoints
├── dsa_features.py         # merge_sort and WaitlistQueue (server-side DSA)
├── requirements.txt
├── .gitignore              # keeps .env out of Git
├── .env                    # your local settings (NOT committed)
├── templates/
│   ├── index.html          # login/sign-up + participant app
│   ├── admin.html          # admin dashboard
│   └── attendance_sheet.html   # printable attendance sheet
└── static/
    ├── styles.css          # participant + login styles
    ├── index.css           # participant page theme overrides
    ├── admin.css           # admin styles
    ├── script.js           # participant page logic
    ├── admin.js            # admin page logic
    ├── dsa.js              # client-side DSA (hash table, sorts, search, stack)
    ├── backup.js           # Settings > Database Backup UI
    ├── ccs-logo.png        # CCS logo
    └── school.jpg          # login page background photo
```

> Flask looks for `templates/` and `static/` next to `app.py`, so keep this layout.

---

## Getting Started

### Prerequisites
- Python 3.10 or newer
- MySQL Server 8.x (or MariaDB)
- Git

### 1. Clone the repository
```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
```

### 2. Create a virtual environment and install dependencies
```bash
python -m venv venv

# Windows
venv\Scripts\activate
# macOS / Linux
source venv/bin/activate

pip install -r requirements.txt
```

### 3. Create the MySQL database and user
```sql
CREATE DATABASE event_hub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'event_admin'@'localhost' IDENTIFIED BY 'your-password-here';
GRANT ALL PRIVILEGES ON event_hub.* TO 'event_admin'@'localhost';
FLUSH PRIVILEGES;
```
Then create the tables (see [Database](#database)).

### 4. Create your `.env` file
Create a file named `.env` in the project root (see [Configuration](#configuration)).

### 5. Run the app
```bash
python app.py
```
Open **http://localhost:5000** in your browser. On start-up the app checks the MySQL connection and adds the `course`, `section`, and `year_level` columns to `users` if they are missing.

---

## Configuration

Settings are read from environment variables (loaded from `.env`). Every value has a development default, but **change the defaults before deploying anywhere public.**

```env
# Administrator login
ADMIN_EMAIL=admin@ccs.local
ADMIN_PASSWORD=change-this-password

# Flask session signing key (use a long random string)
SECRET_KEY=change-this-to-a-long-random-string

# Set to true when served over HTTPS
COOKIE_SECURE=false

# Time zone offset from UTC in hours (8 = Philippines)
APP_UTC_OFFSET_HOURS=8

# MySQL connection
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=event_admin
DB_PASSWORD=your-password-here
DB_NAME=event_hub
```

| Variable               | Default            | Purpose                                   |
|------------------------|--------------------|-------------------------------------------|
| `ADMIN_EMAIL`          | `admin@ccs.local`  | Email used to log in as administrator     |
| `ADMIN_PASSWORD`       | `ccs2026`          | Administrator password                    |
| `SECRET_KEY`           | `dev-secret-change-me` | Signs session cookies                 |
| `COOKIE_SECURE`        | `false`            | Send cookies over HTTPS only              |
| `APP_UTC_OFFSET_HOURS` | `8`                | Local time zone for event timing          |
| `DB_HOST` / `DB_PORT`  | `127.0.0.1` / `3306` | MySQL server                            |
| `DB_USER` / `DB_PASSWORD` | `event_admin` / `admin123` | MySQL credentials             |
| `DB_NAME`              | `event_hub`        | Database name                             |

---

## Database

The app uses four tables. The columns below are the ones the code reads and writes.

| Table           | Columns |
|-----------------|---------|
| `users`         | `id`, `student_id`, `name`, `email`, `password_hash`, `course`, `section`, `year_level`, `created_at` |
| `events`        | `id`, `title`, `category`, `event_date`, `event_time`, `location`, `capacity`, `description`, `status` (`upcoming` / `reopened` / `finished`), `finished_at`, `created_at` |
| `registrations` | `id`, `event_id`, `user_id`, `student_id`, `name`, `email`, `course`, `section`, `year_level`, `attending` (`yes` / `no`), `quantity`, `attendance_status` (`registered` / `attended` / `absent`), `registered_at` |
| `notifications` | `id`, `user_id`, `event_id`, `type`, `message`, `is_read`, `created_at` |

Ids are short prefixed strings (`usr…`, `ev…`, `reg…`, `n…`). Timestamps are stored in UTC and converted for display.

> **Tip:** to share your exact schema, use **Admin > Settings > Export Database** and save the result as `schema.sql` (or `database_backup.sql`) in the repository so others can restore it.

---

## Usage Guide

**Administrator**
1. Go to `/` and log in with `ADMIN_EMAIL` and `ADMIN_PASSWORD`. You are redirected to `/admin`.
2. **Events > Add Event** to publish an event. Students are notified automatically.
3. After the event, open **Attendance** and mark participants as attended or absent.
4. Click **Attendance Sheet** on an event to print or save the sheet as PDF.
5. Use **Settings** to export or restore the database.

**Student**
1. Click **Create an Account**, then log in.
2. Open **My Profile** and save your course, year level, and section.
3. Go to **Browse Events**, click an event, choose Yes or No, and confirm.
4. Check **My Registrations**, **Attended Events**, and the notification bell.

---

## API Reference

All responses are JSON. Errors return `{ "error": "message" }` with the matching HTTP status.

### Auth
| Method | Endpoint              | Access | Description |
|--------|-----------------------|--------|-------------|
| POST   | `/api/auth/register`  | Public | Create a participant account |
| POST   | `/api/auth/login`     | Public | Log in (admin or participant) |
| GET    | `/api/auth/me`        | Public | Current session info |
| POST   | `/api/auth/logout`    | Any    | Log out |
| POST   | `/api/admin/logout`   | Any    | Log out (admin page) |

### Events
| Method | Endpoint                        | Access | Description |
|--------|---------------------------------|--------|-------------|
| GET    | `/api/events`                   | Public | List all events |
| GET    | `/api/categories`               | Public | List event categories |
| POST   | `/api/events`                   | Admin  | Create an event |
| PUT    | `/api/events/<id>`              | Admin  | Update an event |
| DELETE | `/api/events/<id>`              | Admin  | Delete an event (and its registrations/notifications) |
| POST   | `/api/events/<id>/finish`       | Admin  | Mark as finished |
| POST   | `/api/events/<id>/reopen`       | Admin  | Reopen an event |
| GET    | `/api/admin/events/<id>/attendance-sheet` | Admin | Printable attendance sheet |

### Participant
| Method | Endpoint                              | Description |
|--------|---------------------------------------|-------------|
| PUT    | `/api/profile`                        | Save course, year, section |
| POST   | `/api/events/<id>/register`           | Register (`{"attending": "yes" \| "no"}`) or join the waitlist |
| GET    | `/api/my-registrations`               | List my registrations |
| POST   | `/api/registrations/<id>/cancel`      | Cancel a registration |
| GET    | `/api/notifications`                  | List notifications and unread count |
| POST   | `/api/notifications/read-all`         | Mark all as read |
| POST   | `/api/notifications/<id>/read`        | Mark one as read |

### Admin
| Method | Endpoint                                      | Description |
|--------|-----------------------------------------------|-------------|
| GET    | `/api/admin/users`                            | List student accounts |
| DELETE | `/api/admin/users/<id>`                       | Delete a student account |
| GET    | `/api/admin/registrations`                    | List all registrations |
| POST   | `/api/admin/registrations/<id>/attendance`    | Set attendance (`registered` / `attended` / `absent`) |
| GET    | `/api/admin/backup/export`                    | Download database as `.sql` |
| POST   | `/api/admin/backup/import`                    | Restore database from a `.sql` file |

---

## OOP Concepts Applied

`app.py` is structured to demonstrate the four pillars of OOP.

| Pillar            | Where it is used |
|-------------------|------------------|
| **Encapsulation** | `BaseModel` stores data in a private `__data` attribute and exposes it only through properties, so password hashes never leave the model. `Database` hides its connection pool, `EventForm` exposes read-only properties, and `RegistrationService` keeps the waitlist private. |
| **Abstraction**   | Abstract base classes (`ABC`) declare *what* must be done: `BaseModel`, `Account`, `Event`, `Registration`, `Notification`, `Repository`, `Validator`, `AccessPolicy`, `EventForm`, `ReservationResult`. |
| **Inheritance**   | `BaseModel → Account → Participant, Admin`; `BaseModel → Event → UpcomingEvent, ReopenedEvent, FinishedEvent`; `Notification → EventNotification → …`; `Repository → UserRepository, EventRepository, …`; `ApiError → ValidationError, NotFoundError, ConflictError, …`. |
| **Polymorphism**  | The same call behaves differently per object: `event.is_finished()`, `registration.spots_used()`, `account.verify_password()`, `notification.message()`, `validator.validate()`, `policy.check()`, `result.to_response()`. |

Other patterns used: **Repository** and **Unit of Work** (database access in one transaction), **Service layer** (business rules kept out of routes), **Factory methods** (`Event.from_row`, `Registration.from_row`), **custom exceptions** mapped to HTTP responses, and **decorators** for access control (`@requires(ADMIN_ONLY)`).

---

## Data Structures and Algorithms

| Concept | Where | Purpose |
|---------|-------|---------|
| **Merge sort** (O(n log n), stable) | `dsa_features.py` (server) and `dsa.js` (browser) | Orders attendance-sheet rows by year, course, section, and name; sorts participants by name |
| **Queue (FIFO)** | `WaitlistQueue` in `dsa_features.py` | Promotes the first waiting student when a spot opens |
| **Hash table** (separate chaining, djb2) | `HashTable` in `dsa.js` | O(1) average lookup by id or student ID |
| **Binary search** (`lowerBound`) | `dsa.js` | Prefix search on the name-sorted participant list |
| **Linear search** | `dsa.js` | Fallback substring search |
| **Stack (LIFO)** | `UndoStack` in `dsa.js` | Undo stack utility |
| **Bubble sort** | `dsa.js` | Kept for comparison in the benchmark |

To run the performance comparison, open the browser console on the admin page and call:
```js
DSA.runBenchmark()
```

---

## Security Notes

- Student passwords are hashed with Werkzeug (`generate_password_hash`) and are never sent to the browser.
- The admin password comparison uses `hmac.compare_digest` to avoid timing attacks.
- Session cookies are `HttpOnly` and `SameSite=Lax`. Set `COOKIE_SECURE=true` behind HTTPS.
- All SQL uses parameterized queries.
- Admin routes are protected by an access-policy decorator, and user input is validated on both the client and the server.
- `.env` is listed in `.gitignore`. **Never commit real passwords or secret keys.**
- `app.run(debug=True, host="0.0.0.0")` is for development only. Use a production WSGI server (for example Gunicorn or Waitress) and `debug=False` when deploying.

---

## Authors

- **Your Name** — role / student number
- **Teammate Name** — role / student number

Course / Subject: _Subject name here_
Instructor: _Instructor name here_
College of Computer Studies, Laguna State Polytechnic University

---

## License

This project was created for academic purposes.
