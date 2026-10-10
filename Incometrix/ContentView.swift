//
//  ContentView.swift
//  Incometrix
//
//  Created by cyberfortress on 09/09/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
            TabView {
                AccountsListView()
                    .tabItem { Label("Accounts", systemImage: "creditcard.fill") }
                
                TransactionsTabView()
                    .tabItem { Label("Transactions", systemImage: "dollarsign.circle.fill") }
                
                ChartsHomeView()
                    .tabItem { Label("Metrics", systemImage: "chart.pie.fill") }
                
                GoalsListView()
                    .tabItem { Label("Goals", systemImage: "target") }
                
                BudgetListView()
                    .tabItem { Label("Budget", systemImage: "wallet.bifold.fill") }
            }
        }
}
