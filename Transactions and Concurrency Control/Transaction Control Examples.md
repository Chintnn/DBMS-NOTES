# Comprehensive Notes on Database Transactions, Commit, Rollback, and Serializability

## 1. Introduction to Database Transactions
A database transaction is a logical unit of work comprising one or more operations (e.g., read, write) on a database, ensuring data integrity and consistency. Transactions are essential in multi-user environments to handle concurrent access and system failures.

### Key Characteristics
- **Atomicity**: Ensures all operations complete successfully, or none are applied.
- **Consistency**: Maintains database validity by adhering to all constraints.
- **Isolation**: Prevents transactions from interfering with each other’s intermediate states.
- **Durability**: Guarantees committed changes are permanently saved, even after failures.
- **Execution Modes**:
  - **Serial**: Transactions execute sequentially without overlap.
  - **Concurrent**: Transactions run simultaneously, with interleaved operations, requiring serializability to ensure correctness.

**Example**: Transferring $100 from Account A to Account B involves:
- Deducting $100 from A.
- Adding $100 to B.
Both operations must complete (commit) or be undone (rollback) to maintain consistency.

## 2. Effect of Commit and Rollback on Database
Commit and rollback are Transaction Control Language (TCL) commands that manage transaction outcomes, ensuring data integrity.

### 2.1 Commit
- **Definition**: The `COMMIT` command saves all changes made during a transaction to the database, making them permanent and visible to other transactions.
- **Effect**: Ensures durability by writing changes to disk, updating the transaction log, and releasing locks.
- **Example**:
  ```sql
  BEGIN TRANSACTION;
  UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 'A';
  UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID = 'B';
  COMMIT;
  ```
  - After `COMMIT`, Account A’s balance decreases by $100, and Account B’s increases by $100, permanently saved.

### 2.2 Rollback
- **Definition**: The `ROLLBACK` command undoes all changes made during a transaction, restoring the database to its state before the transaction began.
- **Effect**: Maintains consistency by reversing uncommitted changes, typically used when errors occur or constraints are violated.
- **Example**:
  ```sql
  BEGIN TRANSACTION;
  UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 'A';
  -- Error: Insufficient funds
  ROLLBACK;
  ```
  - After `ROLLBACK`, both accounts revert to their original balances.

