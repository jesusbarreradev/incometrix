import SwiftUI
import CoreData

struct AddAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var initialBalance = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Account name", text: $name)
                TextField("Initial balance", text: $initialBalance)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Account")
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
        let balance = Double(initialBalance) ?? 0
        Account.create(name: name, initialBalance: balance, in: viewContext)
        PersistenceController.shared.save()
        dismiss()
    }
}
