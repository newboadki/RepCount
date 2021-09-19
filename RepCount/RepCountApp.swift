//
//  RepCountApp.swift
//  RepCount
//
//  Created by Borja Arias Drake on 19.09.2021..
//

import SwiftUI

@main
struct RepCountApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
