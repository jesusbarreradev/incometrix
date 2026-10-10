//
//  TransationsListView.swift
//  Incometrix
//
//  Created by cyberfortress on 09/09/26.
//

import SwiftUI
import CoreData

struct TransactionsListView: View {
    //let account: Account

    @FetchRequest private var transactions: FetchedResults<Transaction>

    init(accounts: Set<Account> = []) {
        _transactions = FetchRequest<Transaction>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
            predicate: accounts.isEmpty ? nil : NSPredicate(format: "account IN %@", accounts)
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
        .navigationTitle("Transactions")
        .overlay{
            if transactions.isEmpty {
                ContentUnavailableView("No transactions", systemImage: "square.dashed.micro")
            }
        }
    }
}
