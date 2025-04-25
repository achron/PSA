# 📱 PSA Swift iOS App

A modern iOS application built with **Swift 5**, using UIKit, Storyboards, and multiple app extensions including Notification Center and Content Center. Integrated with Firebase and CocoaPods.

---

## 🚀 Tech Stack

- **Language**: Swift 5.0
- **Xcode**: 15.1+
- **Deployment Target**: iOS 16.0+
- **UI**: UIKit + Storyboards
- **Dependency Manager**: CocoaPods

---

## 📂 Project Structure

```
PSA-iOS/
├── dummy/                          # Main App
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ViewController.swift
│   ├── Assets.xcassets
│   ├── Info.plist
│   └── Main.storyboard
├── PsaNotificationCenter/         # Push Notification Service Extension
│   ├── NotificationService.swift
│   └── Info.plist
├── PsaNotificationContentCenter/  # Rich Notification Content Extension
│   ├── NotificationViewController.swift
│   └── MainInterface.storyboard
├── GoogleService-Info.plist       # Firebase config
├── Podfile / Podfile.lock         # CocoaPods dependencies
└── PSAApp.xcodeproj
```

---

## 🛠️ Getting Started

### Prerequisites

- macOS (Ventura or newer)
- [Xcode 15.1+](https://developer.apple.com/xcode/)
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

---

### 🔧 Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/psa-ios-app.git
   cd psa-ios-app
   ```

2. **Install dependencies**

   ```bash
   pod install
   ```

3. **Open the project**

   Open the `.xcworkspace` file in Xcode:

   ```bash
   open PSAApp.xcworkspace
   ```

4. **Add Firebase Config**

   - Download `GoogleService-Info.plist` from Firebase Console
   - Place it inside the `dummy/` folder

5. **Build and Run**

   - Select the `dummy` scheme
   - Choose a device/simulator
   - Hit `⌘ + R` or click ▶️

---

## ✨ Features

- 🔔 Push Notifications (via `NotificationService`)
- 🖼 Rich Notification UI (via `NotificationViewController`)
- 📦 Firebase Messaging Integration
- 🧪 Modular structure for easy extension & testing
- 🧬 CocoaPods for third-party dependencies


---

## 👨‍💻 Authors

Made with ❤️ by the PSA Team
