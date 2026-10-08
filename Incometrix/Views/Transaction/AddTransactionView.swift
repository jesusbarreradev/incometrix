import SwiftUI

struct AddTransactionView: View {
    let account: Account

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var amountText = ""
    @State private var category = ""
    @State private var note = ""
    @State private var date = Date()
    @State private var isExpense = true
    @State private var selectedCategory: TransactionCategory?

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $isExpense) {
                    Text("Expense").tag(true)
                    Text("Income").tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: isExpense) { selectedCategory = nil }

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $selectedCategory) {
                    Text("Select").tag(TransactionCategory?.none)
                    ForEach(isExpense ? TransactionCategory.expense : TransactionCategory.income) { cat in
                        Text(cat.rawValue).tag(TransactionCategory?.some(cat))
                    }
                }
                TextField("Note", text: $note)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("New Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(Double(amountText) == nil)
                }
            }
        }
    }

    private func save() {
        guard let value = Double(amountText) else { return }
        let signedAmount = isExpense ? -abs(value) : abs(value)

        Transaction.create(
            amount: signedAmount,
            category: selectedCategory?.rawValue ?? "",
            note: note.isEmpty ? nil : note,
            date: date,
            account: account,
            in: viewContext
        )

        PersistenceController.shared.save()
        dismiss()
    }
}
