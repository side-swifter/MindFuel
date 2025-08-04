//
//  WellnessAlertService.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import Foundation
import SwiftUI

@MainActor
class WellnessAlertService: ObservableObject {
    static let shared = WellnessAlertService()
    
    @Published var activeAlerts: [WellnessAlert] = []
    @Published var showingAlert = false
    @Published var currentAlert: WellnessAlert?
    
    // Harmful apps database with detailed wellness information
    private let harmfulApps: [String: HarmfulAppInfo] = [
        "com.snapchat.snapchat": HarmfulAppInfo(
            name: "Snapchat",
            category: .social,
            harmLevel: .high,
            issues: [
                "Addictive streak system keeps you coming back",
                "FOMO from friends' stories and snaps",
                "Promotes superficial interactions",
                "Can impact self-esteem through appearance filters"
            ],
            recommendations: [
                "Turn off streak notifications",
                "Limit to 30 minutes per day",
                "Use without filters to maintain realistic self-image",
                "Consider deleting if usage exceeds 2 hours daily"
            ],
            wellnessScore: 2.5
        ),
        "com.instagram.instagram": HarmfulAppInfo(
            name: "Instagram",
            category: .social,
            harmLevel: .high,
            issues: [
                "Comparison culture can harm mental health",
                "Infinite scroll design promotes excessive usage",
                "Curated content creates unrealistic expectations",
                "Can trigger anxiety and depression"
            ],
            recommendations: [
                "Unfollow accounts that make you feel bad",
                "Use time limits (max 45 minutes/day)",
                "Turn off read receipts and activity status",
                "Follow accounts focused on your interests, not lifestyle"
            ],
            wellnessScore: 3.0
        ),
        "com.tiktok.tiktok": HarmfulAppInfo(
            name: "TikTok",
            category: .social,
            harmLevel: .critical,
            issues: [
                "Extremely addictive algorithm",
                "Can waste hours without realizing",
                "May expose to inappropriate content",
                "Disrupts sleep patterns and attention span"
            ],
            recommendations: [
                "Set strict daily time limits (max 30 minutes)",
                "Use app timers and stick to them",
                "Avoid using before bedtime",
                "Consider taking regular breaks from the app"
            ],
            wellnessScore: 1.5
        ),
        "com.twitter.twitter": HarmfulAppInfo(
            name: "Twitter/X",
            category: .social,
            harmLevel: .medium,
            issues: [
                "Can increase anxiety with constant news updates",
                "Promotes mindless scrolling",
                "Echo chambers can polarize opinions",
                "Negative content can impact mood"
            ],
            recommendations: [
                "Curate your feed to include positive accounts",
                "Turn off push notifications",
                "Use lists instead of main timeline",
                "Take breaks during stressful news cycles"
            ],
            wellnessScore: 4.0
        )
    ]
    
    private init() {}
    
    func checkAppUsage(_ appUsage: [AppUsageData]) {
        for usage in appUsage {
            if let harmfulApp = harmfulApps[usage.bundleIdentifier] {
                checkForWellnessIssues(usage: usage, harmfulApp: harmfulApp)
            }
        }
    }
    
    private func checkForWellnessIssues(usage: AppUsageData, harmfulApp: HarmfulAppInfo) {
        let usageMinutes = usage.usageTime / 60
        
        // Check if usage exceeds healthy thresholds
        let threshold = thresholdForHarmLevel(harmfulApp.harmLevel)
        
        if usageMinutes > threshold {
            createAlert(for: usage, harmfulApp: harmfulApp, usageMinutes: usageMinutes)
        }
    }
    
    private func thresholdForHarmLevel(_ level: HarmLevel) -> Double {
        switch level {
        case .low: return 120 // 2 hours
        case .medium: return 90 // 1.5 hours
        case .high: return 60 // 1 hour
        case .critical: return 30 // 30 minutes
        }
    }
    
    private func createAlert(for usage: AppUsageData, harmfulApp: HarmfulAppInfo, usageMinutes: Double) {
        let alert = WellnessAlert(
            appName: harmfulApp.name,
            alertTitle: "Excessive \(harmfulApp.name) Usage Detected",
            alertDescription: "You've spent \(Int(usageMinutes)) minutes on \(harmfulApp.name) today. This app may be impacting your digital wellness.",
            recommendations: harmfulApp.recommendations,
            timeSpentToday: usage.usageTime,
            severity: severityForHarmLevel(harmfulApp.harmLevel)
        )
        
        activeAlerts.append(alert)
        
        // Show the alert if it's high priority
        if alert.severity == .high || alert.severity == .critical {
            showAlert(alert)
        }
    }
    
    private func severityForHarmLevel(_ level: HarmLevel) -> AlertSeverity {
        switch level {
        case .low: return .low
        case .medium: return .medium
        case .high: return .high
        case .critical: return .critical
        }
    }
    
    func showAlert(_ alert: WellnessAlert) {
        currentAlert = alert
        showingAlert = true
    }
    
    func dismissAlert(_ alert: WellnessAlert) {
        if let index = activeAlerts.firstIndex(where: { $0.id == alert.id }) {
            activeAlerts[index].dismissed = true
        }
        if currentAlert?.id == alert.id {
            currentAlert = nil
            showingAlert = false
        }
    }
    
    func getHarmfulAppInfo(for bundleID: String) -> HarmfulAppInfo? {
        return harmfulApps[bundleID]
    }
}

struct HarmfulAppInfo {
    let name: String
    let category: AppCategory
    let harmLevel: HarmLevel
    let issues: [String]
    let recommendations: [String]
    let wellnessScore: Double // 1.0 (very harmful) to 10.0 (very beneficial)
}

enum HarmLevel {
    case low, medium, high, critical
    
    var color: Color {
        switch self {
        case .low: return .yellow
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Mild Concern"
        case .medium: return "Moderate Risk"
        case .high: return "High Risk"
        case .critical: return "Critical Risk"
        }
    }
}
