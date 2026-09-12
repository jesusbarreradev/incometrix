//
//  TransationsListView.swift
//  Incometrix
//
//  Created by cyberfortress on 09/09/26.
//

import SwiftUI
import CoreData

struct TransationsListView: View {
    let account: Account

    @FetchRequest private var transactions: FetchedResults<Transaction>

    init(account: Account) {
        self.account = account
        _transactions = FetchRequest<Transaction>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
            predicate: NSPredicate(format: "account == %@", account)
        )
    }

    private var groupedTransactions: [(day: Date, items: [Transaction])] {
        let grouped = Dictionary(grouping: transactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date ?? .distantPast)
        }
        return grouped
            .map { (day: $0.key, items: $0.value.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }) }
            .sorted { $0.day > $1.day }
    }
    
    var body: some View {
        if account.transactionsArray.isEmpty {
            Text("No transactions yet.")
                .foregroundStyle(.secondary)
        }
        List {
            ForEach(groupedTransactions, id: \.day) { section in
                Section {
                    ForEach(section.items) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                } header: {
                    Text(section.day, style: .date)
                }
            }
        }
        .navigationTitle(account.name ?? "Transactions")
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let account = try! context.fetch(Account.fetchRequest()).first!
    TransationsListView(account: account)
}
