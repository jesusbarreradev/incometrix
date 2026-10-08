import SwiftUI

struct AddGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var targetAmount = ""
    @State private var currentAmount = ""
    @State private var deadline = Date()
    @State private var hasDeadline = false

    var body: some View {
        NavigationStack {
            Form {
                TextField("Goal name", text: $title)
                TextField("Current amount", text: $currentAmount)
                    .keyboardType(.decimalPad)
                    .numbersOnly($currentAmount, includeDecimal: true)
                TextField("Target amount", text: $targetAmount)
                    .keyboardType(.decimalPad)
                    .numbersOnly($targetAmount, includeDecimal: true)
                Toggle("Set deadline", isOn: $hasDeadline)
                if hasDeadline {
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
            }
            .navigationTitle("New Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.isEmpty || Double(targetAmount) == nil)
                }
            }
        }
    }

    private func save() {
        guard let target = Double(targetAmount) else { return }
        guard let current = Double(currentAmount) else { return }
        Goal.create(title: title, currentAmount: current, targetAmount: target, deadline: hasDeadline ? deadline : nil, in: viewContext)
        PersistenceController.shared.save()
        dismiss()
    }
}
