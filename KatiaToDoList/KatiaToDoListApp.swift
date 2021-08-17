//
//  KatiaToDoListApp.swift
//  KatiaToDoList
//
//  Created by Стас Жингель on 14.08.2021.
//

import SwiftUI

@main
struct KatiaToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
