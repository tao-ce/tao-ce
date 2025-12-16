# TAO CE – How to Install

> **Status:** Work in progress.  
> This document is released together with the final version of TAO CE.

This guide explains how to install TAO Community Edition (TAO CE) using Docker, and what to do next after installation.

---

## 1. Container Installation (Docker)

TAO CE supports container-based deployment using Docker for local development and evaluation.

### 1.1 Prerequisites

- Install Docker: <https://www.docker.com/get-started>  
- If using Docker Desktop, allocate **at least 4 GB of memory**:  
  - **Docker Desktop → Settings → Resources → Memory**

---

### 1.2 Retrieve and Deploy the TAO CE Container

1. The core TAO CE resources are hosted on the `quay.io/tao-ce/tao-ce:latest` registry. Pull and configure the required container:
 - **Remove any previous TAO CE containers, volumes, and images** from Docker if you have installed TAO CE before.
 - Download the `docker-compose.yml` file:  
   <https://drive.google.com/file/d/1wTEZEM69n40NoAI5lAh3VWUIOXg8zVc4/view>
 - Open a terminal/shell and go to the folder where you saved the file.
 - Run:

   ```bash
   docker compose -f docker-compose.yml up -d
   ```

 - Wait for all volumes and containers to be created and started.

![Docker compose output](/docs/images/docker-compose.png)

---

### 1.3 Configure the `hosts` File (Optional but Recommended)

#### Linux and macOS

Edit `/etc/hosts` and add:

```text
0.0.0.0 community.tao.internal
```

#### Windows

Edit `C:\Windows\System32\drivers\etc\hosts` and add:

```text
127.0.0.1 community.tao.internal
```

---

### 1.4 Access TAO CE

Open your browser and go to:

```text
https://community.tao.internal/
```

You may receive a warning about an invalid or missing certificate.

![Certificate warning](/docs/images/chrome-warning.png)

In Chrome, for example:

1. Click **Advanced**.  
2. Click **Proceed to community.tao.internal**.

![Certificate override](/docs/images/chrome-proceed.png)

#### Default login
You may now login with:
```text
Username: admin
Password: password
```
![TAO CE Login](/docs/images/login.png)
---

## 2. Immediate Action Required: Change Passwords

For security, you **must** change the default passwords immediately.

### 2.1 Change the Admin Password

1. Click your **user avatar** (top right).
2. Under **My account**, click **My user**.
3. Click **Change password**.
4. Choose a secure password (at least 8 characters, with at least one lowercase, one uppercase, and one number or symbol).
5. Click **Save changes**.

### 2.2 Change Test-Taker Passwords (fk01–fk05)

1. Go to the **Users** tile.
2. Locate the users with the **Test taker** role (fk01–fk05).
3. For each user, open the context (hamburger) menu → **Edit**.
4. Click **Change password**.
5. Set a secure password (same criteria as above).
6. Click **Save changes**.

---

## 3. Performance Expectations

The following performance was observed in testing:

- **Concurrent users**:  
  - 500 concurrent test-takers  
  - Ramp-up: 25 users per second  
  - All 500 test-takers successfully submitted their tests.

- **Login slowness**:  
  - At **500 concurrent test-takers**: login can take **1–2 minutes**, but eventually succeeds.  
  - At **200 concurrent test-takers**: login time is acceptable (up to **7 seconds**).

---

## 4. What to Do Next

After installation and password changes, follow these steps to create and deliver a simple test.

### 4.1 Prepare Content (Items and Tests)

1. From the Portal, click the **Content bank** tile.
2. Go to the **Items** tab.
   - Create folders and items as needed.
3. Switch to the **Tests** tab.
   - Create a new test.
   - Add the items you created.
4. Publish the test as a new **delivery** by selecting it and clicking **Publish**.

---

### 4.2 Create a Session

A **session** connects:

- a **Delivery** (published test), and  
- a **Group** (test-takers).

Steps:

1. From the test authoring area, click the back arrow to return to the **Portal**.
2. Click the **Sessions** tile.
3. Click **Create session**.
4. Fill in the required fields:
   - **Session name**
   - **Group** (you can use the existing default group)
   - **Delivery** (select the delivery you published earlier)
5. Save the session.

---

### 4.3 Simulate a Test-Taker

1. Log out from the admin user.
2. Log in as one of the test-taker users whose password you changed (e.g., fk01).
3. In the session list, find your newly created session.
4. Click **Start**.
5. Take the test to completion.

---

### 4.4 Evaluate Test Results

1. Log out from the test-taker account.
2. Log back in as the **admin** user.
3. Go to **Sessions**.
4. Find your session and click **Enter session**.
5. For any test-taker who completed the session, click **Review test** to see their results.

---

## 5. Other Relevant Resources

- **TAO User Guide**  
- **TAO Knowledge Base**  
- **TAO Community Forum**  

(Links to be filled in with the official URLs.)

---

## 6. Known Issues

The following issues are known in the current TAO CE version. They are planned to be addressed for the final release.

| Issue                                                                 | Workaround / Notes                                                                                  |
| --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| Files uploaded via a **File Upload** interaction cannot be downloaded | In the window opened when clicking such a file, manually add `https://` in front of the URL.        |
| Recordings from the **Audio PCI** cannot be played after submission  | No workaround available yet.                                                                         |
| Reports do not work (links lead to “Page not found”).                | Not yet available in this version.                                                                  |
| CSV results cannot be downloaded for a session.                      | Not yet available in this version.                                                                  |
| Bulk data import in **TAO Portal** does not work.                    | Not yet available in this version.                                                                  |
| A user with the **Group Manager** role cannot create a session.      | Create sessions using an **admin** user as a workaround.                                            |

---

## 7. Source Code

> **Note**  
> At this time, the supported way to install TAO CE is via the container-based method described above.

We are working on providing:

- full access to the source code,
- an installer, and
- a detailed installation guide.

These will be made available later as part of the TAO CE release.
