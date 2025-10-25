
# ALX Airbnb Clone – Database Seed Script

This SQL script provides **sample seed data** for the **ALX Airbnb Clone** project.  
It populates the database with example users, properties, bookings, payments, reviews, and messages to support **development, testing, and demonstration**.

---

## 📘 Overview

The script inserts mock data to simulate a real-world Airbnb environment.  
It assumes that the database schema (from `schema.sql`) has already been created.

---

## 🧩 Data Sections

### 1️⃣ Users
Represents system users: guests, hosts, and admin.

**Sample entries:**
| First Name | Last Name | Role  | Email                 | Phone           |
|-------------|------------|-------|-----------------------|-----------------|
| Abel        | Kebede     | guest | abel@example.com      | +251900000001   |
| Sara        | Tadesse    | host  | sara@example.com      | +251900000002   |
| Mahi        | Tesfaye    | host  | mahi@example.com      | +251900000003   |
| Nati        | Mekonnen   | guest | nati@example.com      | +251900000004   |
| Admin       | Root       | admin | admin@alxairbnb.com   | *(none)*        |

---

### 2️⃣ Properties
Lists properties hosted by users with the `host` role.

**Sample entries:**
| Property Name           | Host  | Location              | Price/Night |
|--------------------------|-------|-----------------------|--------------|
| Addis Cozy Apartment     | Sara  | Addis Ababa, Ethiopia | $65.00       |
| Lalibela Heritage Lodge  | Mahi  | Lalibela, Ethiopia    | $120.00      |
| Bahir Dar Lake View      | Mahi  | Bahir Dar, Ethiopia   | $80.00       |

Each property is associated with its host through the `host_id` foreign key.

---

### 3️⃣ Bookings
Represents guest reservations for properties.

**Sample entries:**
| Property ID | User (Guest) | Start Date | End Date   | Total Price | Status     |
|--------------|---------------|-------------|-------------|--------------|-------------|
| 1            | Abel          | 2025-11-10  | 2025-11-15  | $325.00      | confirmed   |
| 2            | Nati          | 2025-12-01  | 2025-12-04  | $240.00      | pending     |

Bookings connect users (guests) to properties through `user_id` and `property_id`.

---

### 4️⃣ Payments
Stores completed or pending payments tied to bookings.

**Sample entries:**
| Booking ID | Amount | Method       |
|-------------|---------|--------------|
| 1           | 325.00  | credit_card  |
| 2           | 240.00  | paypal       |

Each payment links to a specific booking via `booking_id`.

---

### 5️⃣ Reviews
Contains guest feedback about properties after their stays.

**Sample entries:**
| Property ID | User | Rating | Comment                                                |
|--------------|------|---------|--------------------------------------------------------|
| 1            | Abel | 5       | "Amazing place! Clean, comfy, and close to everything." |
| 2            | Nati | 4       | "Beautiful view and great service. Will book again."    |

Ratings are integers between **1** (worst) and **5** (best).

---

### 6️⃣ Messages
Simulates user-to-user messaging between guests and hosts.

**Sample entries:**
| Sender | Recipient | Message                                                                 |
|---------|------------|--------------------------------------------------------------------------|
| Abel    | Sara       | "Hi, I’d like to confirm check-in time for tomorrow."                   |
| Sara    | Abel       | "Sure, check-in starts at 2 PM. Looking forward to hosting you!"         |

Messages use `sender_id` and `recipient_id` as foreign keys referencing the `User` table.

---

## ⚙️ Usage Instructions

1. **Ensure the schema is created** (run `schema.sql` first).
2. Run this script in your **PostgreSQL database**:
   ```sql
   \i seed.sql;
