//
//  Theme.swift
//  MindFuel
//
//  Created by Akshayraj Sanjai on 8/4/25.
//

import SwiftUI

// MARK: - Brand Colors
extension Color {
    // MindFuel Brand Colors
    static let mindFuelRed = Color(red: 0.87, green: 0.24, blue: 0.29) // #DE3E4A
    static let mindFuelBlack = Color(red: 0.13, green: 0.13, blue: 0.13) // #212121
    static let mindFuelWhite = Color.white
    
    // Semantic Colors
    static let wellnessGreen = Color(red: 0.20, green: 0.73, blue: 0.29) // #34BB4A
    static let warningOrange = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500
    static let alertRed = Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30
    static let informationBlue = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF
    
    // Wellness Score Colors
    static func wellnessScore(for score: Double) -> Color {
        if score >= 7.0 {
            return .wellnessGreen
        } else if score >= 4.0 {
            return .warningOrange
        } else {
            return .alertRed
        }
    }
}

// MARK: - Typography
extension Font {
    // MindFuel Typography Scale
    static let mindFuelLargeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let mindFuelTitle = Font.system(size: 28, weight: .bold, design: .default)
    static let mindFuelTitle2 = Font.system(size: 22, weight: .bold, design: .default)
    static let mindFuelTitle3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let mindFuelHeadline = Font.system(size: 17, weight: .semibold, design: .default)
    static let mindFuelSubheadline = Font.system(size: 15, weight: .medium, design: .default)
    static let mindFuelBody = Font.system(size: 17, weight: .regular, design: .default)
    static let mindFuelCallout = Font.system(size: 16, weight: .regular, design: .default)
    static let mindFuelFootnote = Font.system(size: 13, weight: .regular, design: .default)
    static let mindFuelCaption = Font.system(size: 12, weight: .regular, design: .default)
    static let mindFuelCaption2 = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Spacing
struct MindFuelSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct MindFuelRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
}

// MARK: - Shadow
struct MindFuelShadow {
    static let light = Color.black.opacity(0.05)
    static let medium = Color.black.opacity(0.1)
    static let heavy = Color.black.opacity(0.2)
    
    static let small = (radius: CGFloat(3), x: CGFloat(0), y: CGFloat(1))
    static let mediumRadius = (radius: CGFloat(5), x: CGFloat(0), y: CGFloat(2))
    static let large = (radius: CGFloat(10), x: CGFloat(0), y: CGFloat(4))
}

// MARK: - View Modifiers
struct MindFuelCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: MindFuelRadius.md))
            .shadow(
                color: MindFuelShadow.light,
                radius: MindFuelShadow.small.radius,
                x: MindFuelShadow.small.x,
                y: MindFuelShadow.small.y
            )
    }
}

struct MindFuelButtonStyle: ButtonStyle {
    let color: Color
    let isSecondary: Bool
    
    init(color: Color = .mindFuelRed, isSecondary: Bool = false) {
        self.color = color
        self.isSecondary = isSecondary
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, MindFuelSpacing.lg)
            .padding(.vertical, MindFuelSpacing.md)
            .background(
                isSecondary ?
                color.opacity(0.1) :
                color
            )
            .foregroundColor(
                isSecondary ?
                color :
                .white
            )
            .clipShape(RoundedRectangle(cornerRadius: MindFuelRadius.md))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func mindFuelCard() -> some View {
        self.modifier(MindFuelCardStyle())
    }
    
    func mindFuelButton(color: Color = .mindFuelRed, isSecondary: Bool = false) -> some View {
        self.buttonStyle(MindFuelButtonStyle(color: color, isSecondary: isSecondary))
    }
}
