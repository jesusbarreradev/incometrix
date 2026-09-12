import SwiftUI
import CoreData

struct AccountDetailView: View {
    // @ObservedObject makes this view re-render when `account`'s attributes
    // (e.g. balance) change, since Account is an NSManagedObject (ObservableObject).
    @ObservedObject var account: Account

    @State private var showingAddTransaction = false
    @State private var showingEditAccount = false

    var body: some View {
        List {
            Section {
                Text(account.formattedBalance)
                    .font(.largeTitle.bold())
            }

            Section{
                if account.transactionsArray.isEmpty {
                    Text("No transactions yet.")
                        .foregroundStyle(.secondary)
                }
                ForEach(account.transactionsArray) { transaction in
                    TransactionRow(transaction: transaction)
                }
            } header: {
                HStack {
                    Text("Transactions")
                    Spacer()
                    NavigationLink("See all", destination: TransationsListView(account: account))
                }
            }
        }
        .navigationTitle(account.name ?? "Account")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showingAddTransaction = true } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .secondaryAction){
                Button { showingEditAccount = true } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView(account: account)
        }
        .sheet(isPresented: $showingEditAccount) {
            EditAccountView(account: account)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let account = try! context.fetch(Account.fetchRequest()).first!
    return NavigationStack {
        AccountDetailView(account: account)
    }
}
