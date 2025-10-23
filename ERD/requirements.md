# **ER Diagram Requirements – ALX Airbnb Database**

## **1. Entities and Attributes**

### **User**

| Attribute     | Type                           | Constraints / Description |
| ------------- | ------------------------------ | ------------------------- |
| user_id       | UUID                           | **Primary Key**, Indexed  |
| first_name    | VARCHAR                        | NOT NULL                  |
| last_name     | VARCHAR                        | NOT NULL                  |
| email         | VARCHAR                        | **UNIQUE**, NOT NULL      |
| password_hash | VARCHAR                        | NOT NULL                  |
| phone_number  | VARCHAR                        | NULL                      |
| role          | ENUM('guest', 'host', 'admin') | NOT NULL                  |
| created_at    | TIMESTAMP                      | DEFAULT CURRENT_TIMESTAMP |

---

### **Property**

|Attribute|Type|Constraints / Description|
|---|---|---|
|property_id|UUID|**Primary Key**, Indexed|
|host_id|UUID|**Foreign Key**, references **User(user_id)**|
|name|VARCHAR|NOT NULL|
|description|TEXT|NOT NULL|
|location|VARCHAR|NOT NULL|
|price_per_night|DECIMAL|NOT NULL|
|created_at|TIMESTAMP|DEFAULT CURRENT_TIMESTAMP|
|updated_at|TIMESTAMP|ON UPDATE CURRENT_TIMESTAMP|

---

### **Booking**

|Attribute|Type|Constraints / Description|
|---|---|---|
|booking_id|UUID|**Primary Key**, Indexed|
|property_id|UUID|**Foreign Key**, references **Property(property_id)**|
|user_id|UUID|**Foreign Key**, references **User(user_id)**|
|start_date|DATE|NOT NULL|
|end_date|DATE|NOT NULL|
|total_price|DECIMAL|NOT NULL|
|status|ENUM('pending', 'confirmed', 'canceled')|NOT NULL|
|created_at|TIMESTAMP|DEFAULT CURRENT_TIMESTAMP|

---

### **Payment**

|Attribute|Type|Constraints / Description|
|---|---|---|
|payment_id|UUID|**Primary Key**, Indexed|
|booking_id|UUID|**Foreign Key**, references **Booking(booking_id)**|
|amount|DECIMAL|NOT NULL|
|payment_date|TIMESTAMP|DEFAULT CURRENT_TIMESTAMP|
|payment_method|ENUM('credit_card', 'paypal', 'stripe')|NOT NULL|

---

### **Review**

|Attribute|Type|Constraints / Description|
|---|---|---|
|review_id|UUID|**Primary Key**, Indexed|
|property_id|UUID|**Foreign Key**, references **Property(property_id)**|
|user_id|UUID|**Foreign Key**, references **User(user_id)**|
|rating|INTEGER|CHECK (rating BETWEEN 1 AND 5), NOT NULL|
|comment|TEXT|NOT NULL|
|created_at|TIMESTAMP|DEFAULT CURRENT_TIMESTAMP|

---

### **Message**

|Attribute|Type|Constraints / Description|
|---|---|---|
|message_id|UUID|**Primary Key**, Indexed|
|sender_id|UUID|**Foreign Key**, references **User(user_id)**|
|recipient_id|UUID|**Foreign Key**, references **User(user_id)**|
|message_body|TEXT|NOT NULL|
|sent_at|TIMESTAMP|DEFAULT CURRENT_TIMESTAMP|

---

## **2. Relationships Between Entities**

|Relationship|Description|
|---|---|
|**User → Property**|One **User (host)** can have many **Properties**.|
|**User → Booking**|One **User (guest)** can make many **Bookings**.|
|**Property → Booking**|One **Property** can have many **Bookings**.|
|**Booking → Payment**|One **Booking** can have one or many **Payments**.|
|**User → Review**|One **User (guest)** can post many **Reviews**.|
|**Property → Review**|One **Property** can have many **Reviews**.|
|**User → Message (sender/recipient)**|Users can send and receive multiple messages.|

**Cardinality Summary:**

- User ↔ Property → **1 : N**
    
- User ↔ Booking → **1 : N**
    
- Property ↔ Booking → **1 : N**
    
- Booking ↔ Payment → **1 : 1** (or **1 : N**, depending on business logic)
    
- Property ↔ Review → **1 : N**
    
- User ↔ Message → **1 : N (both sender and recipient)**
    

---

## **3. Constraints Overview**

### **User**

- Unique constraint on `email`.
    
- Non-null constraints on essential fields.
    

### **Property**

- Foreign key constraint on `host_id`.
    
- Non-null constraints on main attributes.
    

### **Booking**

- Foreign keys: `property_id`, `user_id`.
    
- `status` must be one of **pending**, **confirmed**, or **canceled**.
    

### **Payment**

- Foreign key constraint on `booking_id`.
    
- Ensures payments link to valid bookings.
    

### **Review**

- Rating range: 1–5.
    
- Foreign keys on `property_id` and `user_id`.
    

### **Message**

- Foreign keys on both `sender_id` and `recipient_id`.
    

---

## **4. Indexing**

- **Primary Keys:** Automatically indexed.
    
- **Additional Indexes:**
    
    - `email` (User)
        
    - `property_id` (Property, Booking)
        
    - `booking_id` (Booking, Payment)
