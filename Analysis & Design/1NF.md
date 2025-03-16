# 🛠 **The Process of Normalization **  

Normalization is carried out in **a series of steps**, where each step corresponds to a **normal form**. The objective is to reduce **redundancy** and eliminate **update anomalies** while ensuring data integrity.  

## 🔍 **Key Properties of Normalization:**  
- Relations become **progressively more restricted in format** as normalization proceeds.  
- It helps in **reducing data anomalies** (Insertion, Deletion, Modification).  
- **Only First Normal Form (1NF) is mandatory** for the relational model, while other normal forms are optional but recommended.  

---

# 📌 **First Normal Form (1NF)**  
### **Definition**  
A relation is in **First Normal Form (1NF)** if:  
✅ Each column contains **atomic (indivisible) values**.  
✅ There are **no repeating groups or arrays** in any row.  

### 🚨 **Unnormalized Form (UNF) Example**  

Consider the following **ClientRental** relation, where a client rents multiple properties, leading to **repeating groups**:  

| clientNo | cName         | propertyNo | pAddress               | rentStart | rentFinish | rent | ownerNo | oName       |  
|----------|--------------|------------|------------------------|-----------|------------|------|---------|------------|  
| CR76     | John Kay     | PG4, PG16  | 6 Lawrence St, Glasgow; 5 Novar Dr, Glasgow | 1 Jul 00; 1 Sep 02 | 31 Aug 01; 1 Sep 02 | 350; 450 | CO40; CO93 | Tina Murphy; Tony Shaw |  
| CR56     | Aline Stewart | PG4, PG36, PG16 | 6 Lawrence St, Glasgow; 2 Manor Rd, Glasgow; 5 Novar Dr, Glasgow | 1 Sep 99; 10 Oct 00; 1 Nov 02 | 10 Jun 00; 1 Dec 01; 1 Aug 03 | 350; 370; 450 | CO40; CO93; CO93 | Tina Murphy; Tony Shaw; Tony Shaw |  

🚨 **Issues with UNF:**  
❌ **Repeating Groups**: Multiple property details are stored in a **single cell**, making it difficult to query and update.  
❌ **Insertion Anomaly**: If a **new client** is added who has not rented a property yet, we **cannot insert** their data without property details.  
❌ **Deletion Anomaly**: If the last rented property of a client is removed, their **client record is lost**.  
❌ **Modification Anomaly**: If an **owner's name** changes, it must be updated **in multiple places**.  

---

### ✅ **Converting to 1NF (Removing Repeating Groups)**  

To remove repeating groups, we use **one of two approaches**:  

### 📌 **Approach 1: Flattening the Relation**  
Each repeating value is placed in a **separate row**, ensuring that each column contains only **atomic values**.  

| clientNo | propertyNo | cName         | pAddress               | rentStart | rentFinish | rent | ownerNo | oName       |  
|----------|------------|--------------|------------------------|-----------|------------|------|---------|------------|  
| CR76     | PG4       | John Kay      | 6 Lawrence St, Glasgow | 1 Jul 00  | 31 Aug 01  | 350  | CO40    | Tina Murphy |  
| CR76     | PG16      | John Kay      | 5 Novar Dr, Glasgow    | 1 Sep 02  | 1 Sep 02   | 450  | CO93    | Tony Shaw   |  
| CR56     | PG4       | Aline Stewart | 6 Lawrence St, Glasgow | 1 Sep 99  | 10 Jun 00  | 350  | CO40    | Tina Murphy |  
| CR56     | PG36      | Aline Stewart | 2 Manor Rd, Glasgow    | 10 Oct 00 | 1 Dec 01   | 370  | CO93    | Tony Shaw   |  
| CR56     | PG16      | Aline Stewart | 5 Novar Dr, Glasgow    | 1 Nov 02  | 1 Aug 03   | 450  | CO93    | Tony Shaw   |  

📌 **Advantages of this approach:**  
✅ **No repeating groups**; each cell contains atomic values.  
✅ **Easy to update records** without redundancy.  

---

### 📌 **Approach 2: Creating Separate Relations**  
Instead of repeating **client details** for every property rental, we divide the relation into **two separate tables**:  

#### **Client Table** (Storing client details separately)  
| clientNo | cName         |  
|----------|--------------|  
| CR76     | John Kay     |  
| CR56     | Aline Stewart |  

#### **Rental Table** (Storing property rental details)  
| clientNo | propertyNo | pAddress               | rentStart | rentFinish | rent | ownerNo | oName       |  
|----------|------------|------------------------|-----------|------------|------|---------|------------|  
| CR76     | PG4       | 6 Lawrence St, Glasgow | 1 Jul 00  | 31 Aug 01  | 350  | CO40    | Tina Murphy |  
| CR76     | PG16      | 5 Novar Dr, Glasgow    | 1 Sep 02  | 1 Sep 02   | 450  | CO93    | Tony Shaw   |  
| CR56     | PG4       | 6 Lawrence St, Glasgow | 1 Sep 99  | 10 Jun 00  | 350  | CO40    | Tina Murphy |  
| CR56     | PG36      | 2 Manor Rd, Glasgow    | 10 Oct 00 | 1 Dec 01   | 370  | CO93    | Tony Shaw   |  
| CR56     | PG16      | 5 Novar Dr, Glasgow    | 1 Nov 02  | 1 Aug 03   | 450  | CO93    | Tony Shaw   |  

📌 **Advantages of this approach:**  
✅ **No redundancy** in client information.  
✅ **Efficient queries**, as each table focuses on a single entity.  

---

## 🔑 **Full Functional Dependency (Expanded)**  
A **functional dependency** (FD) is a relationship where one attribute uniquely determines another.  

### 📌 **Definition of Full Functional Dependency**  
If **A → B**, then B is **fully functionally dependent** on A if:  
- B **depends on all** attributes of A, not just a part of it.  

### 🔍 **Example**  
Consider the **ClientRental** relation before normalization:  
| clientNo | propertyNo | cName         | pAddress               | rentStart | rentFinish | rent | ownerNo | oName       |  
|----------|------------|--------------|------------------------|-----------|------------|------|---------|------------|  

- **(clientNo, propertyNo) → rentStart, rentFinish, rent, ownerNo, oName** ✅ (Because the rental information depends on both client and property).  
- **clientNo → cName** ✅ (Each client has only one name).  
- **propertyNo → pAddress** ✅ (Each property has a fixed address).  

💡 **Example of Full Functional Dependency**  
If we define **ClientRental(clientNo, propertyNo, rentStart, rentFinish, rent, ownerNo, oName)**:  
- **(clientNo, propertyNo) → rentStart, rentFinish, rent, ownerNo, oName** is a **full dependency**, as rental information depends on **both clientNo and propertyNo**.  

📌 **Partial Dependency Example**  
If we define **(clientNo, propertyNo) → cName, pAddress, rentStart**, this is **partially dependent** because:  
- **cName depends only on clientNo** (not on propertyNo).  
- **pAddress depends only on propertyNo** (not on clientNo).  

🚨 **Problem with Partial Dependencies**  
- Leads to **data redundancy**.  
- Creates **update anomalies** when modifying dependent attributes.  

---

## 📝 **Key Takeaways**  
✅ **1NF ensures atomic values and removes repeating groups.**  
✅ **Two approaches for 1NF: flattening the table or creating separate relations.**  
✅ **Full Functional Dependency ensures attributes depend entirely on the primary key.**  
✅ **Eliminating Partial Dependencies improves efficiency and removes redundancy.**  
