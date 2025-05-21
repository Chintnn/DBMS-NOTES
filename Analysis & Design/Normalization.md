# Comprehensive Notes on Database Normalization

## 1. Relational Database Design
- **Definition**: The process of creating database schemas that store information without unnecessary redundancy and allow for easy, accurate retrieval.
- **Goals**:
  - Minimize data redundancy to save storage and simplify updates.
  - Ensure efficient and accurate data retrieval for queries and applications.
- **Significance**: A well-designed relational database supports complex queries and maintains data integrity, forming the backbone of modern database systems.

## 2. Database Normalization
- **Definition**: A formal technique for producing a set of relations with desirable properties based on an enterprise’s data requirements.
- **Key Components**:
  - **Primary and Candidate Keys**: Unique identifiers for records in a relation.
  - **Functional Dependencies**: Relationships between attributes where one determines another (e.g., A → B).
- **Purpose**:
  - Eliminate redundant data.
  - Organize data efficiently.
  - Reduce the risk of data anomalies during insertions, deletions, or updates.

## 3. Purpose of Normalization
Normalization aims to:
- **Eliminate Redundancy**: Store each piece of data once to avoid duplication.
- **Organize Data Efficiently**: Structure data to optimize storage and retrieval.
- **Reduce Data Anomalies**: Prevent issues that could corrupt data during operations.

## 4. Update Anomalies
- **Definition**: Problems in relations with redundant data, categorized as:
  - **Insertion Anomalies**: Difficulty adding new data without violating integrity (e.g., cannot add a new branch without a staff member).
  - **Deletion Anomalies**: Losing data when deleting a record (e.g., deleting the last staff member of a branch removes branch details).
  - **Modification Anomalies**: Requiring multiple updates for a single change (e.g., updating a branch address across multiple rows).
- **Example**:
  - **StaffBranch Relation**:
    | staffNo | sName       | position   | salary | branchNo | bAddress              |
    |---------|-------------|------------|--------|----------|-----------------------|
    | SL21    | John White  | Manager    | 30000  | B005     | 22 Deer Rd, London    |
    | SG37    | Ann Beech   | Assistant  | 12000  | B003     | 163 Main St Glasgow   |
    | SG14    | David Ford  | Supervisor | 18000  | B003     | 163 Main St Glasgow   |
    | SA9     | Mary Howe   | Assistant  | 9000   | B007     | 16 Argyll St Aberdeen |
    | SG5     | Susan Brand | Manager    | 24000  | B003     | 163 Main St Glasgow   |
    | SL41    | Julie Lee   | Assistant  | 9000   | B005     | 22 Deer Rd London     |
  - **Issues**:
    - Cannot insert a new branch without a staff member.
    - Deleting the last staff member of a branch loses branch information.
    - Changing a branch address requires updating multiple rows.
  - **Normalized Solution**:
    - **Staff**: staffNo, sName, position, salary, branchNo
    - **Branch**: branchNo, bAddress

## 5. Functional Dependencies
- **Definition**: A relationship where one attribute (or set of attributes) determines another (A → B). The left-hand side (A) is the determinant.
- **Types**:
  - **Full Functional Dependency**: B depends on the entire A, not a subset.
  - **Partial Dependency**: B depends on a subset of A.
  - **Trivial Dependency**: The right-hand side is a subset of the left-hand side (e.g., staffNo, sName → sName).
- **Characteristics**:
  - One-to-one relationship between attributes.
  - Holds for all time.
  - Nontrivial dependencies are key for integrity constraints.
- **Example**:
  - In StaffBranch: staffNo → sName, position, salary.

## 6. Inference Rules (Armstrong’s Axioms)
- **Purpose**: Rules to derive new functional dependencies from existing ones.
- **Rules**:
  1. **Reflexivity**: If B ⊆ A, then A → B.
  2. **Augmentation**: If A → B, then A, C → B.
  3. **Transitivity**: If A → B and B → C, then A → C.
  4. **Decomposition**: If A → B, C, then A → B and A → C.
  5. **Union**: If A → B and A → C, then A → B, C.
  6. **Composition**: If A → B and C → D, then A, C → B, D.
- **Application**: Used to identify all dependencies in a relation for normalization.

## 7. The Process of Normalization
- **Overview**: A step-by-step process where each step corresponds to a normal form (1NF, 2NF, 3NF, etc.).
- **Key Points**:
  - Relations become more structured and less prone to anomalies.
  - 1NF is mandatory for relational databases; higher forms are optional.
- **Steps**:
  - Identify functional dependencies.
  - Remove repeating groups (1NF).
  - Remove partial dependencies (2NF).
  - Remove transitive dependencies (3NF).
  - Ensure determinants are candidate keys (BCNF).

## 8. First Normal Form (1NF)
- **Definition**: A relation where each row-column intersection contains a single value, eliminating repeating groups.
- **Approaches**:
  1. Fill empty columns in rows with repeating data.
  2. Move repeating groups to a new relation with the original key.
- **Example**:
  - **Unnormalized ClientRental**:
    | clientNo | cName | propertyNo | pAddress              | rentStart | rentFinish | rent | ownerNo | oName       |
    |----------|-------|------------|-----------------------|-----------|------------|------|---------|-------------|
    | CR76     | John  | PG4        | 6 Lawrence St, Glasgow | 1-Jun-00  | 31-Aug-01  | 350  | C043    | Tina Murphy |
    | CR76     | John  | PG16       | 5 Novar Dr, Glasgow   | 1-Sep-02  | 1-Sep-02   | 450  | C043    | Tina Murphy |
    | CR56     | Aine  | PG4        | 6 Lawrence St, Glasgow | 1-Sep-99  | 10-Jun-00  | 350  | C043    | Tina Murphy |
    | CR56     | Aine  | PG36       | 2 Manor Rd, Glasgow   | 10-Oct-00 | 1-Dec-01   | 370  | C043    | Tina Murphy |
    | CR56     | Aine  | PG16       | 5 Novar Dr, Glasgow   | 1-Nov-02  | 1-Aug-03   | 450  | C043    | Tina Murphy |
  - **1NF (First Approach)**: Same structure, but each row is unique.
  - **1NF (Second Approach)**:
    - **Client**: clientNo, cName
    - **Rental**: clientNo, propertyNo, pAddress, rentStart, rentFinish, rent, ownerNo, oName

