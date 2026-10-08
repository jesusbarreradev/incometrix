//
//  TransactionRow.swift
//  Incometrix
//
//  Created by cyberfortress on 09/09/26.
//
import SwiftUI

struct TransactionRow: View{
    @ObservedObject var transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.category ?? "Uncategorized")
                if let date = transaction.date {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(transaction.formattedAmount)
                .foregroundStyle(transaction.isExpense ? .red : .green)
        }
    }
}
