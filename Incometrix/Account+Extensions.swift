import Foundation
import CoreData


// NOTE: `Account` itself (its @NSManaged properties: id, name, balance, createdAt,
// transactions) is generated automatically by Xcode from the .xcdatamodeld file
// because Codegen is set to "Class Definition". This file only adds convenience
// helpers on top of the generated class — it never redeclares stored properties.

extension Account {

    /// The to-many `transactions` relationship comes back as an NSSet; this exposes
    /// it as a sorted, typed array that's easy to use in SwiftUI Lists.
    var transactionsArray: [Transaction] {
        let set = transactions as? Set<Transaction> ?? []
        return set.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
    }

    var formattedBalance: String { balance.asCurrency }

    @discardableResult
    static func create(name: String, initialBalance: Double, in context: NSManagedObjectContext) -> Account {
        let account = Account(context: context)
        account.id = UUID()
        account.name = name
        account.balance = initialBalance
        account.createdAt = Date()
        return account
    }
}