## 9. Second Normal Form (2NF)
- **Definition**: A relation in 1NF where every non-primary-key attribute is fully functionally dependent on the primary key.
- **Process**: Remove partial dependencies by creating new relations.
- **Example**:
  - **ClientRental Functional Dependencies**:
    - clientNo, propertyNo → rentStart, rentFinish (Primary Key)
    - clientNo → cName (Partial)
    - propertyNo → pAddress, rent, ownerNo, oName (Partial)
    - ownerNo → oName (Transitive)
  - **2NF Relations**:
    - **Client**: clientNo, cName
    - **Rental**: clientNo, propertyNo, rentStart, rentFinish
    - **PropertyOwner**: propertyNo, pAddress, rent, ownerNo, oName

## 10. Third Normal Form (3NF)
- **Definition**: A relation in 2NF with no transitive dependencies.
- **Process**: Remove transitive dependencies by creating new relations.
- **Example**:
  - **PropertyOwner Transitive Dependency**: ownerNo → oName
  - **3NF Relations**:
    - **PropertyOwner**: propertyNo, pAddress, rent, ownerNo
    - **Owner**: ownerNo, oName
  - **Sample Data**:
    - **Client**:
      | clientNo | cName         |
      |----------|---------------|
      | CR76     | John Kay      |
      | CR56     | Aline Stewart |
    - **Rental**:
      | clientNo | propertyNo | rentStart | rentFinish |
      |----------|------------|-----------|------------|
      | CR76     | PG4        | 1-Jan-00  | 31-Aug-01  |
      | CR76     | PG16       | 1-Sep-02  | 10-Jun-03  |
      | CR56     | PG4        | 1-Sep-02  | 10-Jun-03  |
      | CR56     | PG36       | 1-Nov-03  | 1-Aug-04   |
    - **PropertyOwner**:
      | propertyNo | pAddress              | rent | ownerNo |
      |------------|-----------------------|------|---------|
      | PG4        | 6 Lawrence St, Glasgow | 350  | CO46    |
      | PG16       | 5 Novar Dr, Glasgow   | 370  | CO93    |
      | PG36       | 2 Manor Road, Glasgow | 450  | CO93    |
    - **Owner**:
      | ownerNo | oName       |
      |---------|-------------|
      | CO46    | Tina Murphy |
      | CO93    | Tony Shaw   |

## 11. Boyce-Codd Normal Form (BCNF)
- **Definition**: A relation where every determinant is a candidate key.
- **Difference from 3NF**: In 3NF, A → B is allowed if B is a primary-key attribute and A is not a candidate key; in BCNF, A must be a candidate key.
- **Example**:
  - **ClientInterview Relation**:
    - Functional Dependencies:
      - clientNo, interviewDate → interviewTime, staffNo, roomNo (Primary Key)
      - staffNo, interviewDate → roomNo (Not a candidate key)
    - **BCNF Relations**:
      - **Interview**: clientNo, interviewDate, interviewTime, staffNo
      - **StaffRoom**: staffNo, interviewDate, roomNo
    - **Sample Data**:
      - **Interview**:
        | clientNo | interviewDate | interviewTime | staffNo |
        |----------|---------------|---------------|---------|
        | CR76     | 13-May-02     | 10:30         | SG5     |
        | CR76     | 13-May-02     | 12:00         | SG5     |
        | CR74     | 13-May-02     | 12:00         | SG37    |
        | CR56     | 1-Jul-02      | 10:30         | SG5     |
      - **StaffRoom**:
        | staffNo | interviewDate | roomNo |
        |---------|---------------|--------|
        | SG5     | 13-May-02     | G101   |
        | SG5     | 13-May-02     | G102   |
        | SG37    | 13-May-02     | G102   |
        | SG5     | 1-Jul-02      | G102   |

## 12. Fourth Normal Form (4NF)
- **Definition**: A relation in BCNF with no nontrivial multi-valued dependencies (MVDs).
- **Multi-Valued Dependency (MVD)**: A →→ B if for each value of A, there are independent sets of values for B and another attribute C.
- **Trivial MVD**: A →→ B if B ⊆ A or A ∪ B = R.
- **Nontrivial MVD**: Neither condition is met.
- **Process**: Remove nontrivial MVDs by splitting relations.

## 13. Fifth Normal Form (5NF)
- **Definition**: A relation with no join dependencies.
- **Join Dependency**: A relation satisfies a join dependency if it can be reconstructed from its projections on subsets of attributes.
- **Process**: Ensure the relation cannot be decomposed further without losing information.

## Summary of Normal Forms
| Normal Form | Definition | Key Action |
|-------------|------------|------------|
| **1NF** | Each row-column intersection has one value. | Remove repeating groups. |
| **2NF** | In 1NF, no partial dependencies. | Remove partial dependencies. |
| **3NF** | In 2NF, no transitive dependencies. | Remove transitive dependencies. |
| **BCNF** | Every determinant is a candidate key. | Ensure all determinants are candidate keys. |
| **4NF** | In BCNF, no nontrivial MVDs. | Remove nontrivial MVDs. |
| **5NF** | No join dependencies. | Remove join dependencies. |