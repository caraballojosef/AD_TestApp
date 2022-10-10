//
//  ApplyDigitalTestApp.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import SwiftUI

@main
struct ApplyDigitalTestApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var postViewModel = PostViewModel(service: ServiceImplementation())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(postViewModel)
        }
    }
}
