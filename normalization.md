# **Database Normalization – ALX Airbnb Database**

## **Objective**

To ensure the **Airbnb database schema** is fully normalized up to the **Third Normal Form (3NF)** by identifying redundancies and dependencies, then refining table structures accordingly.

---

## **1. Understanding Normalization**

Normalization is the process of structuring a relational database to **reduce redundancy** and **improve data integrity**.

The main stages applied here are:

1. **First Normal Form (1NF):**
    
    - Ensure atomic (indivisible) attributes.
        
    - Eliminate repeating groups.
        
    - Assign a **primary key** to each table.
        
2. **Second Normal Form (2NF):**
    
    - Ensure every non-key attribute depends on the **whole primary key** (no partial dependency).
        
    - Applies only to tables with composite keys.
        
3. **Third Normal Form (3NF):**
    
    - Remove **transitive dependencies** (non-key attributes depending on other non-key attributes).
        
    - Ensure all attributes depend only on the primary key.
        

---

## **2. Review of Current Entities**

### **User**

|Attribute|Notes|
|---|---|
|user_id|Primary Key|
|first_name, last_name, email, password_hash, phone_number, role|All directly depend on `user_id`.|
|✅ **Status:** In 3NF — no redundancy or transitive dependency.||

---

### **Property**

|Attribute|Notes|
|---|---|
|property_id|Primary Key|
|host_id|Foreign Key → User(user_id)|
|name, description, location, price_per_night|All depend solely on `property_id`.|
|created_at, updated_at|Metadata; no redundancy.|
|✅ **Status:** In 3NF — fully dependent on `property_id`.||

---

### **Booking**

|Attribute|Notes|
|---|---|
|booking_id|Primary Key|
|property_id, user_id|Foreign Keys|
|start_date, end_date, total_price, status, created_at|All depend solely on `booking_id`.|
|No partial or transitive dependencies.||
|✅ **Status:** In 3NF.||

---

### **Payment**

|Attribute|Notes|
|---|---|
|payment_id|Primary Key|
|booking_id|Foreign Key|
|amount, payment_date, payment_method|Depend only on `payment_id`.|
|No transitive relationships (e.g., user or property details are not stored here).||
|✅ **Status:** In 3NF.||

---

### **Review**

|Attribute|Notes|
|---|---|
|review_id|Primary Key|
|property_id, user_id|Foreign Keys|
|rating, comment, created_at|Depend only on `review_id`.|
|Rating range handled via constraint, not derived from another field.||
|✅ **Status:** In 3NF.||

---

### **Message**

|Attribute|Notes|
|---|---|
|message_id|Primary Key|
|sender_id, recipient_id|Foreign Keys (User table)|
|message_body, sent_at|Depend only on `message_id`.|
|No transitive dependency — sender/recipient details are referenced via IDs.||
|✅ **Status:** In 3NF.||

---

## **3. Normalization Steps Summary**

|Normal Form|Action Taken|Example|
|---|---|---|
|**1NF**|Removed repeating data, ensured atomic columns.|Split user names into `first_name` and `last_name`.|
|**2NF**|Ensured all non-key attributes depend on the entire primary key.|Bookings and Payments depend only on `booking_id` / `payment_id`.|
|**3NF**|Removed transitive dependencies.|Kept user details separate from Property and Booking tables.|

---

## **4. Redundancy & Dependency Analysis**

|Issue|Resolution|
|---|---|
|Possible duplication of user data across properties or bookings|Ensured all references use **foreign keys** only.|
|Repeated host info in properties|Host details normalized into **User** table.|
|Payment details tied to booking only (not duplicated in multiple places)|Maintained **1-to-1** relationship with Booking.|
|Reviews linked directly to user and property|No derived fields; maintains data integrity.|

---

## **5. Final Schema Status**

✅ **All tables (User, Property, Booking, Payment, Review, Message) are in Third Normal Form (3NF).**

- No redundant data.
    
- All non-key attributes depend only on primary keys.
    
- All relationships handled via foreign keys.
    
- Schema optimized for data consistency and scalability.
    

---

## **6. Benefits of 3NF Implementation**

- Prevents update, insert, and delete anomalies.
    
- Ensures data integrity through proper key dependencies.
    
- Simplifies maintenance and improves scalability.
    
- Makes joins and queries efficient and logically consistent.
