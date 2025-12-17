# TAO CE – How to Install
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
 - Download the `docker-compose.tao-ce.yaml` file:  
   <https://gist.github.com/tao-community-edition/5ac924d5021aa2d7d3635064edc0e752>
 - Open a terminal/shell and go to the folder where you saved the file.
 - Run:

   ```bash
   docker compose -f docker-compose.tao-ce.yaml up -d
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
![TAO CE Login](docs/images/login.png)
---

## 2. Immediate Action Required: Change Passwords

For security, you **must** change the default passwords immediately.

### 2.1 Change the Admin Password

1. Click your **user avatar** (top right).
2. Under **My account**, click **My user**.
3. Click **Change password**.
4. Choose a secure password (at least 8 characters, with at least one lowercase, one uppercase, and one number or symbol).
5. Click **Save changes**.

### 2.2 Change Test-Taker Passwords (users: `demo01` – `demo05`, default password: `password`)

1. Go to the **Users** tile.
2. Locate the users with the **Test taker** role (`demo01` – `demo05`).
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
   - Create folders and items as needed. Check the [User Guide](https://userguide.taotesting.com/user-documentation/latest/public/creating-a-test-item) on how to do this.
3. Switch to the **Tests** tab.
   - Create a new test. Check the [User Guide](https://userguide.taotesting.com/user-documentation/latest/public/creating-a-test) on how to do this.
   - Add the items you created.
4. Publish the test as a new **delivery** by selecting it and clicking **Publish**. Check the [User Guide](https://userguide.taotesting.com/user-documentation/latest/public/publishing-a-test) on how to do this.


---

### 4.2 Create a Group

A **group** is a collection of users, each with their own role. They are typically used to group together test-takers, according to various common criteria, such as belonging to the same classroom.

Steps:

1. From the Portal, click on the **Groups** tile.
2. Click **Create group**.
3. Fill in the required field:
   - **Name**
4. Switch to the **Users** subtab and select from the existing list of users those to add in the group as test-takers
5. Save the group.

You can read more information about managing groups in the [User Guide](https://userguide.taotesting.com/user-documentation/latest/public/group-management).

---

### 4.3 Create a Session

A **session** connects:

- a **Delivery** (published test), and  
- a **Group** (test-takers).

Steps:

1. From the test authoring area, click the back arrow to return to the **Portal**.
2. Click the **Sessions** tile.
3. Click **Create session**.
4. Fill in the required fields:
   - **Session name**
   - **Group** (you can use the group you created above)
   - **Delivery** (select the delivery you published earlier)
5. Save the session.

You can read more information about managing sessions in the [User Guide](https://userguide.taotesting.com/user-documentation/latest/public/sessions-management).

---

### 4.4 Simulate a Test-Taker

1. Log out from the admin user.
2. *For your convenience, several users are already provisioned, to be used as test-takers.* Log in as one of the test-taker users whose password you changed (e.g., fk01).
3. In the session list, find your newly created session.
4. Click **Start**.
5. Take the test to completion.

---

### 4.5 Evaluate Test Results

1. Log out from the test-taker account.
2. Log back in as the **admin** user.
3. Go to **Sessions**.
4. Find your session and click **Enter session**.
5. For any test-taker who completed the session, click **Review test** to see their results.

---

## 5. Other Relevant Resources

- [TAO User Guide](https://userguide.taotesting.com/user-documentation/latest/public/)
- [TAO Knowledge Base](https://knowledge.taotesting.com/)
- [TAO Community Forum](https://forum.community.taotesting.com/)

---

## 6. Known Issues for version `2025.10`

The following issues are known in the current TAO CE version (`2025.10`). They are planned to be addressed in one of the following releases.

| Issue | Workaround / Notes |
| - | - |
| Text-to-speech is not working for the test-taker | No workaround available yet.|
| **Usage** tab for items is not working | No workaround available yet. |
| **Item statistics** tab for items is not working | No workaround available yet. |
