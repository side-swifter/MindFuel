//
//  WellnessService.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import Foundation
import SwiftData
import FamilyControls
import DeviceActivity

@Observable
class WellnessService {
    static let shared = WellnessService()
    private let modelContext: ModelContext?
    
    // App categorization database
    private let appCategoryMap: [String: (category: AppCategory, wellnessScore: Double)] = [
        // Social Media - Generally negative for mental health
        "com.snapchat.Snapchat": (.social, 2.0),
        "com.instagram.Instagram": (.social, 2.5),
        "com.facebook.Facebook": (.social, 2.0),
        "com.tiktok.TikTok": (.social, 1.5),
        "com.twitter.Twitter": (.social, 3.0),
        "com.linkedin.LinkedIn": (.social, 6.0),
        "com.reddit.Reddit": (.social, 3.5),
        "com.discord.Discord": (.social, 4.0),
        
        // Entertainment - Can be time-wasting
        "com.netflix.Netflix": (.entertainment, 4.0),
        "com.youtube.YouTube": (.entertainment, 3.5),
        "com.spotify.Spotify": (.entertainment, 6.0),
        "com.amazon.PrimeVideo": (.entertainment, 4.0),
        "com.hulu.Hulu": (.entertainment, 4.0),
        
        // Games - Generally time-consuming
        "com.supercell.ClashOfClans": (.games, 2.0),
        "com.king.CandyCrushSaga": (.games, 2.5),
        "com.roblox.Roblox": (.games, 3.0),
        "com.epicgames.Fortnite": (.games, 2.0),
        
        // Productivity - Positive for growth
        "com.apple.Notes": (.productivity, 8.0),
        "com.microsoft.Office": (.productivity, 8.5),
        "com.google.Gmail": (.productivity, 7.0),
        "com.slack.Slack": (.productivity, 7.5),
        "com.notion.Notion": (.productivity, 9.0),
        "com.todoist.Todoist": (.productivity, 8.5),
        "com.evernote.Evernote": (.productivity, 8.0),
        
        // Education - Highly positive
        "com.duolingo.Duolingo": (.education, 9.0),
        "com.khanacademy.KhanAcademy": (.education, 9.5),
        "com.coursera.Coursera": (.education, 9.0),
        "com.udemy.Udemy": (.education, 8.5),
        "com.apple.Books": (.education, 8.0),
        "com.kindle.Kindle": (.education, 8.5),
        
        // Health & Fitness - Positive
        "com.apple.Health": (.health, 9.0),
        "com.myfitnesspal.MyFitnessPal": (.health, 8.0),
        "com.nike.NikeRun": (.health, 8.5),
        "com.headspace.Headspace": (.health, 9.0),
        "com.calm.Calm": (.health, 9.0),
        
        // Utilities - Neutral
        "com.apple.calculator": (.utilities, 7.0),
        "com.apple.weather": (.utilities, 7.0),
        "com.apple.Maps": (.utilities, 7.5),
        "com.uber.Uber": (.utilities, 6.0),
        
        // News - Neutral to slightly negative
        "com.apple.news": (.news, 5.0),
        "com.cnn.CNN": (.news, 4.5),
        "com.nytimes.NYTimes": (.news, 6.0),
    ]
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    // MARK: - App Analysis
    func categorizeApp(bundleIdentifier: String, appName: String) -> (category: AppCategory, wellnessScore: Double) {
        if let knownApp = appCategoryMap[bundleIdentifier] {
            return knownApp
        }
        
        // Fallback categorization based on app name patterns
        let lowercaseName = appName.lowercased()
        
        if lowercaseName.contains("social") || lowercaseName.contains("chat") || lowercaseName.contains("message") {
            return (.social, 4.0)
        } else if lowercaseName.contains("game") || lowercaseName.contains("play") {
            return (.games, 3.0)
        } else if lowercaseName.contains("news") {
            return (.news, 5.0)
        } else if lowercaseName.contains("productivity") || lowercaseName.contains("work") || lowercaseName.contains("office") {
            return (.productivity, 7.5)
        } else if lowercaseName.contains("education") || lowercaseName.contains("learn") {
            return (.education, 8.0)
        } else if lowercaseName.contains("health") || lowercaseName.contains("fitness") {
            return (.health, 8.0)
        } else {
            return (.unknown, 5.0)
        }
    }
    
    // MARK: - Wellness Alerts
    func generateWellnessAlert(for appUsage: AppUsage) -> WellnessAlert? {
        let timeInMinutes = appUsage.totalTimeSpent / 60
        
        switch appUsage.category {
        case .social:
            if timeInMinutes > 120 { // More than 2 hours
                return createSocialMediaAlert(appUsage: appUsage, timeInMinutes: timeInMinutes)
            }
        case .games:
            if timeInMinutes > 90 { // More than 1.5 hours
                return createGamingAlert(appUsage: appUsage, timeInMinutes: timeInMinutes)
            }
        case .entertainment:
            if timeInMinutes > 180 { // More than 3 hours
                return createEntertainmentAlert(appUsage: appUsage, timeInMinutes: timeInMinutes)
            }
        default:
            break
        }
        
        return nil
    }
    
