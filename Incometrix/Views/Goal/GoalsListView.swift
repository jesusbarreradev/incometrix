import SwiftUI
import CoreData

struct GoalsListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.title, ascending: true)])
    private var goals: FetchedResults<Goal>

    @State private var showingAddGoal = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(goals) { goal in
                    GoalRow(goal: goal)
                }
                .onDelete(perform: deleteGoals)
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAddGoal = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
                    .presentationDetents([.medium])
            }
            .overlay {
                if goals.isEmpty {
                    ContentUnavailableView("No Goals", systemImage: "target",
                                            description: Text("Tap + to add your first savings goal."))
                }
            }
        }
    }

    private func deleteGoals(at offsets: IndexSet) {
        offsets.map { goals[$0] }.forEach(viewContext.delete)
        PersistenceController.shared.save()
    }
}
