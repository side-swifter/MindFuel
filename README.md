# MindFuel 🧠⚡

> **Your Digital Wellness Companion**

MindFuel is an iOS app designed to help you maintain a healthy relationship with technology by monitoring your screen time, analyzing app usage patterns, and providing personalized wellness recommendations.

## 🌟 Features

### 📊 **Intelligent Screen Time Analysis**
- Real-time monitoring of app usage patterns
- Categorization of apps based on wellness impact
- Comprehensive daily wellness scoring (0-10 scale)

### 🚨 **Proactive Wellness Alerts**
- Smart notifications for excessive social media usage
- Personalized recommendations for digital wellness
- Customizable alert thresholds based on app categories

### 🎯 **Wellness Dashboard**
- Beautiful, intuitive interface with brand colors (Red, Black, White)
- Visual breakdown of screen time by app categories
- Real-time wellness score with progress indicators

### 📈 **App Categorization System**
- **Positive Impact**: Education, Productivity, Health & Fitness
- **Neutral Impact**: Utilities, News
- **Negative Impact**: Social Media, Games, Entertainment

## 🛠 Technical Stack

- **Framework**: SwiftUI + SwiftData
- **Platform**: iOS 17+ (with macOS compatibility)
- **Architecture**: MVVM with Observable classes
- **Data Persistence**: SwiftData with CloudKit sync
- **UI Design**: Modern iOS design patterns with custom theme system

## 📱 App Structure

```
MindFuel/
├── Models/
│   ├── AppUsage          # Screen time data model
│   ├── WellnessAlert     # Alert system model
│   ├── DailyWellnessSummary # Daily wellness tracking
│   └── WellnessGoal      # Goal setting and tracking
├── Views/
│   ├── DashboardView     # Main wellness dashboard
│   ├── AlertsView        # Detailed alert management
│   ├── MainTabView       # Tab-based navigation
│   └── Supporting Views  # Reusable UI components
├── Services/
│   └── WellnessService   # Core business logic
└── Theme/
    └── Brand colors, typography, and styling
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ deployment target
- Screen Time API permissions

### Installation
1. Clone the repository
2. Open `MindFuel.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device

### Demo Data
The app includes mock data for demonstration purposes, featuring:
- Sample app usage data for popular apps
- Pre-configured wellness alerts
- Example app categorizations

## 🎨 Design System

### Brand Colors
- **Primary Red**: #DE3E4A - Used for alerts and primary actions
- **Secondary Black**: #212121 - Text and navigation elements
- **Background White**: #FFFFFF - Clean, minimal backgrounds

### App Categories & Scoring
- **Social Media** (Snapchat, Instagram, TikTok): 1.5-3.0 wellness score
- **Productivity** (Notion, Office, Gmail): 7.0-9.0 wellness score
- **Education** (Duolingo, Khan Academy): 8.0-9.5 wellness score
- **Health & Fitness** (Apple Health, Headspace): 8.0-9.0 wellness score

## 📋 Roadmap

### Phase 1 (Current)
- [x] Basic screen time monitoring
- [x] App categorization system
- [x] Wellness alerts and recommendations
- [x] Dashboard with wellness scoring

### Phase 2 (Coming Soon)
- [ ] Screen Time API integration
- [ ] Advanced analytics and trends
- [ ] Custom goal setting and tracking
- [ ] Export and sharing capabilities

### Phase 3 (Future)
- [ ] Family sharing and parental controls
- [ ] Apple Watch companion app
- [ ] Siri shortcuts integration
- [ ] Focus modes integration

## 🤝 Contributing

This project is currently in development. Future contribution guidelines will be available as the project matures.

## 📄 License

This project is currently proprietary. License details will be updated as development progresses.

## 🙋‍♂️ Support

For questions, issues, or feedback about MindFuel, please create an issue in this repository.

---

**MindFuel** - Fuel Your Digital Wellness Journey 🚀
