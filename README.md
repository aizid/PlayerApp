# 🎵 PlayerApp - iOS Music Streaming Application

[![iOS Version](https://img.shields.io/badge/iOS-15.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-15%20%7C%2016-blue)](https://developer.apple.com/xcode/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM%20%2B%20RxSwift-success.svg)](#architecture)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions%20%26%20GitLab%20CI-brightgreen.svg)](#cicd-pipelines)

A native iOS music player application that streams music previews from the public **Apple iTunes Search API** and real-time **Apple Music Top Trending Charts**, engineered using **Clean Architecture**, **MVVM**, **RxSwift**, and **AVFoundation**.

---

## 📋 Table of Contents
- [Features & Problem Statements](#-features--problem-statements)
- [Architecture & Design](#-architecture--design)
- [Tech Stack & Dependencies](#-tech-stack--dependencies)
- [Project Structure](#-project-structure)
- [Error Handling & Loading Handler](#-error-handling--loading-handler)
- [Pagination with CRRefresh](#-pagination-with-crrefresh)
- [Firebase App Distribution & Local Deployment](#-firebase-app-distribution--local-deployment)
- [Getting Started](#-getting-started)
- [Running Unit Tests](#-running-unit-tests)
- [CI/CD Pipelines](#-cicd-pipelines)
- [Author](#-author)

---

## 🎯 Features & Problem Statements

| Requirement | Implementation Details | Status |
| :--- | :--- | :---: |
| **Top Trending & Song List** | Initial data fetch retrieves the official **Top 25 Trending Songs** from Apple Music RSS; dynamic live search queries `https://itunes.apple.com/search?term={query}` with a 500ms debounce. | ✅ Implemented |
| **Pagination with CRRefresh** | Pull-up footer refresh (`NormalFooterAnimator`) paginating Top Songs (up to 100) and Search Results (up to 200) with automatic playlist queue expansion. | ✅ Implemented |
| **Play Songs** | Native audio streaming using `AVPlayer` wrapped in a centralized `AudioPlayerService` configured with `AVAudioSessionCategoryPlayback`. | ✅ Implemented |
| **Pause Song** | Responsive play/pause state synchronization between the docked floating player bar and active table cell. | ✅ Implemented |
| **Play Next Song** | Next button (`forward.fill`) smoothly advances the playlist queue with boundary protection. | ✅ Implemented |
| **Play Previous Song** | Previous button (`backward.fill`) rewinds to previous track or restarts the track if past 3 seconds. | ✅ Implemented |
| **Control Song with Slider** | Interactive `UISlider` scrubbing with periodic time observation (100ms interval) displaying elapsed and total time (`mm:ss`). | ✅ Implemented |
| **Auto-Play Next Song** | Automatically transitions to the next track upon receiving `AVPlayerItemDidPlayToEndTimeNotification`. | ✅ Implemented |
| **Dismissible Player Bar** | Top-right close button (`xmark.circle.fill`) pauses audio and smoothly animates the floating player bar down out of view. | ✅ Implemented |
| **Search Bar Icon** | Native vector SF Symbol `magnifyingglass` and template image asset with dynamic `secondaryLabel` tinting in `vwSearch`. | ✅ Implemented |
| **Loading Handler** | Centralized HUD loading overlay with `UIActivityIndicatorView` during API requests and track buffering. | ✅ Implemented |
| **Error Handler** | Robust network connectivity verification (`isInternetAvailable`) and friendly user alerts on API/decoding failures. | ✅ Implemented |
| **Firebase App Distribution** | Automated local build, `.xcarchive` generation, `.ipa` export, and distribution script (`scripts/deploy_firebase.sh`). | ✅ Implemented |

---

## 🏗 Architecture & Design

The application follows **Clean Architecture** principles decoupled into distinct, testable layers:

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                   │
│        (MainVC, MainView, PlayerBarView, SongViewCell)  │
└────────────────────────────┬────────────────────────────┘
                             │  (Data Binding via RxSwift)
                             ▼
┌─────────────────────────────────────────────────────────┐
│                     ViewModel Layer                     │
│               (DefaultMainVM, MainVM protocol)          │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                     Domain Use Cases                    │
│            (MainUseCase, DefaultMainUseCase)            │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                   Repository & Gateway                  │
│       (AppRepository protocol, DefaultAppRepository)     │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌────────────────────────────┴────────────────────────────┐
│                       Data Layer                        │
│  - AppRemoteDataSource: Network calls via APIRouter     │
│  - APIService: Alamofire request wrapper                │
│  - GeneralMapper: Decodable DTOs -> Domain Models       │
│  - AudioPlayerService: AVFoundation Audio Engine        │
└─────────────────────────────────────────────────────────┘
```

### Key Architectural Strengths
- **Unidirectional Data Flow**: State is propagated via RxSwift `PublishSubject` and observed on the main scheduler.
- **Dependency Inversion**: High-level modules depend on abstractions (protocols) rather than concrete implementations.
- **Dedicated Audio Service**: `AudioPlayerService` is isolated from UI code, emitting events via `AudioPlayerDelegate` to update views reactively.

---

## 💻 Tech Stack & Dependencies

- **Language**: Swift 5.9+ / Swift 6.0
- **UI Framework**: UIKit (Storyboard, AutoLayout, Programmatic Custom Views)
- **Reactive Framework**: [RxSwift](https://github.com/ReactiveX/RxSwift) (6.10+)
- **Networking**: [Alamofire](https://github.com/Alamofire/Alamofire) (5.12+)
- **Image Caching**: [Kingfisher](https://github.com/onevcat/Kingfisher) (8.12+)
- **Audio Engine**: `AVFoundation` (`AVPlayer`, `AVPlayerItem`, `AVAudioSession`)
- **Pull to Refresh**: [CRRefresh](https://github.com/cakratech/CRRefresh)
- **Unit Testing**: [Swift Testing](https://developer.apple.com/documentation/testing) (`@Test`, `#expect`)
- **Package Manager**: Swift Package Manager (SPM)

---

## 📁 Project Structure

```
PlayerApp/
├── .github/
│   └── workflows/
│       └── ci.yml                 # GitHub Actions CI/CD Pipeline
├── .gitlab-ci.yml                 # GitLab CI/CD Pipeline
├── ExportOptions.plist            # Xcode export options for IPA signing
├── scripts/
│   └── deploy_firebase.sh        # Automated local build & Firebase distribution
├── PlayerApp/
│   ├── PlayerApp/
│   │   ├── domain/
│   │   │   ├── datasource/        # AppRemoteDataSource
│   │   │   ├── mapper/            # GeneralMapper (DTO to Domain)
│   │   │   ├── repo/              # AppRepository & DefaultAppRepository
│   │   │   ├── request/           # SearchSongParam
│   │   │   └── response/          # ListSongRes, TopSongFeedRes
│   │   ├── model/
│   │   │   └── response/          # SongModel, ListSongModel
│   │   ├── network/
│   │   │   ├── router/            # APIRouter, APIService, URLCustomEncoding
│   │   │   └── EndpointConst.swift
│   │   ├── ui/
│   │   │   ├── launch/            # LaunchVC
│   │   │   └── main/
│   │   │       ├── item/          # PlayerBarView, SongViewCell
│   │   │       ├── MainVC.swift   # Main Controller
│   │   │       ├── MainVM.swift   # Main ViewModel
│   │   │       └── MainView.swift # Custom Main View
│   │   ├── usecase/               # MainUseCase
│   │   └── util/
│   │       ├── base/              # BaseViewController (Loading & Error HUD)
│   │       ├── player/            # AudioPlayerService (AVPlayer wrapper)
│   │       └── Alertable.swift
│   └── PlayerAppTests/
│       └── PlayerAppTests.swift   # Swift Testing Unit Tests
└── README.md
```

---

## 🛡 Error Handling & Loading Handler

### 1. Visual Loading Overlay (HUD)
When initiating network requests (fetching top charts or searching songs), `BaseViewController` triggers a centered translucent HUD with a native `UIActivityIndicatorView`:
```swift
// Triggered seamlessly via ViewModel state binding
self.getListSongResponse.onNext(.isLoad(true))  // Shows loading indicator
self.getListSongResponse.onNext(.isLoad(false)) // Hides loading indicator
```

### 2. Offline Detection & Error Dialogs
Before executing requests, network availability is verified:
- If offline, an explicit error state is emitted: `"No internet connection. Please check your network and try again."`
- In `BaseViewController`, `erroHandler` presents a `UIAlertController` informing the user of the issue.
- If a search produces 0 results, the table view transitions to an empty state view with illustration and actionable message: *"No Songs Found. Try searching for another artist, song title, or album."*

---

## 🔄 Pagination with CRRefresh

The table view implements seamless infinite scrolling powered by **CRRefresh**:
- **Footer Pull-to-Refresh**: Configured via `tblListSongs.cr.addFootRefresh(animator: NormalFooterAnimator())`.
- **Top Trending Songs**: Initial page loads 25 songs; pull-up paginates in batches of 25 up to 100 tracks.
- **Search Results**: Paginates dynamically in increments of 25 up to 200 tracks with duplicate filtering (`Set<id>`).
- **Dynamic Playlist Expansion**: Newly loaded tracks are automatically appended to `AudioPlayerService.shared.appendPlaylist(newSongs)` so auto-play and next/previous controls seamlessly cross pagination boundaries.
- **End-of-List Indicator**: When no further items exist, `tblListSongs.cr.noticeNoMoreData()` displays a "No more data" indicator.

---

## 🚀 Firebase App Distribution & Local Deployment

### 1. Automated Local Deployment Script (`scripts/deploy_firebase.sh`)
Build and distribute a production-ready `.ipa` directly to Firebase App Distribution with one command:

```bash
# Deploy with custom release notes and tester group
./scripts/deploy_firebase.sh "Version 1.0.0 - Music player ready" "testers"
```

**Automated Workflow:**
1. **Test Verification**: Runs `xcodebuild test` to ensure all unit tests pass before archiving.
2. **Archive Creation**: Creates `build/PlayerApp.xcarchive` using local developer signing (`5KPMR3H66N`).
3. **IPA Export**: Generates `build/export/PlayerApp.ipa` using `ExportOptions.plist`.
4. **Firebase Distribution**: Distributes binary to Firebase App ID `1:352387897762:ios:165a889b6b9350de603afb` via `firebase appdistribution:distribute`.

### 2. CI/CD on Push via GitHub Actions (Self-Hosted Local Runner)
Following the guide from [*iOS CI/CD with GitHub Actions: Firebase Deployment on Push Trigger*](https://medium.com/@vedantshirke/ios-ci-cd-with-github-actions-firebase-deployment-on-push-trigger-part-1-d85ba9d68bfe), the pipeline can run directly on your local Mac runner (`runs-on: self-hosted`) to leverage local Xcode developer certificates without cloud signing configuration:

```yaml
name: iOS CI/CD - Firebase App Distribution (Local Runner)

on:
  push:
    branches: [ "main" ]

jobs:
  build_and_deploy:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4
      - name: Build & Distribute
        run: ./scripts/deploy_firebase.sh "${{ github.event.head_commit.message }}" "testers"
```

---

## 🛠 Getting Started

### Prerequisites
- macOS Sonoma (14+) or macOS Sequoia (15+)
- Xcode 15.4 or Xcode 16+
- iOS 15.0+ Simulator or Device

### Installation & Run

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/aizid/PlayerApp.git
   cd PlayerApp
   ```

2. **Open in Xcode**:
   ```bash
   open PlayerApp/PlayerApp.xcodeproj
   ```
   *Xcode will automatically resolve and download SPM dependencies (RxSwift, Alamofire, Kingfisher, Realm, etc.).*

3. **Build and Run via Xcode**:
   - Select Scheme: `PlayerApp`
   - Select Destination: e.g. `iPhone 16` or `iPhone 17 Pro`
   - Press `Cmd + R`

4. **Build and Run via Terminal**:
   ```bash
   # Build app
   xcodebuild -project PlayerApp/PlayerApp.xcodeproj -scheme PlayerApp -destination 'generic/platform=iOS Simulator' build

   # Boot simulator and launch
   xcrun simctl boot "iPhone 16" || true
   xcrun simctl install booted <path-to-derived-data>/PlayerApp.app
   xcrun simctl launch booted my.id.aizid.PlayerApp
   ```

---

## 🧪 Running Unit Tests

Unit tests are written using Swift's **Swift Testing** framework (`import Testing`) to ensure high code quality, resilience, and test coverage across:
- **`AudioPlayerServiceTests`**: Queue initialization, playlist bounds, next/previous transitions, seek position clamping, and dynamic queue expansion (`appendPlaylist`).
- **`GeneralMapperTests`**: Transformation of `ListSongRes` and `TopSongFeedRes` into `SongModel`, with fallback handling for null/optional fields and preview URL validation.
- **`SearchSongParamTests`**: Default and custom search parameters.
- **`EndpointConstTests`**: Validates search, top songs RSS, and custom limit endpoint routing.

### Running Tests in Xcode:
Press `Cmd + U` with scheme `PlayerApp`.

### Running Tests via Command Line:
```bash
xcodebuild test \
  -project PlayerApp/PlayerApp.xcodeproj \
  -scheme PlayerApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -parallel-testing-enabled NO \
  -only-testing:PlayerAppTests
```

---

## ⚙️ CI/CD Pipelines

### 1. GitHub Actions (`.github/workflows/ci.yml`)
Triggers on every `push` and `pull_request` to the `main` branch:
- **Stage 1 (Test)**: Checks out repository, selects Xcode version, and executes all unit tests on an iOS Simulator.
- **Stage 2 (Build & Package)**: Builds Release archive (`xcodebuild archive`), packages the application payload (`PlayerApp.ipa` and `PlayerApp.app.zip`), and uploads the artifacts with a 14-day retention period.

### 2. GitLab CI (`.gitlab-ci.yml`)
Configured for GitLab CI runners with macOS tags:
- **`unit_tests`**: Runs headless test suite with `-only-testing:PlayerAppTests`.
- **`build_package`**: Archives release build and stores `.ipa` as downloadable pipeline artifacts.

---

## 👤 Author

- **Name**: Muhammad Faiz
- **Username**: aizid
- **Email**: muhammad.faiz532@gmail.com