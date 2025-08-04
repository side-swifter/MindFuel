//
//  ScreenTimeManager.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import Foundation
import SwiftUI
#if os(iOS)
import FamilyControls
import DeviceActivity
import ManagedSettings
#endif

@MainActor
class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()
    
    @Published var isAuthorized = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    #if os(iOS)
    // Note: DeviceActivity APIs require special Apple approval
    // For development, we'll simulate the functionality
    private let hasDeviceActivityEntitlement = false
    #endif
    
    private init() {
        #if os(iOS)
        checkAuthorizationStatus()
        #endif
    }
    
    func requestAuthorization() async {
        #if os(iOS)
        isLoading = true
        errorMessage = nil
        
        // Simulate authorization for development
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay to simulate real API
        
        await MainActor.run {
            // For development, we'll grant "mock" authorization
            isAuthorized = true
            errorMessage = nil
            isLoading = false
        }
        #else
        errorMessage = "Screen Time APIs are only available on iOS"
        #endif
    }
    
    private func checkAuthorizationStatus() {
        #if os(iOS)
        // For development without DeviceActivity entitlements
        // We'll default to not authorized until user explicitly requests
        if !hasDeviceActivityEntitlement {
            // Leave as-is, will be set by requestAuthorization()
            return
        }
        #endif
    }
    
    func getDeviceActivity() async -> [AppUsageData] {
        #if os(iOS)
        guard isAuthorized else {
            await MainActor.run {
                errorMessage = "Screen Time access not authorized. Please grant permission first."
            }
            return []
        }
        
        // Note: Real DeviceActivity data requires a DeviceActivityReport extension
        // For now, we'll return enhanced mock data that simulates real usage patterns
        return await generateRealisticScreenTimeData()
        #else
        return []
        #endif
    }
    
    func startMonitoring(for apps: Set<String>, timeLimit: TimeInterval) {
        #if os(iOS)
        guard isAuthorized else {
            errorMessage = "Screen Time access required for monitoring"
            return
        }
        
        // For development without DeviceActivity entitlements
        if !hasDeviceActivityEntitlement {
            print("[MindFuel Dev] Would start monitoring \(apps.count) apps with \(timeLimit)s limit")
            // In production, this would use DeviceActivityCenter.startMonitoring
            return
        }
        #endif
    }
    
    private func generateRealisticScreenTimeData() async -> [AppUsageData] {
        // Simulate realistic daily usage patterns with variation
        let baseApps = [
            ("Snapchat", "com.snapchat.snapchat", AppCategory.social, 45...180),
            ("Instagram", "com.instagram.instagram", AppCategory.social, 30...120),
            ("TikTok", "com.tiktok.tiktok", AppCategory.social, 60...200),
            ("Safari", "com.apple.safari", AppCategory.productivity, 20...90),
            ("Messages", "com.apple.messages", AppCategory.social, 15...60),
            ("YouTube", "com.youtube.youtube", AppCategory.entertainment, 30...150),
            ("WhatsApp", "com.whatsapp.whatsapp", AppCategory.social, 10...45),
            ("Settings", "com.apple.preferences", AppCategory.utilities, 5...20),
            ("Photos", "com.apple.photos", AppCategory.entertainment, 10...40),
            ("Twitter", "com.twitter.twitter", AppCategory.social, 20...90)
        ]
        
        return baseApps.map { (name, bundleId, category, minuteRange) in
            let randomMinutes = Int.random(in: minuteRange)
            return AppUsageData(
                appName: name,
                bundleIdentifier: bundleId,
                usageTime: Double(randomMinutes * 60), // Convert to seconds
                category: category,
                date: Date()
            )
        }.sorted { $0.usageTime > $1.usageTime } // Sort by usage time descending
    }
}

struct AppUsageData: Identifiable {
    let id = UUID()
    let appName: String
    let bundleIdentifier: String
    let usageTime: TimeInterval // in seconds
    let category: AppCategory
    let date: Date
    
    var usageTimeInMinutes: Int {
        Int(usageTime / 60)
    }
    
    var usageTimeFormatted: String {
        let hours = Int(usageTime) / 3600
        let minutes = (Int(usageTime) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
