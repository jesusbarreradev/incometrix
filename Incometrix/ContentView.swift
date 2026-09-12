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

                GoalsListView()
                    .tabItem { Label("Goals", systemImage: "target") }
            }
        }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
