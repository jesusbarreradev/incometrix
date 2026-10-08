import SwiftUI
import CoreData

struct AccountsListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // @FetchRequest re-runs and refreshes the view automatically whenever
    // matching objects are inserted, updated, or deleted in this context.
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)])
    private var accounts: FetchedResults<Account>

    @State private var showingAddAccount = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(accounts) { account in
                    NavigationLink(value: account) {
                        HStack {
                            Text(account.name ?? "Untitled")
                            Spacer()
                            Text(account.formattedBalance)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteAccounts)
            }
            .navigationDestination(for: Account.self) { account in
                AccountDetailView(account: account)
            }
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAddAccount = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAccount) {
                AddAccountView()
            }
            .overlay {
                if accounts.isEmpty {
                    ContentUnavailableView("No Accounts", systemImage: "creditcard",
                                            description: Text("Tap + to add your first account."))
                }
            }
        }
    }

    private func deleteAccounts(at offsets: IndexSet) {
        offsets.map { accounts[$0] }.forEach(viewContext.delete)
        PersistenceController.shared.save()
    }
}
