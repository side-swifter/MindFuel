//
//  DashboardView.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import SwiftUI
import SwiftData
import UIKit

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var appUsages: [AppUsage]
    @Query private var alerts: [WellnessAlert]
    
    @State private var wellnessService = WellnessService.shared
    @State private var selectedTimeframe: TimeFrame = .today
    @State private var showingAlerts = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with logo and wellness score
                    headerView
                    
                    // Quick Stats Cards
                    statsCardsView
                    
                    // Screen Time Chart
                    screenTimeChartView
                    
                    // App Categories Breakdown
                    categoriesBreakdownView
                    
                    // Active Alerts Section
                    if !activeAlerts.isEmpty {
                        alertsPreviewView
                    }
                    
                    // Recent Apps Usage
                    recentAppsView
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color(UIColor.systemGroupedBackground))
            .sheet(isPresented: $showingAlerts) {
                AlertsView()
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            // Logo and App Name
            HStack {
                Image("Mindfuel Icon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading) {
                    Text("MindFuel")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Digital Wellness Dashboard")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Settings button
                Button(action: {}) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.primary)
                        .font(.title3)
                }
            }
            
            // Daily Wellness Score
            wellnessScoreView
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var wellnessScoreView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Today's Wellness Score")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Based on your app usage patterns")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Circular Progress
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: dailyWellnessScore / 10.0)
                    .stroke(
                        wellnessScoreColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: dailyWellnessScore)
                
                VStack {
                    Text("\(String(format: "%.1f", dailyWellnessScore))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(wellnessScoreColor)
                    
                    Text("/ 10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 80, height: 80)
        }
    }
    
    private var statsCardsView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatCard(
                title: "Screen Time",
                value: totalScreenTime.formattedTime,
                icon: "clock",
                color: .blue
            )
            
            StatCard(
                title: "Active Alerts",
                value: "\(activeAlerts.count)",
                icon: "exclamationmark.triangle",
                color: .red
            )
            
            StatCard(
                title: "Apps Used",
                value: "\(todaysAppUsages.count)",
                icon: "apps.iphone",
                color: .green
            )
            
            StatCard(
                title: "Productivity",
                value: "\(productivityPercentage)%",
                icon: "chart.line.uptrend.xyaxis",
                color: .orange
            )
        }
    }
    
    private var screenTimeChartView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Screen Time Breakdown")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            if !todaysAppUsages.isEmpty {
                VStack(spacing: 12) {
                    ForEach(Array(todaysAppUsages.prefix(5)), id: \.appName) { usage in
                        HStack {
                            Text(usage.appName)
                                .font(.subheadline)
                                .frame(width: 80, alignment: .leading)
                                .lineLimit(1)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 8)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                    
                                    Rectangle()
                                        .fill(Color(usage.category.color))
                                        .frame(
                                            width: max(20, geometry.size.width * CGFloat(usage.totalTimeSpent / totalScreenTime)),
                                            height: 8
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                            }
                            .frame(height: 8)
                            
                            Text(usage.totalTimeSpent.formattedTime)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 50, alignment: .trailing)
                        }
                    }
                }
                .frame(height: 200)
                .padding()
            } else {
                Text("No data available for today")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var categoriesBreakdownView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("App Categories")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(categoriesData, id: \.category) { data in
                    CategoryCard(
                        category: data.category,
                        timeSpent: data.timeSpent,
                        percentage: data.percentage
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var alertsPreviewView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Active Alerts")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    showingAlerts = true
                }
                .font(.subheadline)
                .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(activeAlerts.prefix(3)), id: \.id) { alert in
                        AlertPreviewCard(alert: alert)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var recentAppsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent App Usage")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            LazyVStack(spacing: 8) {
                ForEach(Array(todaysAppUsages.prefix(8)), id: \.appName) { usage in
                    AppUsageRow(usage: usage)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Computed Properties
    private var todaysAppUsages: [AppUsage] {
        let today = Calendar.current.startOfDay(for: Date())
        return appUsages
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
            .sorted { $0.totalTimeSpent > $1.totalTimeSpent }
    }
    
    private var activeAlerts: [WellnessAlert] {
        alerts.filter { !$0.dismissed }
    }
    
    private var totalScreenTime: TimeInterval {
        todaysAppUsages.reduce(0) { $0 + $1.totalTimeSpent }
    }
    
    private var dailyWellnessScore: Double {
        wellnessService.calculateDailyWellnessScore(for: Date(), appUsages: todaysAppUsages)
    }
    
    private var wellnessScoreColor: Color {
        if dailyWellnessScore >= 7.0 {
            return .green
        } else if dailyWellnessScore >= 4.0 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var productivityPercentage: Int {
        let totalTime = totalScreenTime
        guard totalTime > 0 else { return 0 }
        
        let productiveTime = todaysAppUsages
            .filter { $0.category.wellnessImpact == .positive }
            .reduce(0) { $0 + $1.totalTimeSpent }
        
        return Int((productiveTime / totalTime) * 100)
    }
    
    private var categoriesData: [(category: AppCategory, timeSpent: TimeInterval, percentage: Double)] {
        let grouped = Dictionary(grouping: todaysAppUsages) { $0.category }
        let totalTime = totalScreenTime
        
        return grouped.map { category, usages in
            let categoryTime = usages.reduce(0) { $0 + $1.totalTimeSpent }
            let percentage = totalTime > 0 ? (categoryTime / totalTime) * 100 : 0
            return (category: category, timeSpent: categoryTime, percentage: percentage)
        }.sorted { $0.timeSpent > $1.timeSpent }
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct CategoryCard: View {
    let category: AppCategory
    let timeSpent: TimeInterval
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Spacer()
                
                Circle()
                    .fill(Color(category.color))
                    .frame(width: 8, height: 8)
            }
            
            Text(timeSpent.formattedTime)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("\(String(format: "%.1f", percentage))% of total")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct AppUsageRow: View {
    let usage: AppUsage
    
    var body: some View {
        HStack {
            // App icon placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(usage.category.color).opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(usage.appName.prefix(1)))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(usage.category.color))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(usage.appName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(usage.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(usage.totalTimeSpent.formattedTime)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(usage.wellnessScore >= 6 ? .green : (usage.wellnessScore >= 4 ? .orange : .red))
                        .frame(width: 6, height: 6)
                    
                    Text(String(format: "%.1f", usage.wellnessScore))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct AlertPreviewCard: View {
    let alert: WellnessAlert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color(alert.severity.color))
                
                Text(alert.severity.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(alert.severity.color))
                
                Spacer()
            }
            
            Text(alert.alertTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            Text(alert.appName)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 200)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Enums
enum TimeFrame: String, CaseIterable {
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
}
