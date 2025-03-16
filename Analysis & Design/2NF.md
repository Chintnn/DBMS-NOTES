# 🌟 **Second Normal Form (2NF)**  

## 📌 **Definition of 2NF**  
A relation is in **Second Normal Form (2NF)** if:  
✅ It is in **First Normal Form (1NF)**.  
✅ Every **non-primary key** attribute is **fully functionally dependent** on the primary key.  

This means that **partial dependencies** (where a non-key attribute depends only on part of a composite key) must be removed.  

---

## 🔄 **Process of 1NF to 2NF Normalization**  
1️⃣ Identify **partial dependencies** in the 1NF relation.  
2️⃣ Move functionally dependent attributes to separate tables.  
3️⃣ Keep a copy of the **determinant** (the attribute(s) on which other attributes depend) in each new relation.  

---

# 🏠 **2NF ClientRental Relation**  

## 🔍 **Functional Dependencies in 1NF ClientRental**  

1️⃣ **fd1:** `{clientNo, propertyNo} → {rentStart, rentFinish}` (**Primary Key**)  
2️⃣ **fd2:** `{clientNo} → {cName}` (**Partial Dependency**)  
3️⃣ **fd3:** `{propertyNo} → {pAddress, rent, ownerNo, oName}` (**Partial Dependency**)  
4️⃣ **fd4:** `{ownerNo} → {oName}` (**Transitive Dependency**)  
5️⃣ **fd5:** `{clientNo, rentStart} → {propertyNo, pAddress, rentFinish, rent, ownerNo, oName}` (**Candidate Key**)  
6️⃣ **fd6:** `{propertyNo, rentStart} → {clientNo, cName, rentFinish}` (**Candidate Key**)  

---

## 🛠 **Removing Partial Dependencies**  

To remove **partial dependencies**, we create **three new relations**:  
📌 **Client** – Stores `clientNo` and `cName` (removes `cName` from partial dependency).  
📌 **Rental** – Stores `clientNo`, `propertyNo`, `rentStart`, and `rentFinish` (main rental details).  
📌 **PropertyOwner** – Stores `propertyNo`, `pAddress`, `rent`, `ownerNo`, and `oName` (removes dependency on `propertyNo`).  

---

# 📊 **2NF ClientRental Relations**  

## 🧑‍💼 **Client Table**  
| 🆔 ClientNo | 👤 Name          |  
|------------|----------------|  
| CR76       | John Kay       |  
| CR56       | Aline Stewart  |  

---

## 📜 **Rental Table**  
| 🆔 ClientNo | 🏠 PropertyNo | 📅 RentStart | 📅 RentFinish |  
|------------|-------------|------------|-------------|  
| CR76       | PG4         | 1 Jul 00   | 31 Aug 01  |  
| CR76       | PG16        | 1 Sep 02   | 1 Sep 02   |  
| CR56       | PG4         | 1 Sep 99   | 10 Jun 00  |  
| CR56       | PG36        | 10 Oct 00  | 1 Dec 01   |  
| CR56       | PG16        | 1 Nov 02   | 1 Aug 03   |  

---

## 🏡 **PropertyOwner Table**  
| 🏠 PropertyNo | 📍 Address                 | 💰 Rent | 🆔 OwnerNo | 👤 Owner Name   |  
|--------------|---------------------------|------|---------|-------------|  
| PG4          | 6 Lawrence St, Glasgow    | 350  | CO40    | Tina Murphy  |  
| PG16         | 5 Novar Dr, Glasgow       | 450  | CO93    | Tony Shaw    |  
| PG36         | 2 Manor Rd, Glasgow       | 370  | CO93    | Tony Shaw    |  

---

# ✅ **Final 2NF Relations**  

- **🧑‍💼 Client (clientNo, cName)**  
- **📜 Rental (clientNo, propertyNo, rentStart, rentFinish)**  
- **🏡 PropertyOwner (propertyNo, pAddress, rent, ownerNo, oName)**  

By decomposing the original **1NF ClientRental relation**, we have successfully removed **partial dependencies**, ensuring that all **non-key attributes** fully depend on the **whole primary key**. 🎯