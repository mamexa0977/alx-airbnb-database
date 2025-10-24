
# ALX Airbnb Clone Database Schema

This repository contains the SQL schema for an Airbnb clone project. The schema defines tables, constraints, and indexes necessary to manage users, properties, bookings, payments, reviews, and messaging between users.

---

## Tables Overview

### 1. **User**
Stores user information for guests, hosts, and admins.

- **Columns:**
  - `user_id` (UUID, PK)
  - `first_name` (VARCHAR)
  - `last_name` (VARCHAR)
  - `email` (VARCHAR, unique)
  - `password_hash` (VARCHAR)
  - `phone_number` (VARCHAR)
  - `role` (ENUM: `guest`, `host`, `admin`)
  - `created_at` (TIMESTAMP, default current time)

- **Indexes:**
  - `idx_user_email` – fast lookup by email

---

### 2. **Property**
Stores information about properties listed by hosts.

- **Columns:**
  - `property_id` (UUID, PK)
  - `host_id` (UUID, FK → User.user_id)
  - `name` (VARCHAR)
  - `description` (TEXT)
  - `location` (VARCHAR)
  - `price_per_night` (DECIMAL)
  - `created_at` (TIMESTAMP)
  - `updated_at` (TIMESTAMP)

- **Indexes:**
  - `idx_property_host_id` – quick lookup by host
  - `idx_property_location` – search properties by location

---

### 3. **Booking**
Tracks property bookings made by users.

- **Columns:**
  - `booking_id` (UUID, PK)
  - `property_id` (UUID, FK → Property.property_id)
  - `user_id` (UUID, FK → User.user_id)
  - `start_date` (DATE)
  - `end_date` (DATE)
  - `total_price` (DECIMAL)
  - `status` (ENUM: `pending`, `confirmed`, `canceled`)
  - `created_at` (TIMESTAMP)

- **Indexes:**
  - `idx_booking_property_id` – fast joins with properties
  - `idx_booking_user_id` – fast joins with users

---

### 4. **Payment**
Stores payments related to bookings.

- **Columns:**
  - `payment_id` (UUID, PK)
  - `booking_id` (UUID, FK → Booking.booking_id)
  - `amount` (DECIMAL)
  - `payment_date` (TIMESTAMP)
  - `payment_method` (ENUM: `credit_card`, `paypal`, `stripe`)

- **Indexes:**
  - `idx_payment_booking_id` – lookup payments by booking

---

### 5. **Review**
Allows users to leave reviews for properties.

- **Columns:**
  - `review_id` (UUID, PK)
  - `property_id` (UUID, FK → Property.property_id)
  - `user_id` (UUID, FK → User.user_id)
  - `rating` (INTEGER, 1–5)
  - `comment` (TEXT)
  - `created_at` (TIMESTAMP)

- **Indexes:**
  - `idx_review_property_id` – filter reviews by property
  - `idx_review_user_id` – filter reviews by user

---

### 6. **Message**
Handles messaging between users.

- **Columns:**
  - `message_id` (UUID, PK)
  - `sender_id` (UUID, FK → User.user_id)
  - `recipient_id` (UUID, FK → User.user_id)
  - `message_body` (TEXT)
  - `sent_at` (TIMESTAMP)

- **Indexes:**
  - `idx_message_sender_id` – retrieve messages by sender
  - `idx_message_recipient_id` – retrieve messages by recipient

---

## Notes

- All UUIDs are generated automatically using `gen_random_uuid()`.
- Foreign key constraints use `ON DELETE CASCADE` to maintain referential integrity.
- Timestamps are automatically managed with `CURRENT_TIMESTAMP`.
- Indexes are added for commonly queried fields to improve performance.

---

## Usage

1. Run the SQL script in a PostgreSQL database.
2. The tables will be created in order, with constraints and indexes applied.
3. Start developing your Airbnb clone application using this schema.

---

## License

This project is open-source and free to use for educational purposes.