    private func createSocialMediaAlert(appUsage: AppUsage, timeInMinutes: Double) -> WellnessAlert {
        let severity: AlertSeverity = timeInMinutes > 240 ? .critical : (timeInMinutes > 180 ? .high : .medium)
        
        let recommendations = [
            "Consider setting a daily time limit for \(appUsage.appName)",
            "Try replacing some social media time with physical activities",
            "Use 'Do Not Disturb' mode during work or study hours",
            "Engage with friends and family in person instead",
            "Practice mindfulness or meditation for 10 minutes instead"
        ]
        
        return WellnessAlert(
            appName: appUsage.appName,
            alertTitle: "Excessive Social Media Usage",
            alertDescription: "You've spent \(String(format: "%.1f", timeInMinutes)) minutes on \(appUsage.appName) today. Extended social media use can negatively impact your mental health, sleep quality, and productivity. Studies show that excessive social media use is linked to increased anxiety, depression, and reduced life satisfaction.",
            recommendations: recommendations,
            timeSpentToday: appUsage.totalTimeSpent,
            severity: severity
        )
    }
    
    private func createGamingAlert(appUsage: AppUsage, timeInMinutes: Double) -> WellnessAlert {
        let severity: AlertSeverity = timeInMinutes > 180 ? .critical : .high
        
        let recommendations = [
            "Set gaming time limits and stick to them",
            "Take regular breaks every 30 minutes",
            "Try physical activities or outdoor games instead",
            "Use gaming time as a reward after completing tasks",
            "Consider educational or puzzle games that challenge your mind"
        ]
        
        return WellnessAlert(
            appName: appUsage.appName,
            alertTitle: "Extended Gaming Session",
            alertDescription: "You've been gaming for \(String(format: "%.1f", timeInMinutes)) minutes today. While gaming can be enjoyable, excessive gaming can lead to reduced physical activity, poor sleep patterns, and decreased social interaction. Consider balancing your screen time with other activities.",
            recommendations: recommendations,
            timeSpentToday: appUsage.totalTimeSpent,
            severity: severity
        )
    }
    
    private func createEntertainmentAlert(appUsage: AppUsage, timeInMinutes: Double) -> WellnessAlert {
        let severity: AlertSeverity = timeInMinutes > 300 ? .high : .medium
        
        let recommendations = [
            "Use entertainment apps mindfully - choose content intentionally",
            "Set specific times for entertainment consumption",
            "Try educational documentaries or podcasts instead",
            "Balance screen time with creative activities",
            "Consider reading a book or engaging in hobbies"
        ]
        
        return WellnessAlert(
            appName: appUsage.appName,
            alertTitle: "High Entertainment Consumption",
            alertDescription: "You've spent \(String(format: "%.1f", timeInMinutes)) minutes consuming entertainment content today. While entertainment is important for relaxation, excessive consumption can lead to decreased productivity and reduced engagement in real-world activities.",
            recommendations: recommendations,
            timeSpentToday: appUsage.totalTimeSpent,
            severity: severity
        )
    }
    
    // MARK: - Daily Wellness Calculation
    func calculateDailyWellnessScore(for date: Date, appUsages: [AppUsage]) -> Double {
        guard !appUsages.isEmpty else { return 5.0 }
        
        var totalTime: TimeInterval = 0
        var weightedScore: Double = 0
        
        for usage in appUsages {
            let timeWeight = usage.totalTimeSpent
            totalTime += timeWeight
            weightedScore += usage.wellnessScore * timeWeight
        }
        
        let baseScore = totalTime > 0 ? weightedScore / totalTime : 5.0
        
        // Adjust score based on total screen time
        let totalHours = totalTime / 3600
        var finalScore = baseScore
        
        if totalHours > 8 {
            finalScore *= 0.7 // Heavily penalize excessive screen time
        } else if totalHours > 6 {
            finalScore *= 0.85
        } else if totalHours > 4 {
            finalScore *= 0.95
        }
        
        return max(0.0, min(10.0, finalScore))
    }
    
    // MARK: - Mock Data Generation (for development/demo)
    func generateMockData() -> [AppUsage] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return [
            AppUsage(appName: "Snapchat", bundleIdentifier: "com.snapchat.Snapchat", totalTimeSpent: 7200, sessionCount: 12, lastUsed: Date(), date: today, category: .social, wellnessScore: 2.0),
            AppUsage(appName: "Instagram", bundleIdentifier: "com.instagram.Instagram", totalTimeSpent: 5400, sessionCount: 8, lastUsed: Date(), date: today, category: .social, wellnessScore: 2.5),
            AppUsage(appName: "YouTube", bundleIdentifier: "com.youtube.YouTube", totalTimeSpent: 4800, sessionCount: 6, lastUsed: Date(), date: today, category: .entertainment, wellnessScore: 3.5),
            AppUsage(appName: "Notion", bundleIdentifier: "com.notion.Notion", totalTimeSpent: 3600, sessionCount: 4, lastUsed: Date(), date: today, category: .productivity, wellnessScore: 9.0),
            AppUsage(appName: "Duolingo", bundleIdentifier: "com.duolingo.Duolingo", totalTimeSpent: 1800, sessionCount: 2, lastUsed: Date(), date: today, category: .education, wellnessScore: 9.0)
        ]
    }
}

// MARK: - Extensions
extension TimeInterval {
    var formattedTime: String {
        let hours = Int(self / 3600)
        let minutes = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
