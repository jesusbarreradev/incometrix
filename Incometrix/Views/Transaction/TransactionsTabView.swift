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

    var body: some View {
        NavigationStack {
            TransationsListView(accounts: selected)
                .id(selected) // rebuilds the FetchRequest
                .toolbar {
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
    }
}
