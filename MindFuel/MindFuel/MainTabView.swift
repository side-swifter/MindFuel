//
//  MainTabView.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @State private var wellnessService = WellnessService.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Tab
            DashboardView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Dashboard")
                }
                .tag(0)
            
            // Analytics Tab
            AnalyticsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                    Text("Analytics")
                }
                .tag(1)
            
            // Goals Tab
            GoalsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "target" : "scope")
                    Text("Goals")
                }
                .tag(2)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.red) // Brand color
        .onAppear {
            setupInitialData()
        }
    }
    
    private func setupInitialData() {
        // Check if we need to populate with mock data for demo purposes
        let descriptor = FetchDescriptor<AppUsage>()
        if let existingData = try? modelContext.fetch(descriptor), existingData.isEmpty {
            // Add mock data for demonstration
            let mockUsages = wellnessService.generateMockData()
            for usage in mockUsages {
                modelContext.insert(usage)
                
                // Generate alerts for problematic apps
                if let alert = wellnessService.generateWellnessAlert(for: usage) {
                    modelContext.insert(alert)
                }
            }
            
            try? modelContext.save()
        }
    }
}

// Placeholder views for other tabs
struct AnalyticsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Detailed Analytics")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("In-depth analysis of your digital wellness trends will be available here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button("Coming Soon") {
                    // Future implementation
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }
            .navigationTitle("Analytics")
        }
    }
}

struct GoalsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "target")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Wellness Goals")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Set and track your digital wellness goals. Create custom targets for screen time, app usage, and productivity.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button("Coming Soon") {
                    // Future implementation
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }
            .navigationTitle("Goals")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section("App Settings") {
                    SettingsRow(title: "Notifications", subtitle: "Configure wellness alerts", systemImage: "bell")
                    SettingsRow(title: "Screen Time Permissions", subtitle: "Grant access to usage data", systemImage: "shield")
                    SettingsRow(title: "App Categories", subtitle: "Customize app classifications", systemImage: "folder")
                }
                
                Section("Wellness Settings") {
                    SettingsRow(title: "Alert Thresholds", subtitle: "Customize when alerts trigger", systemImage: "exclamationmark.triangle")
                    SettingsRow(title: "Wellness Scoring", subtitle: "Adjust scoring parameters", systemImage: "speedometer")
                    SettingsRow(title: "Goals & Targets", subtitle: "Set your wellness objectives", systemImage: "target")
                }
                
                Section("Data & Privacy") {
                    SettingsRow(title: "Data Export", subtitle: "Export your wellness data", systemImage: "square.and.arrow.up")
                    SettingsRow(title: "Privacy Settings", subtitle: "Control data sharing", systemImage: "hand.raised")
                    SettingsRow(title: "Reset Data", subtitle: "Clear all app data", systemImage: "trash", isDestructive: true)
                }
                
                Section("About") {
                    SettingsRow(title: "Version", subtitle: "1.0.0 (Beta)", systemImage: "info.circle")
                    SettingsRow(title: "Support", subtitle: "Get help and feedback", systemImage: "questionmark.circle")
                    SettingsRow(title: "Privacy Policy", subtitle: "Review our privacy practices", systemImage: "doc.text")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let isDestructive: Bool
    
    init(title: String, subtitle: String, systemImage: String, isDestructive: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.isDestructive = isDestructive
    }
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(isDestructive ? .red : .blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(isDestructive ? .red : .primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Handle settings navigation
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [AppUsage.self, WellnessAlert.self], inMemory: true)
}
