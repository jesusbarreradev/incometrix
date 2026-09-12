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

enum TransactionCategory: String, CaseIterable, Identifiable {
    case vivienda = "Vivienda", alimentacion = "Alimentación", transporte = "Transporte",
         servicios = "Servicios", salud = "Salud", educacion = "Educación",
         comprasPersonales = "Compras personales", entretenimiento = "Entretenimiento y ocio",
         deudas = "Deudas y créditos", viajes = "Viajes y vacaciones"

    case sueldo = "Sueldo", bonos = "Bonos", comisiones = "Comisiones",
         trabajoIndependiente = "Trabajo independiente", negocioPropio = "Negocio propio",
         inversiones = "Inversiones", rentas = "Rentas", intereses = "Intereses",
         regalias = "Regalías", otrosIngresos = "Otros ingresos"

    var id: String { rawValue }

    static var expense: [TransactionCategory] {
        [.vivienda, .alimentacion, .transporte, .servicios, .salud,
         .educacion, .comprasPersonales, .entretenimiento, .deudas, .viajes]
    }
    static var income: [TransactionCategory] {
        [.sueldo, .bonos, .comisiones, .trabajoIndependiente, .negocioPropio,
         .inversiones, .rentas, .intereses, .regalias, .otrosIngresos]
    }
}
