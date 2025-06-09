//
//  MovieAppApp.swift
//  MovieApp
//

import SwiftUI
import SwiftData

@main
struct MovieAppApp: App {
    @StateObject private var networkMonitor = NetworkMonitor.shared
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                MovieListView()
                    
                if !networkMonitor.isConnected {
                    NetworkStatusBanner()
                        .animation(.easeInOut, value: networkMonitor.isConnected)
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
