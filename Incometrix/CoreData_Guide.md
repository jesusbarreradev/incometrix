# Core Data in BudgetTracker — how it works

## The stack

Three pieces, all in `Persistence.swift`:

- **`NSPersistentContainer`** — loads the `.xcdatamodeld` schema and the SQLite
  file on disk. One instance (`PersistenceController.shared`) for the app's life.
- **`viewContext`** — an in-memory scratchpad of objects, tied to the main
  thread. All UI reads and writes go through it.
- **`save()`** — writes pending `viewContext` changes to disk. Nothing hits
  disk until this is called.

The context is injected once, at the app root:

```swift
ContentView()
    .environment(\.managedObjectContext, persistenceController.container.viewContext)
```

Every child view can then pull it back out with
`@Environment(\.managedObjectContext) private var viewContext`, so it never
needs to be passed down manually.

## Reading data: `@FetchRequest`

```swift
@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)])
private var accounts: FetchedResults<Account>
```

This is a live query, not a one-time read. Core Data watches the context and
re-renders the view automatically whenever a matching object is inserted,
edited, or deleted — no manual refresh code. You can add a `predicate:` to
filter (e.g. transactions for one account, transactions after a date).

## Writing data

Objects are created against a context, then the context is saved:

```swift
let account = Account(context: viewContext)
account.id = UUID()
account.name = "Checking"
try? viewContext.save()
```

The `Account.create(...)` / `Transaction.create(...)` static helpers in
`Models/` just wrap this pattern so views stay short.

## The relationship

`Account 1—n Transaction` is modeled as:

- `Account.transactions` — to-many, delete rule **Cascade**
- `Transaction.account` — to-one, delete rule **Nullify**, inverse of the above

Setting `transaction.account = someAccount` automatically updates
`someAccount.transactions` too — Core Data maintains both sides of an inverse
relationship for you. Cascade means deleting an `Account` deletes its
`Transaction`s with it, so you never get orphaned rows.

`Goal` has no relationships — it's fetched and displayed independently.

## A deliberate trade-off: stored vs. computed balance

`Account.balance` is a **stored** attribute that `Transaction.create` updates
directly (`account.balance += amount`), rather than always summing
transactions on the fly. This keeps the accounts list fast with no
aggregation query. The cost: balance and transactions can drift apart if you
ever edit or delete a transaction without also adjusting the balance — any
future edit/delete transaction feature must update `account.balance` too, or
switch to computing it from `transactionsArray.reduce`.

## SwiftUI previews without touching the real database

`PersistenceController.preview` builds a second container pointed at
`/dev/null` (in-memory, thrown away when the process ends) and seeds it with
sample data. Every `#Preview` block in this project uses it, so Xcode
previews never read or write your actual on-device data.

## Suggestions for things you might want to add next

- **Categories as their own entity** instead of a free-text `String`, once you
  want a fixed, user-editable list with icons/colors per category.
- **CloudKit sync** — swap `NSPersistentContainer` for
  `NSPersistentCloudKitContainer` to sync across a user's devices; the rest of
  the code above doesn't change.
- **Background context for imports** — if you ever bulk-import transactions
  (CSV, bank export), do it on a background `NSManagedObjectContext`
  (`container.newBackgroundContext()`) so the UI doesn't freeze.
- **Recompute-safe edits** — add edit/delete for transactions, and decide then
  whether to keep the stored-balance approach or move to a computed balance.
- **Currency per account** — if you want multi-currency support, add a
  `currencyCode` attribute to `Account` and use it in `asCurrency` instead of
  the device locale.
- **Unit tests** — test business logic (e.g. `Goal.progress`, balance updates)
  against an in-memory `PersistenceController(inMemory: true)`, same trick as
  the previews.
- **Lightweight migrations** — once the app ships, any future attribute/entity
  change needs a new model version; Core Data handles simple additions
  automatically but it's worth knowing this exists before your schema grows.
