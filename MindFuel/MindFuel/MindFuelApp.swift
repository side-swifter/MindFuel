//
//  MindFuelApp.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import SwiftUI
import SwiftData

@main
struct MindFuelApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AppUsage.self,
            WellnessAlert.self,
            DailyWellnessSummary.self,
            WellnessGoal.self
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
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
