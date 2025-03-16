# 📌 **Relational Database Design & Normalization**

## 🎯 **Goals of Relational Database Design**
- ✅ Store information efficiently without unnecessary redundancy.
- ✅ Retrieve information accurately and easily.

---

## 🛠 **Database Normalization**
**Normalization** is a technique used to design **a set of relations with desirable properties** while reducing redundancy.

### 🔍 **Process of Normalization**
- Identifies relations based on **primary or candidate keys**.
- Uses **functional dependencies** to ensure proper organization.

### 🎯 **Purpose of Normalization**
- 📉 **Eliminate redundancy**
- 📊 **Organize data efficiently**
- ⚠️ **Reduce data anomalies**

---

## 🚨 **Update Anomalies**
When a relation has redundant data, anomalies occur:

1. **Insertion Anomaly** – Unable to insert data without unnecessary dependencies.
2. **Deletion Anomaly** – Deleting one data piece unintentionally removes critical information.
3. **Modification Anomaly** – Updating one entry requires multiple modifications.

📌 **Example of Update Anomalies**
| staffNo | sName      | position   | salary | branchNo | bAddress               |
|---------|------------|------------|--------|----------|------------------------|
| SL21    | John White | Manager    | 30000  | B005     | 22 Deer Rd, London    |
| SG37    | Ann Beech  | Assistant  | 12000  | B003     | 163 Main St, Glasgow  |
| SG14    | David Ford | Supervisor | 18000  | B003     | 163 Main St, Glasgow  |
| SA9     | Mary Howe  | Assistant  | 9000   | B007     | 16 Argyll St, Aberdeen|
| SG5     | Susan Brand| Manager    | 24000  | B003     | 163 Main St, Glasgow  |
| SL41    | Julie Lee  | Assistant  | 9000   | B005     | 22 Deer Rd, London    |

### ⚠️ **Problems & Expanded Examples**
#### 1️⃣ **Insertion Anomaly**
An insertion anomaly occurs when inserting new data is not possible without additional, unrelated data.

**Example:**
- Suppose a new branch **B009** is opened, but it has no staff yet.
- In this table, we cannot insert the branch because **staffNo** is a required attribute.
- This leads to an **incomplete database**, making it difficult to store branch information independently.

#### 2️⃣ **Deletion Anomaly**
A deletion anomaly occurs when deleting one piece of data unintentionally removes other necessary information.

**Example:**
- If we delete **Mary Howe (SA9)** from **branch B007**, the entire branch **B007** will be removed.
- This means we lose branch details like **bAddress**, which should be stored separately.

#### 3️⃣ **Modification Anomaly**
A modification anomaly occurs when updating an attribute requires multiple changes.

**Example:**
- Suppose branch **B003** moves to a new address, **"500 Queen St, Glasgow"**.
- Since branch details are duplicated for every employee, we must update **every row where branchNo = B003**.
- If we miss one entry, the database becomes inconsistent.

---

## 🔑 **Functional Dependencies & Primary Key Identification**

### 📌 **What is a Functional Dependency?**
- A property defining the **relationship between attributes** in a relation.
- If attribute **A** uniquely determines **B**, we denote it as **A → B**.

💡 **Example**:
- **staffNo → sName** (Each staff number determines exactly one name.)
- **branchNo → bAddress** (Each branch number determines exactly one branch address.)
- **staffNo → (sName, position, salary, branchNo)** (A staff number determines all details about a staff member.)

### 🔍 **Determinant**
- The **left-hand side** attribute(s) of a functional dependency.
- In **A → B**, the determinant is **A**.

📌 **Example Functional Dependencies**
- **staffNo → sName** ✅ (Each staff number corresponds to a unique name.)
- **branchNo → bAddress** ✅ (Each branch number corresponds to one branch address.)
- **branchNo, staffNo → sName** ❌ (Incorrect because staffNo alone determines sName.)
- **staffNo → position, salary, branchNo** ✅ (Staff number uniquely identifies all attributes of the employee.)

🔹 **Trivial dependencies** do not give extra information, so we focus on **nontrivial dependencies** for constraints.

#### 🔥 **Real-World Example of Functional Dependencies**
Consider a **student database** with the following attributes:

| studentID | name       | course  | department |
|-----------|-----------|---------|------------|
| S001      | Alice     | CS101   | Computer Science |
| S002      | Bob       | ME102   | Mechanical |
| S003      | Charlie   | CS101   | Computer Science |
| S004      | David     | EE201   | Electrical |

Here, we observe these dependencies:
- **studentID → name** (Each student has a unique ID and name.)
- **course → department** (Each course belongs to one department.)
- **studentID → (name, course, department)** (Student ID determines all their details.)

---

## 📜 **Armstrong’s Axioms (Inference Rules for Functional Dependencies)**

1. **Reflexivity**: If B is a subset of A, then **A → B**.
2. **Augmentation**: If **A → B**, then **A, C → B**.
3. **Transitivity**: If **A → B** and **B → C**, then **A → C**.
4. **Self-Determination**: **A → A** (Every attribute determines itself.)
5. **Decomposition**: If **A → B, C**, then **A → B** and **A → C**.
6. **Union**: If **A → B** and **A → C**, then **A → B, C**.
7. **Composition**: If **A → B** and **C → D**, then **A, C → B, D**.

💡 **Example Applications of Armstrong’s Axioms**

| Given Functional Dependencies | Using Armstrong's Axioms | Result |
|--------------------------------|-------------------------|--------|
| A → B, B → C                  | Transitivity            | A → C  |
| A → BC                        | Decomposition           | A → B, A → C |
| A → B, A → C                  | Union                   | A → BC |

---

## 📝 **Summary & Key Takeaways**

✅ **Relational Database Design** aims to **store data efficiently** and **retrieve it without redundancy**.  
✅ **Normalization** helps eliminate **redundancy** and **data anomalies** (Insertion, Deletion, Modification).  
✅ **Functional Dependencies** define **relationships between attributes** and **help identify primary keys**.  
✅ **Armstrong’s Axioms** are **rules for inferring new functional dependencies** to ensure database consistency.  
