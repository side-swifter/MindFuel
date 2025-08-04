<div align="center">

# 🧠⚡ MindFuel

### *Taking Control of Your Digital Life*

<img src="./MindFuel/MindFuel/Assets.xcassets/MindFuelLogo.imageset/MindFuel Logo.png" alt="MindFuel Logo" width="200"/>

![iOS](https://img.shields.io/badge/iOS-17.0+-000000?style=for-the-badge&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/swift-5.9+-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0052CC?style=for-the-badge&logo=swift&logoColor=white)
![Status](https://img.shields.io/badge/Status-In%20Development-DE3E4A?style=for-the-badge)

**Hey GearUp Robotics Team! 👋**

Welcome to MindFuel - our digital wellness app that's going to help people take back control of their screen time. Built with love by our team, this isn't just another app - it's a mission to make technology serve us, not the other way around.

</div>

---

## 🚀 What is MindFuel?

Imagine if your phone could be your wellness coach instead of your biggest distraction. That's MindFuel! We're building an iOS app that:

- **Tracks** your screen time intelligently (not just numbers, but *meaningful* insights)
- **Analyzes** which apps help you grow vs. which ones drain your energy
- **Guides** you toward healthier digital habits with personalized recommendations
- **Motivates** you with beautiful visuals and achievable goals

Think of it as a fitness tracker, but for your digital life! 📱💪

## ✨ Why This Matters

> *"The average person checks their phone 144 times per day. We're not trying to eliminate technology - we're trying to make it intentional."*

Our generation grew up with smartphones, but nobody taught us how to use them healthily. MindFuel bridges that gap by making digital wellness accessible, visual, and actually enjoyable.

## 🎯 Key Features

### 📊 **Smart Screen Time Analysis**
- Real-time app usage monitoring
- AI-powered app categorization (Helpful vs. Harmful)
- Daily wellness scoring (0-10 scale)
- Beautiful data visualizations

### 🔔 **Intelligent Wellness Alerts**
- Custom notifications when you're doom-scrolling too long
- Gentle nudges toward more productive apps
- Personalized recommendations based on your patterns

### 🎨 **Stunning Dashboard**
- Clean, modern interface using our brand colors
- Interactive charts and progress indicators
- Goal tracking with celebration animations

### 🏆 **Goal Setting System**
- Pre-built wellness templates ("Social Media Detox", "Focus Mode", etc.)
- Custom goal creation
- Progress tracking with rewards

---

## 🛠 For Developers (aka Our Amazing Team!)

### 🏗 Tech Stack
```
🎨 Frontend: SwiftUI (because it's beautiful and fast)
💾 Database: SwiftData + CloudKit (sync across devices)
📱 Platform: iOS 17+ (with future macOS support)
🏛 Architecture: MVVM + Observable (clean and testable)
🎯 APIs: Screen Time API, Family Controls Framework
```

### 📁 Project Structure
```
MindFuel/
├── 📱 App/
│   ├── MindFuelApp.swift          # App entry point
│   └── ContentView.swift          # Main navigation
├── 🧩 Models/
│   ├── AppUsage.swift             # Screen time data
│   ├── WellnessAlert.swift        # Notification system
│   ├── WellnessGoal.swift         # Goal tracking
│   └── DailyWellnessSummary.swift # Daily insights
├── 🎨 Views/
│   ├── Dashboard/
│   │   ├── DashboardView.swift    # Main wellness dashboard
│   │   └── WellnessScoreCard.swift # Score display
│   ├── Analytics/
│   │   └── AnalyticsView.swift    # Detailed insights
│   ├── Goals/
│   │   └── GoalsView.swift        # Goal management
│   └── Settings/
│       └── SettingsView.swift     # App configuration
├── ⚙️ Services/
│   ├── ScreenTimeService.swift    # Screen Time API integration
│   ├── WellnessService.swift      # Core business logic
│   └── NotificationService.swift  # Alert management
└── 🎨 Theme/
    ├── BrandColors.swift          # Our red, black, white palette
    ├── Typography.swift           # Font styles
    └── Assets.xcassets/           # Images and icons
```

### 🚀 Getting Started (For New Team Members)

#### Prerequisites
- **Xcode 15.0+** (get it from the App Store)
- **iOS 17+ Simulator** or physical device
- **Apple Developer Account** (for Screen Time API)
- **Coffee** ☕ (optional but recommended)

#### Setup Instructions
1. **Clone the repo**
   ```bash
   git clone https://github.com/side-swifter/MindFuel.git
   cd MindFuel
   ```

2. **Open in Xcode**
   ```bash
   open MindFuel.xcodeproj
   ```

3. **Set your Team ID**
   - Go to Project Settings → Signing & Capabilities
   - Select your Apple Developer Team
   - Change Bundle ID if needed

4. **Build & Run**
   - Select iOS Simulator or your device
   - Hit `Cmd + R` and watch the magic happen! ✨

#### 🚨 First Time Setup Issues?
- **"No such module 'ScreenTime'"** → Make sure you're running iOS 17+ simulator
- **Code signing errors** → Check your Apple Developer account setup
- **App crashes on launch** → Try cleaning build folder (`Cmd + Shift + K`)

### 🎨 Brand Guidelines

#### Colors (Use these everywhere!)
```swift
// In BrandColors.swift
static let mindfulRed = Color(hex: "#DE3E4A")    // Primary actions, alerts
static let deepBlack = Color(hex: "#212121")     // Text, navigation
static let cleanWhite = Color(hex: "#FFFFFF")    // Backgrounds
```

#### Typography
- **Headlines**: SF Pro Display, Bold
- **Body**: SF Pro Text, Regular
- **Captions**: SF Pro Text, Medium

#### App Categories & Wellness Scores
| Category | Examples | Wellness Score | Color |
|----------|----------|----------------|-------|
| 🚀 **Productive** | Notion, Xcode, Gmail | 7.0-9.0 | Green |
| 📚 **Educational** | Duolingo, Khan Academy | 8.0-9.5 | Blue |
| 💪 **Health** | Apple Health, Headspace | 8.0-9.0 | Green |
| 📰 **Neutral** | News, Weather | 5.0-7.0 | Yellow |
| 🎮 **Entertainment** | Games, Netflix | 3.0-5.0 | Orange |
| 📱 **Social Media** | Instagram, TikTok, Snapchat | 1.5-3.0 | Red |

---

## 🎯 Roadmap (What We're Building)

### ✅ Phase 1: Foundation (COMPLETED)
- [x] Core SwiftUI app structure
- [x] Basic screen time monitoring
- [x] App categorization system
- [x] Wellness dashboard with scoring
- [x] Brand identity and design system
- [x] Mock data for testing

### 🔄 Phase 2: Intelligence (IN PROGRESS)
- [ ] Real Screen Time API integration
- [ ] Advanced analytics and trends
- [ ] Custom goal creation system
- [ ] Push notification system
- [ ] App Store optimization

### 🔮 Phase 3: Growth (COMING SOON)
- [ ] Apple Watch companion app
- [ ] Siri Shortcuts integration
- [ ] Focus Modes integration
- [ ] Family sharing features
- [ ] Export data capabilities
- [ ] Widget support

---

## 🤝 Contributing (Team Guidelines)

### 💻 Development Workflow
1. **Create a feature branch** from `main`
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** (keep commits small and focused)

3. **Test thoroughly** (both simulator and device)

4. **Create a Pull Request** with:
   - Clear description of what you built
   - Screenshots/videos of UI changes
   - Any breaking changes noted

### 🎯 Coding Standards
- **SwiftUI Views**: Use `@State` and `@Observable` appropriately
- **Naming**: Clear, descriptive variable names (no `data1`, `temp`, etc.)
- **Comments**: Explain *why*, not *what*
- **File Organization**: Group related functionality together

### 🐛 Found a Bug?
1. Check if it's already reported in Issues
2. If not, create a new issue with:
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots/videos if UI-related
   - Device/iOS version info

### 💡 Have an Idea?
We love new ideas! Create an issue with the "enhancement" label and let's discuss it.

---

## 📚 Resources & Learning

### New to iOS Development?
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui) (Official Apple tutorials)
- [Hacking with Swift](https://www.hackingwithswift.com/) (Amazing free resource)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)

### Understanding Screen Time API
- [Family Controls Framework](https://developer.apple.com/documentation/familycontrols)
- [Screen Time API Overview](https://developer.apple.com/documentation/screentime)

### Design Inspiration
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [iOS Design Patterns](https://mobbin.design/browse/ios/apps)

---

## 🆘 Need Help?

### Team Support
- **Slack**: #mindfuel-dev channel
- **GitHub Issues**: For bugs and feature requests
- **1:1 Help**: Reach out to any senior team member

### Common Issues & Solutions

<details>
<summary><strong>"Cannot find 'ScreenTimeService' in scope"</strong></summary>

This usually means the Screen Time API isn't available on your simulator.
- Make sure you're using iOS 17+ simulator
- Try running on a physical device
- Check that Family Controls entitlement is enabled
</details>

<details>
<summary><strong>"App crashes when trying to access screen time data"</strong></summary>

Screen Time requires special permissions:
- Make sure Family Controls entitlement is added
- App must request permission at runtime
- Some features only work on real devices, not simulator
</details>

<details>
<summary><strong>"SwiftData preview crashes"</strong></summary>

SwiftData previews can be tricky:
- Make sure preview data is properly configured
- Check that your model relationships are correct
- Try adding `@Query` properties to preview data
</details>

---

## 🎉 Recognition

**Built with ❤️ by the GearUp Robotics Team**

Shoutout to everyone contributing to this project - every line of code, every design decision, every bug report makes MindFuel better for the people who will use it.

### Core Contributors
- 🎨 **Design & Branding**: [Team Member Names]
- 💻 **iOS Development**: [Team Member Names]
- 📊 **Data & Analytics**: [Team Member Names]
- 🧪 **Testing & QA**: [Team Member Names]

---

## 📄 License

This project is currently proprietary to GearUp Robotics. All rights reserved.

---

<div align="center">

### Ready to change how people interact with technology? Let's build something amazing! 🚀

**Questions? Ideas? Just want to chat about the project?**

[Create an Issue](https://github.com/side-swifter/MindFuel/issues/new) • [Join the Discussion](https://github.com/side-swifter/MindFuel/discussions)

*"Technology should amplify human capability, not replace it." - MindFuel Team*

</div>

**MindFuel** - Fuel Your Digital Wellness Journey 🚀
