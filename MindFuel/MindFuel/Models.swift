//
//  Models.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import Foundation
import SwiftData

// MARK: - Enums
enum TimeframeSelection: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    
    var displayName: String {
        return self.rawValue
    }
}

enum AppCategory: String, CaseIterable, Codable {
    case social = "Social Media"
    case entertainment = "Entertainment"
    case productivity = "Productivity"
    case education = "Education"
    case health = "Health & Fitness"
    case news = "News"
    case games = "Games"
    case shopping = "Shopping"
    case utilities = "Utilities"
    case unknown = "Unknown"
    
    var displayName: String {
        return self.rawValue
    }
    
    var wellnessImpact: WellnessImpact {
        switch self {
        case .social, .entertainment, .games:
            return .negative
        case .education, .health, .productivity:
            return .positive
        case .news, .utilities:
            return .neutral
        case .shopping, .unknown:
            return .neutral
        }
    }
    
    var color: String {
        switch wellnessImpact {
        case .positive: return "green"
        case .neutral: return "gray"
        case .negative: return "red"
        }
    }
}

enum WellnessImpact: String, Codable {
    case positive = "Positive"
    case neutral = "Neutral"
    case negative = "Negative"
}

enum AlertSeverity: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: String {
        switch self {
        case .low: return "blue"
        case .medium: return "yellow"
        case .high: return "orange"
        case .critical: return "red"
        }
    }
}

enum GoalType: String, CaseIterable, Codable {
    case reduceScreenTime = "Reduce Screen Time"
    case limitAppUsage = "Limit App Usage"
    case increaseProductivity = "Increase Productivity"
    case digitalDetox = "Digital Detox"
    case improveBalance = "Improve Balance"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - App Usage Model
@Model
final class AppUsage {
    var appName: String
    var bundleIdentifier: String
    var totalTimeSpent: TimeInterval // in seconds
    var sessionCount: Int
    var lastUsed: Date
    var date: Date
    var category: AppCategory
    var wellnessScore: Double // 0.0 (harmful) to 10.0 (beneficial)
    
    init(appName: String, bundleIdentifier: String, totalTimeSpent: TimeInterval, sessionCount: Int, lastUsed: Date, date: Date, category: AppCategory, wellnessScore: Double) {
        self.appName = appName
        self.bundleIdentifier = bundleIdentifier
        self.totalTimeSpent = totalTimeSpent
        self.sessionCount = sessionCount
        self.lastUsed = lastUsed
        self.date = date
        self.category = category
        self.wellnessScore = wellnessScore
    }
}

// MARK: - Wellness Alert Model
@Model
final class WellnessAlert {
    var id: String
    var appName: String
    var alertTitle: String
    var alertDescription: String
    var recommendations: [String]
    var timeSpentToday: TimeInterval
    var severity: AlertSeverity
    var timestamp: Date
    var dismissed: Bool
    
    init(appName: String, alertTitle: String, alertDescription: String, recommendations: [String], timeSpentToday: TimeInterval, severity: AlertSeverity) {
        self.id = UUID().uuidString
        self.appName = appName
        self.alertTitle = alertTitle
        self.alertDescription = alertDescription
        self.recommendations = recommendations
        self.timeSpentToday = timeSpentToday
        self.severity = severity
        self.timestamp = Date()
        self.dismissed = false
    }
}

// MARK: - Daily Wellness Summary
@Model
final class DailyWellnessSummary {
    var date: Date
    var totalScreenTime: TimeInterval
    var wellnessScore: Double // Overall daily score 0.0-10.0
    var mostUsedApps: [String]
    var positiveAppsTime: TimeInterval
    var negativeAppsTime: TimeInterval
    var alertsTriggered: Int
    var goals: [WellnessGoal]
    
    init(date: Date) {
        self.date = date
        self.totalScreenTime = 0
        self.wellnessScore = 5.0
        self.mostUsedApps = []
        self.positiveAppsTime = 0
        self.negativeAppsTime = 0
        self.alertsTriggered = 0
        self.goals = []
    }
}

// MARK: - Wellness Goal Model
@Model
final class WellnessGoal {
    var id: String
    var title: String
    var goalDescription: String
    var targetValue: Double // Could be time limit, usage reduction, etc.
    var currentValue: Double
    var goalType: GoalType
    var deadline: Date?
    var isCompleted: Bool
    var createdDate: Date
    
    init(title: String, description: String, targetValue: Double, goalType: GoalType, deadline: Date? = nil) {
        self.id = UUID().uuidString
        self.title = title
        self.goalDescription = description
        self.targetValue = targetValue
        self.currentValue = 0.0
        self.goalType = goalType
        self.deadline = deadline
        self.isCompleted = false
        self.createdDate = Date()
    }
}


