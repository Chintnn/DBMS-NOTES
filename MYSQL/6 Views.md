# **Views in SQL - Explained** 🏛️

A **View** in SQL is a **virtual table** that provides an **abstracted** way to access data from one or more tables without directly storing the data itself. It simplifies querying, enhances security, and reduces redundancy.

---

## 🔹 **1. What is a View?**
- A **view** is a **logical table** that allows access to specific data from other tables.
- It contains **no actual data**; instead, it is mapped to a **SELECT query**.
- The tables on which a view is based are called **base tables**.
- When a view is queried, the SQL engine dynamically retrieves data from the base tables.

---

## 🔹 **2. Why Use Views?**
✔ **Security** → Restrict access to sensitive columns or rows.  
✔ **Simplifies Queries** → Reduces complex joins and calculations.  
✔ **Data Abstraction** → Hides underlying table complexity.  
✔ **Reduces Redundant Data** → Prevents unnecessary data duplication.  

---

## 🔹 **3. Creating a View**
### **Syntax:**
```sql
CREATE VIEW view_name AS  
SELECT column1, column2 FROM table_name  
WHERE condition;
```

### **Example:**
Create a view that shows all data from the `customer_master` table:
```sql
CREATE VIEW customer AS  
SELECT * FROM cust_mstr;
```
---

## 🔹 **4. View with Selected Columns**
### **Example:**
Create a view for employees with only `name` and `department`:
```sql
CREATE VIEW employee AS  
SELECT name, dept FROM emp;
```

---

## 🔹 **5. Filtering Data in a View**
### **Example:**
Create a view for employees in **department 20**:
```sql
CREATE VIEW dept20 AS  
SELECT ename, sal FROM emp WHERE deptno = 20;
```

---

## 🔹 **6. Creating a View with Column Aliases**
### **Example:**
Create a view named `clerk`, renaming columns:
```sql
CREATE VIEW clerk (id, person, department, position) AS  
SELECT empno, ename, deptno, job FROM emp  
WHERE job = 'CLERK';
```

---

## 🔹 **7. WITH CHECK OPTION (View Restrictions)**
**Ensures that any `INSERT` or `UPDATE` operation follows the view's condition.**  
- If an `INSERT` or `UPDATE` does not match the `WHERE` condition, it is **rejected**.

### **Example:**
```sql
CREATE VIEW clerk AS  
SELECT empno, ename, deptno, job FROM emp  
WHERE job = 'CLERK'  
WITH CHECK OPTION;
```
- If you try to insert an employee with a different job title (not `CLERK`), the operation **fails**.

---

## 🔹 **8. Views Based on Joins**
- A **view can be created using multiple tables** by joining them.

### **Example:**
Creating a view `orderreport` based on `orders` and `items` tables:
```sql
CREATE VIEW orderreport AS  
SELECT orders.id, orders.orderdate, items.order_id,  
items.line_id, items.partid  
FROM orders, items  
WHERE items.order_id = orders.id;
```

### **Retrieving Data from the View:**
```sql
SELECT * FROM orderreport;
```
📌 **Output:**
| ORDER_ID | ORDERDATE | LINE_ID | PART_ID |  
|---------|----------|--------|--------|  
| 1       | 28-Jan-97 | 1      | 4      |  
| 1       | 28-Jan-97 | 2      | 2      |  
| 1       | 28-Jan-97 | 3      | 3      |  
| 2       | 28-Jan-97 | 1      | 4      |  

---

## 🔹 **9. Updatable Views (Views for Data Manipulation)**
✔ **Updatable Views** allow **INSERT, UPDATE, DELETE** operations.  
✔ A view is **updatable** if:
  - It is based on a **single table**.
  - It **does not** contain aggregate functions (`SUM, AVG, COUNT`).
  - It does **not** use `DISTINCT`, `GROUP BY`, `HAVING`, or `JOIN`.  

### **Example: Inserting into a View**
```sql
INSERT INTO orderreport (order_id, orderdate)  
VALUES (23, SYSDATE);
```

### **Example: Updating a View**
```sql
UPDATE orderreport SET orderdate = SYSDATE  
WHERE order_id = 22;
```

### **Example: Deleting from a View**
```sql
DELETE FROM orderreport WHERE order_id = 5;
```

---

## 🔹 **10. Dropping a View**
If a view is **no longer needed**, it can be removed.

### **Syntax:**
```sql
DROP VIEW view_name;
```

### **Example:**
```sql
DROP VIEW Branch;
```

---

## 🔹 **11. Common Restrictions on Updatable Views**
A view **cannot** be updated if:
❌ It contains **aggregate functions** (`SUM, AVG, COUNT`).  
❌ It uses **DISTINCT**, **GROUP BY**, or **HAVING**.  
❌ It includes **subqueries**.  
❌ It is based on a **non-updatable view**.  
❌ It joins **multiple tables** (unless the key-preserved table is updated).  

---

## 🎯 **When to Use Views?**
| **Scenario** | **Use Case** |  
|-------------|-------------|  
| **Security** | Restrict access to certain columns (e.g., salary data) |  
| **Data Simplification** | Create pre-processed views for complex joins |  
| **Data Hiding** | Hide irrelevant or sensitive information |  
| **Modular Querying** | Reuse query logic without duplication |  
| **Read-Only Access** | Provide a static view of the database |  

---

### **🚀 Key Takeaways**
✔ **Views** simplify data access by abstracting complex queries.  
✔ **Updatable Views** allow `INSERT`, `UPDATE`, and `DELETE` (with restrictions).  
✔ **WITH CHECK OPTION** ensures that modifications adhere to view conditions.  
✔ **Views based on multiple tables** (joins) are generally **read-only**.  
✔ **Dropping a view** does **not** delete underlying data.  

