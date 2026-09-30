# SportTracker

[![Tests](https://github.com/Carrione/SportTracker/actions/workflows/tests.yml/badge.svg)](https://github.com/Carrione/SportTracker/actions/workflows/tests.yml)

Sample iOS app for tracking sport activities. Activities can be stored locally (SwiftData) and remotely (Firebase/Firestore), with anonymous and Google Sign-In authentication. The code deliberately does not aim for the shortest possible codebase — its purpose is to show a scalable app architecture.

**Highlights**

- **CLEAN architecture** — every layer and every feature is a separate Swift package
- **MVI with coordinators** in the presentation layer — `@Observable` view models with `State` and `Intent`, navigation owned by coordinators
- **Swift 6.2 strict concurrency** — `@MainActor` default isolation, async/await, `AsyncThrowingStream`
- **Offline-first data flow** — local data first, then merged with remote data as soon as it arrives
- **Unit tests** with Swift Testing against mocks — no Firebase or simulator needed, run on every push via GitHub Actions

---

## Setup

The project needs its own Firebase configuration, which is not part of the repository.

### 1. Firebase project

1. Create a new project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an iOS app with a bundle ID matching `PRODUCT_BUNDLE_IDENTIFIER` in the Xcode project
3. In the console, enable:
   - **Authentication** → Anonymous and Google Sign-In
   - **Firestore Database**
4. Download `GoogleService-Info.plist` and put it into `Application/Resources/` (the file is in `.gitignore`)

### 2. Google Sign-In in Info.plist

`GoogleService-Info.plist` is read only by FirebaseCore. The Google Sign-In SDK does not read it, and the system loads URL schemes exclusively from the app's Info.plist. Both values therefore have to be copied manually into `Application/Resources/SportTracker-Info.plist` from the `GoogleService-Info.plist` you just downloaded:

| Source (`GoogleService-Info.plist`) | Target (`SportTracker-Info.plist`) |
|---|---|
| `CLIENT_ID` | `GIDClientID` |
| `REVERSED_CLIENT_ID` | `CFBundleURLTypes` → `CFBundleURLSchemes` |

```xml
<key>GIDClientID</key>
<string>$CLIENT_ID</string>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>$REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Without `GIDClientID`, Google sign-in fails when calling `GIDSignIn.sharedInstance.signIn(withPresenting:)`; without the URL scheme, the OAuth flow does not return to the app. Anonymous sign-in works without either.

### 3. Firestore security rules

The app stores activities under `users/{uid}/activities`. The default rules deny everything in production mode (and expire after 30 days in test mode), so set:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Otherwise every save and fetch ends with `PERMISSION_DENIED`.

### 4. Build and run the project

---

## Architecture

The project combines **CLEAN architecture** across the whole app with **MVI with coordinators** in the presentation layer. Every layer is isolated as a separate Swift package.
The presentation layer depends on the domain layer, the domain layer depends on nothing else, and the data layer implements interfaces defined by the domain.

---

## Project structure

```
SportTracker/
├── Application/                    # App target + bootstrapping
│   ├── AppCoordinator.swift        # Root coordinator
│   ├── SportTrackerApp.swift       # Main file
│   ├── RootView.swift              # Root view
│   ├── DependencyInjection/        # SPM – DI container
│   └── Resources/                  # Assets, plist, localization
│
├── PresentationLayer/              # Everything the user sees
│   ├── ActivityList/               # SPM – activity list + detail
│   ├── AddActivity/                # SPM – adding an activity
│   ├── Profile/                    # SPM – profile and sign-in
│   └── UIToolkit/                  # SPM – shared UI components
│
├── DomainLayer/
│   └── SharedDomain/               # SPM – models, use cases, repository protocols
│
└── DataLayer/
    ├── Toolkits/
    │   ├── SwiftDataToolkit/       # SPM – SwiftData storage implementation
    │   └── FirebaseToolkit/        # SPM – Firebase/Firestore storage implementation
    ├── Repositories/
    │   └── ActivityRepository/     # SPM – composite repository over both stores
    └── Providers/
        ├── SwiftDataProvider/      # SPM – SwiftData stack configuration
        └── FirebaseProvider/       # SPM – Firebase configuration
```

---

## Layers

### Domain layer (`SharedDomain`)

The core of the app, with no dependency on any framework (except Foundation). It contains:

- **Models** – `SportActivity`, `StorageType`, `ActivityFilter`
- **Repository protocols** – `SportActivityStore` for a single concrete store, `PurgeableActivityStore` for a store that can delete a user's data, `SportActivityRepository` for what the use cases consume
- **Use cases** – business logic (`FetchActivitiesUseCase`, `SaveActivityUseCase`, `DeleteActivityUseCase`, `SignOutUseCase`, etc.)
- **Service protocols** – `AuthServiceProtocol`, `CrashlyticsServiceProtocol`, `AnalyticsServiceProtocol`

Use cases are simple structs that take a repository in their initializer and call it. They are easy to test with a mock repository.

### Data layer

Implements the domain protocols on two levels.

Concrete stores implement `SportActivityStore`:

- **`SwiftDataActivityRepository`** – stores activities locally via SwiftData (`@MainActor`)
- **`FirebaseActivityRepository`** – stores activities in Firestore (`@MainActor`)

On top of them sits the single implementation of `SportActivityRepository`:

- **`CompositeActivityRepository`** – routes writes and deletes by `StorageType` (derived from the store that returned the record) and reads by filter; for the `.all` filter it first yields local data and then merges in remote data (progressive loading via `AsyncThrowingStream`)

The composite depends only on the domain protocol, not on the concrete toolkits, so it can be tested against a mock store.

`storageType` is never persisted — it is derived from the store that returned the record. Firestore documents are mapped through the `Codable` DTO `ActivityDocument`; a document that cannot be decoded is skipped and reported to Crashlytics, so a single broken record does not take down the whole list.

Activities belong to a specific user. Remote ones live under `users/{uid}/activities`; local ones carry a `userID` in `ActivityRecord`, and every query filters by it. That is why the local store also implements `PurgeableActivityStore` — the remote one does not, because deleting server data on sign-out is a different decision.

### Presentation layer – MVI with coordinators

Every feature is a separate SPM package with a consistent structure:

```
Feature/
├── Coordinator/
│   ├── FeatureCoordinator.swift      # Owns navigation, creates view models
│   └── FeatureCoordinatorView.swift  # SwiftUI wrapper of the coordinator
├── ViewModel/
│   └── FeatureViewModel.swift        # @Observable, @MainActor, State + Intent
└── Views/
    └── FeatureView.swift             # Purely declarative SwiftUI view
```

#### Coordinator

- Owns the `NavigationPath` and creates view models
- Receives delegate callbacks from view models and handles navigation
- Contains no business logic and no use cases

#### View model

- `@Observable @MainActor final class`
- Holds a single `State` (the values shown in the view) and an `Intent` (an enum of the actions the view can trigger)
- All communication goes through the `onIntent(_:)` method — a unidirectional flow: intent in, new state out
- Use cases are injected via the `@Injected` property wrapper
- The delegate (coordinator) is notified about navigation events

```swift
// The view calls:
viewModel.onIntent(.selectFilter(.local))

// The view model handles it:
func onIntent(_ intent: Intent) {
    switch intent {
    case let .selectFilter(filter):
        state.selectedFilter = filter
        startFetching()
    ...
    }
}
```

#### View

- Reads data from `viewModel.state` and sends actions via `viewModel.onIntent(...)`
- Contains no logic

### Application (`DependencyInjection`)

Wires the layers together:

- `DependencyRegistration.registerAll()` – registers all dependencies at app launch
- `InjectedValues` + `@Injected` – a simple DI container with no third-party dependencies
- Use cases are **computed properties** (created on every access), repositories are **singleton instances** stored in an `InjectionKey`
- `AppCoordinator` – the root coordinator; owns all feature coordinators and handles tab navigation

---

## Technologies

| Area | Technology |
|---|---|
| UI | SwiftUI, iOS 26+ |
| Local storage | SwiftData |
| Remote storage | Firebase Firestore |
| Authentication | Firebase Auth, Google Sign-In |
| Concurrency | Swift 6.2, async/await, AsyncThrowingStream |
| State management | @Observable (Swift Observation) |
| Tests | Swift Testing, GitHub Actions |

---

## Data flow

Activities are loaded as an `AsyncThrowingStream` that emits values progressively:

1. First, the **local data** (immediately)
2. Then the **combination of local and remote data** (once the network request completes)

This way the user sees data right away, without waiting for the network.

---

## Sessions and sign-in

The rule is simple: **an anonymous session survives a restart, a non-anonymous one does not.**

| State at launch | What happens |
|---|---|
| No stored session | Anonymous sign-in (fresh install) |
| Anonymous session | Kept, the user continues |
| Linked or fully signed-in session | Signed out, the sign-in sheet is shown |

This is decided by `AppCoordinator.prepareSession()`. Signing out is **deliberately handled at launch, not at termination** — iOS does not guarantee any callback on termination, so deciding at launch also works after a force quit or a crash.

While nobody is signed in, `RootView` keeps a modal sign-in sheet open. It cannot be dismissed with a gesture (`interactiveDismissDisabled`) and closes on its own as soon as sign-in succeeds. It uses `ProfileCoordinatorView`, the same coordinator as the Profile tab — the choice propagates there through the shared `authService` without any extra synchronization.

Linking an anonymous account with Google **keeps the UID**, so the user keeps both local and remote data. `addStateDidChangeListener`, however, only reacts to a UID change and to sign-out, so after linking `FirebaseAuthService` refreshes its state itself.

User-bound data has to be reloaded after an account change. `RootView` therefore observes `currentUserID` and calls `AppCoordinator.sessionUserChanged()`. `onAppear` alone is not enough — after launch it runs before the user signs in through the sheet, and the sheet only covers the tab, so it does not fire again.

When an **anonymous** account signs out, `SignOutUseCase` deletes its local activities — an anonymous account cannot be returned to, so the data would stay on the device forever, unreachable. Data of a linked account is kept, because signing in with Google again returns the same UID.

---

## Tests

Tests live in the `SharedDomain` (use cases) and `ActivityRepository` (composite repository) packages. Both run against mocks, so they need neither Firebase nor a simulator.

In Xcode, Cmd+U runs them — the scheme points to `SportTracker.xctestplan`, which contains both test targets.

From the command line:

```bash
cd DomainLayer/SharedDomain && swift test
cd DataLayer/Repositories/ActivityRepository && swift test
```

The same commands run on every push and pull request in [GitHub Actions](.github/workflows/tests.yml).

This is why the manifests of these two packages also declare `.macOS(.v14)`. The app targets iOS only and the platform is not listed anywhere else — but without it, `swift test` builds for the default, much older macOS version and fails because `Duration` requires macOS 13+.

---

## Future work / known limitations

- extend the unit tests,
- add tests for the data layer — the toolkits have none today, so sorting and filtering by user are verified only through mocks in the composite,
- define an `AppTheme` and use it as the source of colors, fonts, etc.,
- properly test and, where needed, improve accessibility,
- extend analytics,
- localization needs a more sustainable approach — decide whether localizations live per package or centrally,
- move the view lifecycle into view models,
- cancel running tasks when a view model is deallocated, except tasks whose result we need,
- introduce protocols in the presentation layer,
- implement skeleton loading states,
- adopt SwiftLint,
- decide on and adopt a DI library, e.g. Factory, replacing the current solution,
- adopt Firebase App Check (App Attest provider),
- update and complete the localization,
- consider moving "add activity" out of the tab bar.

---

## License

Released under the [MIT License](LICENSE).
