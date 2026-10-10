import CoreData
import WidgetKit

private let appGroupID =
    "group.com.AlejandroPalacios.Incometrix"

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {

        container = NSPersistentContainer(name: "Incometrix")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")

        } else {

            guard let groupURL =
                FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier: appGroupID
                )
            else {
                fatalError(
                    """
                    ❌ Incometrix: App Group '\(appGroupID)' is not available.

                    Make sure this App Group is enabled for BOTH:
                    - Incometrix
                    - IncometrixWidget
                    """
                )
            }

            let storeURL =
                groupURL.appendingPathComponent("Incometrix.sqlite")

            let description =
                NSPersistentStoreDescription(url: storeURL)

            // Allow lightweight migrations.
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true

            container.persistentStoreDescriptions = [
                description
            ]
            print(storeURL.path)
        }


        var loadError: Error?

        container.loadPersistentStores { description, error in

            loadError = error
        }

        if let loadError {
            fatalError(
                "❌ Unresolved Core Data error: \(loadError)"
            )
        }

        container.viewContext.automaticallyMergesChangesFromParent =
            true

        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
    }

    func save() {

        let context = container.viewContext

        guard context.hasChanges else {
            return
        }

        do {

            try context.save()

            WidgetCenter.shared.reloadAllTimelines()

        } catch {

            let nsError = error as NSError
        }
    }
}