### 2.3 Diagram of Commit and Rollback Processes
Although images cannot be included, the commit and rollback processes can be described based on standard database mechanisms ([Commit vs. Rollback](https://dev.to/asifzcpe/demystifying-database-transactions-how-commit-and-rollback-ensure-smooth-data-handling-2mo2)):

- **Commit Process**:
  1. **Begin Transaction**: Initiates the transaction.
  2. **Write-Ahead Logging (WAL)**: Logs changes before applying them.
  3. **In-Memory Data Modification**: Updates data in memory.
  4. **Log Flush**: Writes logs to disk for durability.
  5. **Commit Record**: Records the commit in the log.
  6. **Data Page Flush**: Writes modified data to disk (may be deferred).

- **Rollback Process**:
  1. **Identify Uncommitted Changes**: Detects changes not yet committed.
  2. **Undo Log Entries**: Creates entries to reverse changes.
  3. **Apply Undo Operations**: Restores original data values.
  4. **Log Rollback**: Records the rollback action.
  5. **Release Locks**: Frees resources held by the transaction.

**Table: Commit vs. Rollback Effects**
| Action   | Effect on Database                     | Example Outcome                     |
|----------|---------------------------------------|-------------------------------------|
| Commit   | Saves changes permanently             | Transfer of $100 is saved           |
| Rollback | Undoes changes, restores prior state  | Transfer is canceled, balances revert |

## 3. Transaction Schedules
A schedule defines the order of operations from multiple transactions. Schedules are critical in concurrent environments to ensure efficient resource use while maintaining consistency.

### 3.1 Types of Schedules
- **Serial Schedule**: Transactions execute one after another without overlap, ensuring no interference but potentially reducing throughput.
  - **Example**:
    ```
    T1: read(A), A := A - 50, write(A), read(B), B := B + 50, write(B)
    T2: read(A), temp := A * 0.1, A := A - temp, write(A), read(B), B := B + temp, write(B)
    ```
    - T1 completes fully before T2 starts.
- **Concurrent Schedule**: Transactions overlap, with operations interleaved, improving efficiency but requiring serializability checks.
  - **Example**:
    ```
    T1: read(A), A := A - 50, write(A)
    T2: read(A), temp := A * 0.1, A := A - temp, write(A)
    T1: read(B), B := B + 50, write(B)
    T2: read(B), B := B + temp, write(B)
    ```
    - Operations from T1 and T2 are interleaved.

### 3.2 Serializable vs. Non-Serializable Schedules
- **Serializable**: A concurrent schedule is serializable if it produces the same result as some serial schedule.
  - **Conflict Serializable**: Can be transformed into a serial schedule by swapping non-conflicting operations.
  - **View Serializable**: Has the same initial reads, final writes, and read-from relationships as a serial schedule.
- **Non-Serializable**: Produces results not equivalent to any serial schedule, potentially leading to inconsistencies.

**Example**:
- **Serializable Schedule**:
  ```
  T1: read(A), A := A - 50, write(A)
  T2: read(A), temp := A * 0.1, A := A - temp, write(A)
  T1: read(B), B := B + 50, write(B)
  T2: read(B), B := B + temp, write(B)
  ```
  - Equivalent to serial order T1 → T2.
- **Non-Serializable Schedule**:
  ```
  T1: read(A)
  T2: write(A)
  T1: write(B)
  T2: read(B)
  ```
  - Creates a cycle in the precedence graph, indicating non-serializability.

## 4. Testing Conflict Serializability
Conflict serializability is tested using a **precedence graph**, where:
- **Nodes**: Represent transactions (e.g., T1, T2).
- **Edges**: Drawn from Ti to Tj if Ti performs an operation before Tj on the same data item, and the operations conflict (read-write, write-read, write-write).
- **Condition**: A schedule is conflict serializable if the precedence graph is acyclic.

### Steps to Test Conflict Serializability
1. List all operations in the schedule, noting the transaction and data item.
2. Identify conflicting operations:
   - Read(Q) by Ti and Write(Q) by Tj.
   - Write(Q) by Ti and Read(Q) by Tj.
   - Write(Q) by Ti and Write(Q) by Tj.
3. Draw edges from Ti to Tj if Ti’s operation precedes Tj’s and they conflict.
4. Check for cycles in the graph. No cycles mean the schedule is conflict serializable.

**Example**:
- Schedule:
  ```
  T1: read(A)
  T2: read(B)
  T1: write(B)
  T2: write(A)
  ```
- Conflicts:
  - T1 read(A), T2 write(A): R-W, draw T1 → T2.
  - T2 read(B), T1 write(B): R-W, draw T2 → T1.
- Precedence Graph: T1 → T2, T2 → T1 (cycle exists).
- **Conclusion**: Not conflict serializable due to the cycle.

## 5. Example Schedule with Four Transactions
Consider the following schedule with four transactions (T1, T2, T3, T4) operating on data items A and B:
```
T1: read(A)
T3: read(A)
T1: write(A)
T2: read(B)
T4: read(B)
T2: write(B)
T4: write(B)
T3: write(A)
```

### Conflict Serializability Check
- **Operations on A**: R1(A), R3(A), W1(A), W3(A)
  - R3(A) → W1(A): R-W, draw T3 → T1.
  - R1(A) → W3(A): R-W, draw T1 → T3.
  - W1(A) → W3(A): W-W, draw T1 → T3.
- **Operations on B**: R2(B), R4(B), W2(B), W4(B)
  - R2(B) → W4(B): R-W, draw T2 → T4.
  - W2(B) → W4(B): W-W, draw T2 → T4.
- **Precedence Graph**:
  - Edges: T3 → T1, T1 → T3, T2 → T4.
  - Cycle: T1 ↔ T3.
- **Conclusion**: The schedule is **not conflict serializable** due to the cycle T1 ↔ T3.

## 6. Testing View Serializability
A schedule is view serializable if it is view equivalent to a serial schedule, meaning:
- Same initial reads for each transaction.
- Same final writes for each data item.
- Same read-from relationships (if Ti reads a value written by Tj in one schedule, it must do so in the other).

### Steps to Check View Serializability
1. Identify initial reads for each data item.
2. Identify final writes for each data item.
3. Determine read-from relationships (which transaction’s write is read by another).
4. Compare with possible serial schedules (e.g., T1 → T2 or T2 → T1 for two transactions).
5. If the schedule matches one serial schedule’s view, it is view serializable.

**Example with Two Transactions (T1, T2)**:
- **Schedule S**:
  ```
  T1: read(A)
  T1: write(A)
  T2: read(A)
  ```
- **Analysis**:
  - **Initial Reads**: T1 reads initial A.
  - **Final Writes**: T1 writes A.
  - **Read-From**: T2 reads A written by T1.
- **Serial Order T1 → T2**:
  - T1 reads initial A, writes A; T2 reads A (from T1).
  - Matches S.
- **Serial Order T2 → T1**:
  - T2 reads initial A; T1 reads initial A, writes A.
  - T2 reads initial A, not T1’s A, so does not match S.
- **Conclusion**: S is view serializable, equivalent to T1 → T2.
