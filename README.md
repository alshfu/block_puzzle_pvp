# Block Puzzle GameZzz: A Multi-Game Flutter Showcase

A multi-game Flutter application featuring Tetris and Firebase integration (Authentication, Firestore, Leaderboard). A powerful boilerplate for cross-platform games on macOS and Web, built with a clean, scalable architecture.



## ✨ Features

* **Multiple Game Modes:** Classic block puzzle gameplay, with a flexible architecture to easily add more games like Snake, 2048, etc.
* **Firebase Authentication:** Secure and seamless user authentication using:
    * Google Sign-In (for Web & macOS)
    * Sign in with Apple (for macOS)
    * Anonymous Sign-In
* **Cloud Firestore Backend:**
    * Persistent player profiles and statistics.
    * Global real-time leaderboard to foster competition.
* **Clean Architecture:**
    * **Service Layer:** All Firebase logic is encapsulated in `FirebaseService`, ensuring a clear separation of concerns.
    * **Model-View:** Data models (`PlayerStats`) are decoupled from the UI.
    * **Modular UI:** Reusable widgets for UI components like avatars and game controls.
* **Cross-Platform Ready:** Configured for both **macOS** and **Web**, with platform-specific logic handled gracefully.
* **Localization:** Supports multiple languages (English and Russian) using Flutter's internationalization tools.

## 🚀 Getting Started

This project intentionally excludes secret keys and platform-specific configuration files from the repository for security. To run the project locally, you must configure your own Firebase backend.

### Prerequisites

* Flutter SDK installed.
* A Firebase project created on [console.firebase.google.com](https://console.firebase.google.com/).
* (For macOS) An active Apple Developer account for code signing.

### Configuration Steps

1.  **Clone the Repository:**
    ```bash
    git clone [Your-Repo-URL]
    cd block_puzzle_pvp
    ```
2.  **Configure Firebase:**
    * In your Firebase project, go to **Authentication > Sign-in method** and enable the **Google** and **Anonymous** providers.
    * Go to **Project Settings** and register apps for **iOS** and **Web**. Use `com.alshfu.blockPuzzlePvp` as the Bundle ID for the iOS app.
3.  **Generate `firebase_options.dart`:**
    * Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
    * Run `flutterfire configure` and select your project. This will generate `lib/firebase_options.dart`.
4.  **Configure macOS:**
    * Download the `GoogleService-Info.plist` file for your **iOS app** from the Firebase project settings.
    * Place this file inside the `macos/Runner/` directory.
    * Open `macos/Runner.xcworkspace` in Xcode.
    * Drag `GoogleService-Info.plist` from the Finder into the `Runner` folder inside the Xcode project navigator, ensuring "Copy items if needed" is checked.
5.  **Configure Web:**
    * Go to the [Google Cloud Console](https://console.cloud.google.com/) > **APIs & Services > Credentials**.
    * Create an **OAuth 2.0 Client ID** for a **Web application**.
    * Under "Authorized JavaScript origins", add `http://localhost:8080`.
    * Under "Authorized redirect URIs", add `http://localhost:8080`.

## 🛠️ Running the Application

### For macOS
```bash
flutter run -d macos
```

### For Web
You must provide your Web Client ID using the `--dart-define` flag.

1.  **Get your Web Client ID** from the Google Cloud Console.
2.  **Run the app with this command:**
    ```bash
    flutter run -d chrome --web-port 8080 --dart-define=WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID_HERE
    ```

## 📂 Project Structure

The project is organized with a clear and scalable structure:

* `lib/`
    * `main.dart`: App entry point and `AuthGate`.
    * `l10n/`: Localization files.
    * `models/`: Data models (e.g., `player_stats.dart`).
    * `screens/`: Top-level UI screens.
        * `games/`: Contains individual game screens and their specific logic/widgets.
    * `services/`: Business logic and communication with external services (e.g., `firebase_service.dart`).
    * `widgets/`: Shared, reusable UI widgets.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

*This project was built as a demonstration of robust Flutter development practices.*
