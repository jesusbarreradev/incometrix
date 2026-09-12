import Foundation
import CoreData

extension Transaction {

    var formattedAmount: String { amount.asCurrency }

    /// Convention used here: negative amount = expense, positive = income.
    var isExpense: Bool { amount < 0 }

    /// Creates a transaction attached to `account` and keeps the account's
    /// denormalized `balance` field in sync. See CoreData_Guide.md for why
    /// balance is stored instead of always recomputed.
    @discardableResult
    static func create(
        amount: Double,
        category: String?,
        note: String?,
        date: Date,
        account: Account,
        in context: NSManagedObjectContext
    ) -> Transaction {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.category = category
        transaction.note = note
        transaction.date = date
        transaction.account = account   // also updates the inverse `account.transactions` set

        account.balance += amount

        return transaction
    }
}
