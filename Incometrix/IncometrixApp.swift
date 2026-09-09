//
//  IncometrixApp.swift
//  Incometrix
//
//  Created by cyberfortress on 09/09/26.
//

import SwiftUI
import CoreData

@main
struct IncometrixApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
