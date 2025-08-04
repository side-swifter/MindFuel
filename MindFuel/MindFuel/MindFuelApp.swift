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
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "onboardingComplete")
    
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
            if isOnboardingComplete {
                MainTabView()
                    .modelContainer(sharedModelContainer)
            } else {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    .modelContainer(sharedModelContainer)
            }
        }
    }
}
