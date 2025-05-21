# Comprehensive Notes on Database Transactions

## 1. Introduction to Database Transactions

A **database transaction** is a logical unit of work that involves one or more operations (e.g., reading or writing data) on a database. It ensures that the database remains in a consistent state, even in the presence of system failures or concurrent operations. Transactions are fundamental to database management systems (DBMS) as they maintain data integrity and reliability.

### Key Characteristics
- **Purpose**: Transactions ensure that all operations within a unit of work are completed successfully or none are applied, preventing partial updates that could lead to inconsistencies.
- **Types of Operations**:
  - **SELECT statements**: Retrieve data without modifying the database (e.g., checking an account balance).
  - **UPDATE statements**: Modify existing data (e.g., updating account balances).
  - **INSERT statements**: Add new data (e.g., adding a new sale record).
  - **DELETE statements**: Remove data (e.g., deleting a customer record).
  - **Combinations**: Complex transactions may involve multiple types of operations.
- **Challenges**:
  - **Failures**: Hardware crashes, software errors, or power outages can interrupt transactions.
  - **Concurrency**: Multiple transactions running simultaneously must not interfere with each other.

### Examples of Transactions
- **Example 1: Checking Account Balance**  
  ```sql
  SELECT ACC_NUM, ACC_BALANCE FROM CHECKACC WHERE ACC_NUM = '0908110638';
  ```
  - **Description**: This read-only transaction retrieves the balance of a specific account without altering the database.
  - **Outcome**: The database remains unchanged and consistent.

- **Example 2: Registering a Credit Sale**  
  ```sql
  UPDATE PRODUCT SET PROD_QOH = PROD_QOH - 100 WHERE PROD_CODE = 'X';
  UPDATE ACCT_RECEIVABLE SET ACCT_BALANCE = ACCT_BALANCE + 500 WHERE ACCT_NUM = 'Y';
  ```
  - **Description**: This transaction reduces the quantity on hand (QOH) of product X by 100 units and increases the account receivable balance for account Y by $500.
  - **Outcome**: The database is consistent only if both updates are completed successfully.

## 2. Properties of Transactions and Databases (ACID)

Transactions adhere to the **ACID properties**, which ensure reliability and consistency in database operations. These properties are critical for maintaining the integrity of databases, especially in multi-user environments or during system failures.

### ACID Properties
| Property       | Description                                                                 | Importance                                                                 |
|----------------|-----------------------------------------------------------------------------|---------------------------------------------------------------------------|
| **Atomicity**  | Ensures a transaction is treated as a single, indivisible unit. All operations must complete, or none are applied. | Prevents partial updates that could leave the database in an inconsistent state. |
| **Consistency**| Ensures a transaction transforms the database from one valid state to another, respecting all rules and constraints. | Maintains data integrity by enforcing rules like non-negative balances or foreign key constraints. |
| **Isolation**  | Ensures transactions do not affect each other’s intermediate states, appearing to execute in isolation. | Prevents issues like dirty reads or non-repeatable reads during concurrent execution. |
| **Durability** | Guarantees that once a transaction is committed, its changes are permanently saved, even after system failures. | Ensures data persistence, critical for reliability in case of crashes. |

### Example Illustrating ACID Properties: Fund Transfer
Consider a transaction to transfer $100 from Account A to Account B:
- **Scenario**:
  - Account A has $500, and Account B has $300 (total balance = $800).
  - The transaction deducts $100 from A and adds $100 to B.
- **ACID Properties in Action**:
  - **Atomicity**: Both operations (deduct $100 from A, add $100 to B) must succeed, or both are rolled back. If the system crashes after deducting from A but before adding to B, the transaction is undone to prevent money loss.
  - **Consistency**: The total balance (A + B = $800) must remain unchanged. After the transfer, A has $400, B has $400, and the total is still $800, satisfying all database constraints (e.g., no negative balances).
  - **Isolation**: If another transaction reads Account A’s balance during the transfer, it sees either $500 (before) or $400 (after), not an intermediate value like $450, preventing data inconsistencies.
  - **Durability**: Once the transaction is committed, the new balances ($400 for A, $400 for B) are permanently saved, even if the system crashes immediately after.

