import AppIntents
import CoreData

/// A lightweight, Sendable stand-in for `Account` that AppIntents can show
/// in the widget's "Edit Widget" picker. It only carries what the UI needs
/// (id + name) — never the managed object itself, which isn't Sendable.
struct AccountEntity: AppEntity {
    let id: UUID
    let name: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Account"
    static var defaultQuery = AccountQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

/// Fetches Accounts from the shared Core Data store to populate the picker.
struct AccountQuery: EntityQuery {
    private var context: NSManagedObjectContext { PersistenceController.shared.container.viewContext }

    func entities(for identifiers: [AccountEntity.ID]) async throws -> [AccountEntity] {
        try await context.perform {
            let request = Account.fetchRequest()
            request.predicate = NSPredicate(format: "id IN %@", identifiers)
            return try context.fetch(request).compactMap(Self.makeEntity)
        }
    }

    func suggestedEntities() async throws -> [AccountEntity] {
        try await context.perform {
            let request = Account.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Account.name, ascending: true)]
            return try context.fetch(request).compactMap(Self.makeEntity)
        }
    }

    func defaultResult() async -> AccountEntity? {
        try? await suggestedEntities().first
    }

    private static func makeEntity(from account: Account) -> AccountEntity? {
        guard let id = account.id, let name = account.name else { return nil }
        return AccountEntity(id: id, name: name)
    }
}
