# Setting up `BudgetTracker.xcdatamodeld`

Xcode's data model file is a special package, not plain text, so it has to be
built inside Xcode rather than dropped in as a code file. This takes about
five minutes.

## Steps

1. **File → New → File… → Data Model.** Name it exactly `BudgetTracker`
   (must match `NSPersistentContainer(name: "BudgetTracker")` in `Persistence.swift`).
2. Click **Add Entity** three times and rename them `Account`, `Transaction`, `Goal`.
3. For each entity, select it, open the **Data Model Inspector** (right panel),
   and set **Codegen** to **Class Definition** (this is the default). Xcode will
   generate the `NSManagedObject` subclasses for you at build time — that's why
   the extension files in `Models/` only *add* computed properties and never
   redeclare `id`, `name`, etc.
4. Add attributes using the **+** button under Attributes:

   **Account**
   | Attribute | Type   | Optional |
   |-----------|--------|----------|
   | id        | UUID   | No       |
   | name      | String | No       |
   | balance   | Double | No (default 0) |
   | createdAt | Date   | No       |

   **Transaction**
   | Attribute | Type   | Optional |
   |-----------|--------|----------|
   | id        | UUID   | No       |
   | amount    | Double | No (default 0) |
   | category  | String | Yes      |
   | note      | String | Yes      |
   | date      | Date   | No       |

   **Goal**
   | Attribute      | Type   | Optional |
   |----------------|--------|----------|
   | id             | UUID   | No       |
   | title          | String | No       |
   | targetAmount   | Double | No (default 0) |
   | currentAmount  | Double | No (default 0) |
   | deadline       | Date   | Yes      |

5. Add the relationship (this is the part that's easy to get backwards):
   - On **Account**, add relationship `transactions` → Destination: `Transaction`,
     Type: **To Many**.
   - On **Transaction**, add relationship `account` → Destination: `Account`,
     Type: **To One**.
   - Select `transactions` and set its **Inverse** to `account`. Xcode will
     auto-fill the inverse on the other side too.
   - Set **Delete Rule**: `Cascade` on `Account.transactions` (deleting an
     account deletes its transactions), `Nullify` on `Transaction.account`
     (the default — a transaction just loses its account reference if
     something else deletes the account).

6. **Build once (⌘B)** before writing/using code that references `Account`,
   `Transaction`, or `Goal` — that's when Xcode generates the classes.

## Reference: raw XML (advanced / optional)

If you ever want to inspect or hand-edit the model, right-click the
`.xcdatamodeld` → **Show Package Contents** → open
`BudgetTracker.xcdatamodel/contents` in a text editor. It should look like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<model type="com.apple.IDECoreDataModeler.DataModel" documentVersion="1.0" lastSavedToolsVersion="23000" systemVersion="24A" minimumToolsVersion="Automatic" sourceLanguage="Swift" usedWithSwiftData="NO" userDefinedModelVersionIdentifier="">
    <entity name="Account" representedClassName="Account" syncable="YES" codeGenerationType="class">
        <attribute name="balance" attributeType="Double" defaultValueString="0.0" usesScalarValueType="YES"/>
        <attribute name="createdAt" attributeType="Date" usesScalarValueType="NO"/>
        <attribute name="id" attributeType="UUID" usesScalarValueType="NO"/>
        <attribute name="name" attributeType="String"/>
        <relationship name="transactions" toMany="YES" deletionRule="Cascade" destinationEntity="Transaction" inverseName="account" inverseEntity="Transaction"/>
    </entity>
    <entity name="Transaction" representedClassName="Transaction" syncable="YES" codeGenerationType="class">
        <attribute name="amount" attributeType="Double" defaultValueString="0.0" usesScalarValueType="YES"/>
        <attribute name="category" optional="YES" attributeType="String"/>
        <attribute name="date" attributeType="Date" usesScalarValueType="NO"/>
        <attribute name="id" attributeType="UUID" usesScalarValueType="NO"/>
        <attribute name="note" optional="YES" attributeType="String"/>
        <relationship name="account" maxCount="1" deletionRule="Nullify" destinationEntity="Account" inverseName="transactions" inverseEntity="Account"/>
    </entity>
    <entity name="Goal" representedClassName="Goal" syncable="YES" codeGenerationType="class">
        <attribute name="currentAmount" attributeType="Double" defaultValueString="0.0" usesScalarValueType="YES"/>
        <attribute name="deadline" optional="YES" attributeType="Date" usesScalarValueType="NO"/>
        <attribute name="id" attributeType="UUID" usesScalarValueType="NO"/>
        <attribute name="targetAmount" attributeType="Double" defaultValueString="0.0" usesScalarValueType="YES"/>
        <attribute name="title" attributeType="String"/>
    </entity>
</model>
```