### Database Properties
Databases rely on transactions to maintain their core properties:
- **Data Integrity**: Ensured by consistency, which enforces rules like data types, foreign keys, and business logic.
- **Reliability**: Supported by durability, ensuring data is not lost during failures.
- **Concurrency Control**: Facilitated by isolation, allowing multiple users to access the database without conflicts.
- **Consistency Across Operations**: Achieved through atomicity, ensuring all operations in a transaction are completed as a unit.

For more on ACID properties, see [Database Transactions](https://www.geeksforgeeks.org/acid-properties-in-dbms/).

## 3. States of a Transaction

Transactions progress through a series of states during their lifecycle, which define their execution status and outcome. These states ensure systematic handling of transactions, maintaining database integrity.

### Transaction States
| State              | Description                                                                 | Key Action/Outcome                                                                 |
|--------------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| **Active**         | The transaction is executing its operations (e.g., reading or writing data). | Initial state where all database operations are performed.                        |
| **Partially Committed** | The transaction has completed its final operation but has not yet been fully saved. | Transitional state where the system checks if changes can be permanently stored.   |
| **Failed**         | The transaction cannot proceed due to an error (e.g., constraint violation, system crash). | Triggers a rollback to restore the database to its previous state.                |
| **Aborted**        | The transaction has been rolled back, undoing all changes and restoring the database. | Options: restart the transaction (if no logical error) or terminate it.           |
| **Committed**      | The transaction has successfully completed, and all changes are permanently saved. | Changes are durable and visible to other transactions.                            |

### State Transition Diagram
- **Active** → **Partially Committed**: When all operations are successfully executed.
- **Active** → **Failed**: If an error occurs during execution.
- **Partially Committed** → **Committed**: If the commit process succeeds.
- **Partially Committed** → **Failed**: If the commit process fails.
- **Failed** → **Aborted**: After rollback restores the database.

For a visual representation, see [Transaction States](https://www.tutorialspoint.com/dbms/dbms_transaction.htm).

### Example
In the fund transfer example:
- **Active**: The transaction is deducting $100 from A and adding $100 to B.
- **Partially Committed**: Both operations are complete, but the changes are not yet saved to disk.
- **Committed**: The changes are permanently saved, and the new balances are official.
- **Failed**: If insufficient funds are detected in A, the transaction fails.
- **Aborted**: The transaction is rolled back, restoring A to $500 and B to $300.

## 4. Implementation of Atomicity and Durability

Ensuring atomicity and durability is critical for reliable transaction management. One method is the **shadow-database scheme**, which provides a simple approach to achieving these properties.

### Shadow-Database Scheme
- **Mechanism**:
  - All updates are made on a shadow (temporary) copy of the database.
  - A `db_pointer` points to the current consistent database copy.
  - Upon reaching the partially committed state, the `db_pointer` is updated to point to the new shadow copy, and the old copy is discarded.
  - If the transaction fails, the `db_pointer` remains unchanged, pointing to the old copy.
- **Atomicity**: Ensures no partial updates are applied by retaining the old copy until the transaction is fully committed.
- **Durability**: Ensures committed changes are saved to disk, as the new copy is flushed before the `db_pointer` is updated.
- **Example**:
  - Before a fund transfer, the `db_pointer` points to the database with A = $500, B = $300.
  - The transaction updates a shadow copy (A = $400, B = $400).
  - Upon commit, the `db_pointer` switches to the shadow copy, making the changes permanent.
  - If the transaction fails, the shadow copy is discarded, and the `db_pointer` retains the original state.

### Limitations
- **Single Transaction**: Only one transaction can be active at a time, limiting concurrency.
- **Inefficiency**: Copying the entire database is impractical for large databases.
- **Disk Assumptions**: Assumes disks do not fail, which is unrealistic for robust systems.
- **Alternative**: Shadow paging reduces copying but is still inefficient for large-scale databases.

For more on transaction implementation, see [Database Recovery Techniques](https://www.geeksforgeeks.org/database-recovery-techniques-in-dbms/).

## 5. Transactions in Practice

Transactions are essential for ensuring data consistency in real-world applications. The following compares programming with and without transactions.

### Program Without Transactions
- **Description**: Operations are executed directly on the database without a transaction wrapper.
- **Issue**: If an error occurs, partial updates may leave the database inconsistent.
- **Example**:
  ```sql
  INSERT INTO Sales (Item_code, Quantity) VALUES ('P5', 3);
  UPDATE Total SET Quantity = Quantity + 3 WHERE Item_code = 'P5';
  ```
  - If the `UPDATE` fails (e.g., due to a system crash), the `INSERT` remains, causing inconsistency (sales recorded but total not updated).

### Program With Transactions
- **Description**: Operations are wrapped in a transaction, ensuring all succeed or none are applied.
- **Process**:
  - Start with `BEGIN TRANSACTION`.
  - Execute operations.
  - If successful, issue `COMMIT TRANSACTION`.
  - If an error occurs, issue `ROLLBACK TRANSACTION`.
- **Example**:
  ```sql
  BEGIN TRANSACTION;
  INSERT INTO Sales (Item_code, Quantity) VALUES ('P5', 3);
  UPDATE Total SET Quantity = Quantity + 3 WHERE Item_code = 'P5';
  COMMIT TRANSACTION;
  ```
  - If any step fails, `ROLLBACK TRANSACTION` undoes all changes, ensuring consistency.

### Benefits of Transactions
- **Atomicity**: Ensures all operations complete or none do.
- **Consistency**: Maintains database integrity by preventing partial updates.
- **Reliability**: Handles errors gracefully, restoring the database to a consistent state.

## 6. Answers to Specific Questions

### Question 1: Properties of Transactions and Databases
- **Transactions**:
  - **Atomicity**: All operations complete or none are applied.
  - **Consistency**: Transactions maintain valid database states.
  - **Isolation**: Transactions execute independently of each other.
  - **Durability**: Committed changes are permanent.
- **Databases**:
  - Rely on transactions to ensure **data integrity** (via consistency), **reliability** (via durability), **concurrency control** (via isolation), and **atomic operations** (via atomicity).
  - Example: A banking database uses transactions to ensure accurate account balances during transfers, maintaining trust and functionality.

### Question 2: Example of a Transaction and ACID Properties
- **Example Transaction**: Transfer $100 from Account A to Account B.
  - **SQL Representation**:
    ```sql
    BEGIN TRANSACTION;
    UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 'A';
    UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID = 'B';
    COMMIT TRANSACTION;
    ```
- **ACID Properties**:
  - **Atomicity**: Both updates (deduct from A, add to B) must succeed, or both are rolled back.
  - **Consistency**: The total balance (A + B) remains constant, and no constraints (e.g., non-negative balances) are violated.
  - **Isolation**: Other transactions cannot see intermediate balances during the transfer.
  - **Durability**: Once committed, the new balances are saved permanently, even after a system failure.

### Question 3: States of a Transaction
- **Active**: The transaction is executing (e.g., updating balances during a fund transfer).
- **Partially Committed**: All operations are complete, but changes are not yet saved to disk.
- **Failed**: An error (e.g., insufficient funds) prevents completion.
- **Aborted**: The transaction is rolled back, restoring the original state.
- **Committed**: The transaction is complete, and changes are permanently saved.
- **Note**: "Completed" is not a standard state but may refer to the final state after committing or aborting.