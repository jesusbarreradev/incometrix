//
//  TransactionsTabView.swift
//  Incometrix
//
//  Created by cyberfortress on 24/09/26.
//

import SwiftUI

struct TransactionsTabView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)])
    private var accounts: FetchedResults<Account>
    @State private var selected: Set<Account> = []
    @State private var showingAddTransaction = false

    var body: some View {
        NavigationStack {
            TransactionsListView(accounts: selected)
                .id(selected) // rebuilds the FetchRequest
                .toolbar {
                    //Add transaction
                    ToolbarItem(placement: .primaryAction) {
                        Button { showingAddTransaction = true } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(){
                        Menu{
                            ForEach(accounts) { account in
                                Toggle(account.name ?? "", isOn: Binding(
                                    get: { selected.contains(account) },
                                    set: { isOn in
                                        if isOn {
                                            selected.insert(account)
                                        } else {
                                            selected.remove(account)
                                        }
                                    }
                                ))
                            }
                        } label: {
                            Label("Accounts", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
                    
                }
                .sheet(isPresented: $showingAddTransaction) {
                    AddTransactionView(account: nil)
                        .presentationDetents([.medium])
                }
        }
    }
}
