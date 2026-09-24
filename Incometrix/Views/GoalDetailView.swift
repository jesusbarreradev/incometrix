import SwiftUI

struct GoalDetailView: View {
    @ObservedObject var goal: Goal
    @State private var amountText = ""
    let dateFormatter = DateFormatter()
    

    var body: some View {
        if goal.isCompleted {
            Label("Goal completed!", systemImage: "checkmark.seal.fill")
                .foregroundStyle(.green)
                .font(.headline)
        }
        if goal.hasDeadline {
            Image(systemName: "calendar")
        }
        Form {
            Section("Progress") {
                Text(goal.progressPercentText).font(.title2.bold())
                ProgressView(value: goal.progress)
                Text("\(goal.currentAmount.asCurrency) de \(goal.targetAmount.asCurrency)")
            }
            Section("Update amount") {
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                HStack {
                    Button("+") { update(sign: 1) }
                }
            }
        }
        .navigationTitle(goal.title ?? "Placeholder")
    }

    private func update(sign: Double) {
        guard let increment = Double(amountText) else { return }
        goal.currentAmount += increment
        PersistenceController.shared.save()
        amountText = ""
    }
}
