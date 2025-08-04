//
//  OnboardingView.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    var body: some View {
        TabView(selection: $currentPage) {
            // Welcome Page
            WelcomePage()
                .tag(0)
            
            // Features Page
            FeaturesPage()
                .tag(1)
            
            // Screen Time Permission Page
            ScreenTimePermissionPage(
                isOnboardingComplete: $isOnboardingComplete
            )
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(
            LinearGradient(
                colors: [.red.opacity(0.1), .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Logo
            Image("MindFuelLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
            
            VStack(spacing: 16) {
                Text("Welcome to MindFuel")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Your Digital Wellness Companion")
                    .font(.title2)
                    .foregroundColor(.red)
                    .fontWeight(.medium)
                
                Text("Take control of your screen time and build healthier digital habits")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            Text("Swipe to continue")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 40)
        }
        .padding()
    }
}

struct FeaturesPage: View {
    let features = [
        ("chart.line.uptrend.xyaxis", "Track Usage", "Monitor your daily screen time and app usage patterns"),
        ("exclamationmark.triangle.fill", "Smart Alerts", "Get warnings when using potentially harmful apps"),
        ("target", "Set Goals", "Create wellness goals and track your progress"),
        ("brain.head.profile", "Insights", "Understand your digital habits with detailed analytics")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("Powerful Features")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Everything you need for digital wellness")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            VStack(spacing: 24) {
                ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                    FeatureRow(
                        icon: feature.0,
                        title: feature.1,
                        description: feature.2
                    )
                }
            }
            
            Spacer()
            
            Text("Swipe to get started")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 40)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.red)
                .frame(width: 40, height: 40)
                .background(.regularMaterial)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct ScreenTimePermissionPage: View {
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    @Binding var isOnboardingComplete: Bool
    @State private var showingPermissionDenied = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "shield.checkerboard")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                
                Text("Screen Time Access")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("MindFuel needs access to your Screen Time data to provide personalized wellness insights")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            VStack(spacing: 16) {
                ForEach([
                    ("chart.bar.fill", "Track app usage patterns"),
                    ("clock.fill", "Monitor daily screen time"),
                    ("exclamationmark.triangle.fill", "Alert for excessive usage"),
                    ("target", "Help achieve wellness goals")
                ], id: \.0) { icon, text in
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(.red)
                            .frame(width: 20)
                        Text(text)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    Task {
                        await screenTimeManager.requestAuthorization()
                        if screenTimeManager.isAuthorized {
                            completeOnboarding()
                        } else {
                            showingPermissionDenied = true
                        }
                    }
                } label: {
                    HStack {
                        if screenTimeManager.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        Text(screenTimeManager.isLoading ? "Requesting Access..." : "Grant Screen Time Access")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(screenTimeManager.isLoading)
                
                Button("Skip for Now") {
                    completeOnboarding()
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .alert("Permission Required", isPresented: $showingPermissionDenied) {
            Button("Try Again") {
                Task {
                    await screenTimeManager.requestAuthorization()
                    if screenTimeManager.isAuthorized {
                        completeOnboarding()
                    }
                }
            }
            Button("Continue Without") {
                completeOnboarding()
            }
        } message: {
            Text("Screen Time access helps MindFuel provide better wellness insights. You can enable this later in Settings.")
        }
    }
    
    private func completeOnboarding() {
        // Save that onboarding is complete
        UserDefaults.standard.set(true, forKey: "onboardingComplete")
        isOnboardingComplete = true
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
