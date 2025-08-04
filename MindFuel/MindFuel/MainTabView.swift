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
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
            
            AlertsView()
                .tabItem {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Alerts")
                }
            
            SimpleAnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
            
            SimpleSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
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

// DashboardView is defined in DashboardView.swift

struct WellnessScoreCard: View {
    @StateObject private var wellnessService = WellnessAlertService.shared
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Wellness Score")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("Today")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 20) {
                // Wellness score circle
                ZStack {
                    Circle()
                        .stroke(.red.opacity(0.2), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: 0.75) // 75% for demo
                        .stroke(.red, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("7.5")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Text("Good")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 8) {
                    WellnessMetric(icon: "checkmark.circle.fill", text: "Healthy apps: 65%", color: .green)
                    WellnessMetric(icon: "exclamationmark.triangle.fill", text: "Risk apps: 25%", color: .orange)
                    WellnessMetric(icon: "xmark.circle.fill", text: "Harmful apps: 10%", color: .red)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct WellnessMetric: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 16)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct RiskAppsSection: View {
    @StateObject private var wellnessService = WellnessAlertService.shared
    
    // Mock data for risk apps
    private let riskApps = [
        ("Snapchat", "2h 15m", "High Risk", Color.red),
        ("Instagram", "1h 45m", "Medium Risk", Color.orange),
        ("TikTok", "45m", "Critical Risk", Color.purple)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Risk Apps")
                    .font(.headline)
                    .fontWeight(.semibold)
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Spacer()
                Button("Manage") {
                    // Navigate to risk management
                }
                .font(.caption)
                .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            if riskApps.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    Text("No Risk Apps Today!")
                        .font(.headline)
                        .fontWeight(.medium)
                    Text("Great job maintaining healthy digital habits")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            } else {
                ForEach(Array(riskApps.enumerated()), id: \.offset) { index, appData in
                    let appName = appData.1.0
                    let timeUsed = appData.1.1
                    let riskLevel = appData.1.2
                    let riskColor = appData.1.3
                    
                    HStack {
                        Image(systemName: "app.badge")
                            .foregroundColor(riskColor)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(appName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(timeUsed)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(riskLevel)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(riskColor.opacity(0.15))
                            .foregroundColor(riskColor)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct TopAppsSection: View {
    let appUsages: [AppUsage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top Apps Today")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("See All") {
                    // Navigate to detailed view
                }
                .font(.caption)
                .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            if appUsages.isEmpty {
                Text("No usage data available")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(appUsages) { usage in
                    HStack {
                        Image(systemName: "app.badge")
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading) {
                            Text(usage.appName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("\(Int(usage.usageTime / 60))m today")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(usage.category.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.red.opacity(0.1))
                            .foregroundColor(.red)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// Simple Analytics View - Just the essentials
struct SimpleAnalyticsView: View {
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    @State private var appUsageData: [AppUsageData] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Today's Summary
                VStack {
                    Text("Today's Screen Time")
                        .font(.headline)
                    Text("4h 32m")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Top Apps
                VStack(alignment: .leading) {
                    Text("Most Used Apps")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(appUsageData.prefix(5)) { app in
                        HStack {
                            Circle()
                                .fill(app.category == .social ? .red : .green)
                                .frame(width: 12, height: 12)
                            Text(app.appName)
                            Spacer()
                            Text("\(Int(app.usageTime/60))m")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
            .padding()
            .navigationTitle("Analytics")
            .task {
                appUsageData = await screenTimeManager.getDeviceActivity()
            }
        }
    }

}


struct SimpleSettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section("App Settings") {
                    SettingsRow(title: "Notifications", subtitle: "Wellness alerts", systemImage: "bell")
                    SettingsRow(title: "Screen Time Access", subtitle: "Grant usage data access", systemImage: "shield")
                }
                
                Section("About") {
                    SettingsRow(title: "Version", subtitle: "1.0.0", systemImage: "info.circle")
                    SettingsRow(title: "Support", subtitle: "Get help", systemImage: "questionmark.circle")
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
