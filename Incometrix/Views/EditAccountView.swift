//
//  EditAccountView.swift
//  Incometrix
//
//  Created by cyberfortress on 09/09/26.
//

import SwiftUI
import CoreData

struct EditAccountView: View {
    @ObservedObject var account: Account
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var balanceText: String
    
    init(account: Account) {
        self.account = account
        _name = State(initialValue: account.name ?? "")
        _balanceText = State(initialValue: String(account.balance))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Account name", text: $name)
                TextField("Balance", text: $balanceText)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Edit Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func save() {
        account.name = name
        account.balance = Double(balanceText) ?? account.balance
        PersistenceController.shared.save()
        dismiss()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let account = try! context.fetch(Account.fetchRequest()).first!
    return EditAccountView(account: account)
}
