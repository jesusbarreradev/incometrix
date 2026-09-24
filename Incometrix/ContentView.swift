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
                    .tabItem { Label("Accounts", systemImage: "creditcard") }
                
                AccountsListView()
                    .tabItem { Label("Transactions", systemImage: "dollarsign") }
                
                AccountsListView()
                    .tabItem { Label("Metrics", systemImage: "chart.pie.fill") }
                
                GoalsListView()
                    .tabItem { Label("Goals", systemImage: "target") }
                
                GoalsListView()
                    .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            }
        }
}
