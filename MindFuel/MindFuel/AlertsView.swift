//
//  AlertsView.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import SwiftUI
import SwiftData

struct AlertsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var alerts: [WellnessAlert]
    
    @State private var selectedAlert: WellnessAlert?
    @State private var showingDetailSheet = false
    
    var body: some View {
        NavigationView {
            List {
                if activeAlerts.isEmpty {
                    emptyStateView
                } else {
                    ForEach(activeAlerts, id: \.id) { alert in
                        AlertRowView(alert: alert) {
                            selectedAlert = alert
                            showingDetailSheet = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Dismiss") {
                                dismissAlert(alert)
                            }
                            .tint(.red)
                        }
                    }
                }
                
                if !dismissedAlerts.isEmpty {
                    Section("Recently Dismissed") {
                        ForEach(dismissedAlerts.prefix(5), id: \.id) { alert in
                            AlertRowView(alert: alert, isDismissed: true) {
                                selectedAlert = alert
                                showingDetailSheet = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Wellness Alerts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                if !activeAlerts.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Dismiss All") {
                            dismissAllAlerts()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .sheet(isPresented: $showingDetailSheet) {
            if let alert = selectedAlert {
                AlertDetailView(alert: alert) { updatedAlert in
                    if let index = alerts.firstIndex(where: { $0.id == updatedAlert.id }) {
                        alerts[index].dismissed = updatedAlert.dismissed
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                Text("All Clear!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("You currently have no wellness alerts. Keep up the healthy digital habits!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .listRowBackground(Color.clear)
    }
    
    private var activeAlerts: [WellnessAlert] {
        alerts.filter { !$0.dismissed }
            .sorted { $0.severity.hashValue > $1.severity.hashValue }
    }
    
    private var dismissedAlerts: [WellnessAlert] {
        alerts.filter { $0.dismissed }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    private func dismissAlert(_ alert: WellnessAlert) {
        withAnimation {
            alert.dismissed = true
            try? modelContext.save()
        }
    }
    
    private func dismissAllAlerts() {
        withAnimation {
            for alert in activeAlerts {
                alert.dismissed = true
            }
            try? modelContext.save()
        }
    }
}

struct AlertRowView: View {
    let alert: WellnessAlert
    let isDismissed: Bool
    let onTap: () -> Void
    
    init(alert: WellnessAlert, isDismissed: Bool = false, onTap: @escaping () -> Void) {
        self.alert = alert
        self.isDismissed = isDismissed
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Severity indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(alert.severity.color))
                            .frame(width: 8, height: 8)
                        
                        Text(alert.severity.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(alert.severity.color))
                    }
                    
                    Spacer()
                    
                    // Time stamp
                    Text(alert.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Alert title
                Text(alert.alertTitle)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                // App name and time spent
                HStack {
                    Label(alert.appName, systemImage: "app")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Time: \(alert.timeSpentToday.formattedTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Brief description
                Text(alert.alertDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Recommendations preview
                if !alert.recommendations.isEmpty {
                    HStack {
                        Image(systemName: "lightbulb")
                            .foregroundColor(.orange)
                            .font(.caption)
                        
                        Text("\(alert.recommendations.count) recommendations available")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                }
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isDismissed ? Color(.systemGray6) : Color(.systemBackground))
                .shadow(
                    color: isDismissed ? .clear : .black.opacity(0.05),
                    radius: 3,
                    x: 0,
                    y: 1
                )
        )
        .opacity(isDismissed ? 0.6 : 1.0)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

struct AlertDetailView: View {
    let alert: WellnessAlert
    let onUpdate: (WellnessAlert) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var isDismissed: Bool
    
    init(alert: WellnessAlert, onUpdate: @escaping (WellnessAlert) -> Void) {
        self.alert = alert
        self.onUpdate = onUpdate
        self._isDismissed = State(initialValue: alert.dismissed)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with severity and app info
                    headerView
                    
                    // Main description
                    descriptionView
                    
                    // Recommendations
                    recommendationsView
                    
                    // Action buttons
                    actionButtonsView
                }
                .padding()
            }
            .navigationTitle("Wellness Alert")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isDismissed ? "Undismiss" : "Dismiss") {
                        toggleDismissed()
                    }
                    .foregroundColor(isDismissed ? .blue : .red)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Severity badge
            HStack {
                Image(systemName: severityIcon)
                    .foregroundColor(Color(alert.severity.color))
                    .font(.title2)
                
                Text(alert.severity.rawValue + " Alert")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(alert.severity.color))
                
                Spacer()
            }
            .padding()
            .background(Color(alert.severity.color).opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // App and time info
            VStack(alignment: .leading, spacing: 8) {
                Label(alert.appName, systemImage: "app.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Label("Time Spent Today", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(alert.timeSpentToday.formattedTime)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Label("Alert Triggered", systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(alert.timestamp, style: .date)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(alert.alertTitle)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(alert.alertDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var recommendationsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                
                Text("Recommendations")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(Array(alert.recommendations.enumerated()), id: \.offset) { index, recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(.red))
                        
                        Text(recommendation)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            // Set app limit button
            Button(action: {
                // TODO: Implement app limit setting
            }) {
                HStack {
                    Image(systemName: "timer")
                    Text("Set Time Limit for \(alert.appName)")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // View detailed analytics
            Button(action: {
                // TODO: Navigate to app analytics
            }) {
                HStack {
                    Image(systemName: "chart.bar")
                    Text("View Detailed Analytics")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var severityIcon: String {
        switch alert.severity {
        case .low: return "info.circle.fill"
        case .medium: return "exclamationmark.triangle.fill"
        case .high: return "exclamationmark.octagon.fill"
        case .critical: return "exclamationmark.triangle.fill"
        }
    }
    
    private func toggleDismissed() {
        isDismissed.toggle()
        var updatedAlert = alert
        updatedAlert.dismissed = isDismissed
        onUpdate(updatedAlert)
        dismiss()
    }
}

#Preview {
    AlertsView()
        .modelContainer(for: WellnessAlert.self, inMemory: true)
}
