import CoreData
import WidgetKit

/// Must match the App Group ID you create in Signing & Capabilities for BOTH
/// the app target and the widget extension target. Without this, the widget
/// process can't see the app's data.
private let appGroupID = "group.com.AlejandroPalacios.Incometrix"

/// Owns the Core Data stack: the persistent container and the save() helper.
/// Inject `container.viewContext` into the SwiftUI environment from the App struct.
struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Must match your .xcdatamodeld file name exactly.
        container = NSPersistentContainer(name: "Incometrix")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else if let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
            // Store the SQLite file inside the shared App Group container instead
            // of the app's private sandbox, so the widget extension can read it too.
            let storeURL = groupURL.appendingPathComponent("Incometrix.sqlite")
            container.persistentStoreDescriptions.first?.url = storeURL
            print("✅ Incometrix: using shared store at \(storeURL.path)")
        } else {
            // This fires if appGroupID doesn't exactly match an App Group enabled
            // on THIS target's Signing & Capabilities. Each process then falls back
            // to its own private, unshared store — which is why the widget's account
            // picker comes up empty even though the app has accounts.
            print("⚠️ Incometrix: App Group '\(appGroupID)' not found for this target — falling back to a private, unshared store.")
        }

        // Load the store SYNCHRONOUSLY. NSPersistentContainer.loadPersistentStores
        // is asynchronous by default — fine for a long-lived app process, but a
        // widget extension can be launched fresh just to resolve a single
        // AppEntity (e.g. turning the account ID you picked in Edit Widget back
        // into an AccountEntity). If that resolution runs before the store has
        // finished attaching, the fetch comes back empty and WidgetKit silently
        // drops the selection — configuration.account ends up nil even though
        // you picked something. Blocking here is safe: it's a small local
        // SQLite file, and this only runs once at startup.
        let semaphore = DispatchSemaphore(value: 0)
        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
            semaphore.signal()
        }
        semaphore.wait()

        if let loadError {
            // Fine to crash here: it means the on-disk store didn't load
            // (corrupt file, migration failure, etc.). Handle more gracefully in production.
            fatalError("Unresolved Core Data error: \(loadError)")
        }

        // Automatically picks up changes made in background contexts.
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Saves the main view context if there are pending changes.
    func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            // Replace with real error handling (e.g. surfacing an alert) in production.
            let nsError = error as NSError
            print("Error saving context: \(nsError), \(nsError.userInfo)")
        }
    }

    // MARK: - Preview / sample data

    /// In-memory store pre-populated with sample data, used by SwiftUI #Preview blocks.
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        let checking = Account.create(name: "Checking", initialBalance: 1250, in: context)
        let savings = Account.create(name: "Savings", initialBalance: 4200, in: context)

        Transaction.create(amount: -45.50, category: "Groceries", note: nil, date: .now, account: checking, in: context)
        Transaction.create(amount: 2500, category: "Salary", note: "September pay", date: .now, account: checking, in: context)
        Transaction.create(amount: -120, category: "Utilities", note: nil, date: .now, account: savings, in: context)

        let goal = Goal.create(title: "Emergency Fund", targetAmount: 3000, deadline: nil, in: context)
        goal.currentAmount = 800

        do {
            try context.save()
        } catch {
            fatalError("Preview data error: \(error)")
        }

        return controller
    }()
}
