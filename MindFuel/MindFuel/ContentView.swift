//
//  ContentView.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//
//  Legacy view - now using MainTabView as main interface

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [AppUsage.self, WellnessAlert.self], inMemory: true)
}
