# 📱 DoctorRegistrationApp - Codebase Walkthrough

> **A comprehensive guide to understanding this iOS Doctor Registration application built with Swift, UIKit, MVVM architecture, and OData API integration.**

---

## 📋 Table of Contents

1. [Architecture Overview](#-architecture-overview)
2. [Tech Stack & Why It's Used](#-tech-stack--why-its-used)
3. [Project Structure](#-project-structure)
4. [File-by-File Explanation](#-file-by-file-explanation)
5. [How Storyboard & Swift Code Connect](#-how-storyboard--swift-code-connect)
6. [How API Calls Work](#-how-api-calls-work)
7. [Data Flow Diagram](#-data-flow-diagram)
8. [Key Concepts to Remember](#-key-concepts-to-remember)
9. [Interview Talking Points](#-interview-talking-points)

---

## 🏗 Architecture Overview

This app follows the **MVVM (Model-View-ViewModel)** architectural pattern with a **hybrid UI approach** combining:
- **Storyboard-based layouts** for static UI structure
- **Programmatic UI** for dynamic components and reusable views

```
┌─────────────────────────────────────────────────────────────────┐
│                          USER ACTION                            │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     VIEW (ViewController)                       │
│  • Handles user input via IBActions                             │
│  • Updates UI via IBOutlets                                     │
│  • Delegates business logic to ViewModel                        │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        VIEWMODEL                                 │
│  • Contains business logic & validation                         │
│  • Transforms data for display                                  │
│  • Calls API Service for network operations                     │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   SERVICE (APIService)                          │
│  • Makes HTTP requests (GET/POST)                               │
│  • Handles response parsing                                     │
│  • Returns Result type with success/failure                     │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         MODEL                                    │
│  • Data structures (Doctor, RegistrationRequest)                │
│  • Codable for JSON encoding/decoding                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛠 Tech Stack & Why It's Used

| Technology | Purpose | Why This Choice |
|------------|---------|-----------------|
| **Swift** | Programming language | Modern, type-safe, Apple's recommended language for iOS |
| **UIKit** | UI Framework | Industry standard, full control over UI, works with Storyboard |
| **Storyboard** | Visual UI Design | Rapid prototyping, visual representation of app flow |
| **MVVM Pattern** | Architecture | Separates concerns, testable, maintainable code |
| **URLSession** | Networking | Native iOS networking, no external dependencies |
| **Codable** | JSON Parsing | Swift-native, type-safe serialization/deserialization |
| **OData API** | Backend Protocol | SAP-standard RESTful API format with JSON responses |
| **Singleton Pattern** | Service Layer | Single source of truth for API calls across the app |

### Why MVVM over MVC?
- **Testability**: ViewModels can be unit tested without UI
- **Separation of Concerns**: UI logic stays in ViewController, business logic in ViewModel
- **Reusability**: ViewModels can be reused across different views
- **Maintainability**: Smaller, focused classes are easier to modify

---

## 📁 Project Structure

```
DoctorRegistrationApp/
├── AppDelegate.swift           # App lifecycle, navigation bar styling
├── SceneDelegate.swift         # Window scene management (iOS 13+)
├── Info.plist                  # App configuration
│
├── Base.lproj/                 # Storyboard files
│   ├── Main.storyboard         # Main app screens & navigation
│   └── LaunchScreen.storyboard # App launch screen
│
├── Controllers/                # ViewControllers (the "View" in MVVM)
│   ├── RegistrationViewController.swift      # Single-step registration
│   ├── MultiStepRegistrationViewController.swift  # 3-step registration wizard
│   ├── DoctorsListViewController.swift       # List of all doctors
│   └── DashboardViewController.swift         # Doctor's dashboard
│
├── ViewModels/                 # Business logic layer
│   ├── RegistrationViewModel.swift           # Registration form logic
│   ├── DoctorsListViewModel.swift            # Doctors list data handling
│   └── DashboardViewModel.swift              # Dashboard data management
│
├── Models/                     # Data structures
│   ├── Doctor.swift            # Doctor entity model
│   └── APIModels.swift         # API request/response models
│
├── Services/                   # Network layer
│   ├── APIService.swift        # Real API integration
│   └── MockAPIService.swift    # Mock data for testing
│
├── Views/                      # Custom UI components
│   └── DoctorTableViewCell.swift  # Custom table cell
│
└── Extensions/                 # UIKit extensions
    └── UIView+Extensions.swift    # Helper methods for styling
```

---

## 📄 File-by-File Explanation

### 🔷 Entry Points

#### `AppDelegate.swift`
**What it does**: Application lifecycle manager and global configuration.

```swift
@main  // This tells iOS this is the entry point
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_:didFinishLaunchingWithOptions:) -> Bool {
        // Configure navigation bar appearance globally
        // Sets white background, custom tint color
    }
}
```
**Key Responsibility**: Sets up `UINavigationBarAppearance` so all navigation bars have consistent styling.

---

#### `SceneDelegate.swift`
**What it does**: Manages the app's window scene (introduced in iOS 13+).

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?  // Reference to the app's main window
}
```
**Why it exists**: iOS 13+ supports multiple windows (iPad split view), so window management moved from AppDelegate to SceneDelegate.

---

### 🔷 Models

#### `Doctor.swift`
**What it does**: Represents a doctor entity from the API.

```swift
struct Doctor: Codable {
    let guid: String
    let name: String
    let email: String
    let phoneNumber: String
    // ... other properties
    
    enum CodingKeys: String, CodingKey {
        case guid = "ID"           // API returns "ID", we use "guid"
        case phoneNumber = "PhoneNo"  // API uses different naming
    }
}
```

**Key Concepts**:
- `Codable` = Can convert to/from JSON automatically
- `CodingKeys` = Maps Swift property names to API JSON keys
- Computed property `shortGuid` = Truncates long GUIDs for display

---

#### `APIModels.swift`
**What it does**: Defines all API-related data structures.

| Struct | Purpose |
|--------|---------|
| `RegistrationRequest` | Data sent to API when registering a doctor |
| `DoctorsListResponse` | Wrapper for list of doctors (OData format: `{d: {results: [...]}}`) |
| `SingleDoctorResponse` | Wrapper for single doctor (OData format: `{d: {...}}`) |
| `APIError` | Custom error types with user-friendly messages |
| `ValidationError` | Form validation errors |

---

### 🔷 Services (Network Layer)

#### `APIService.swift` ⭐ **Most Important File**
**What it does**: Handles ALL network communication with the backend.

**Pattern Used**: **Singleton**
```swift
final class APIService {
    static let shared = APIService()  // Single shared instance
    private init() {}                  // Private = can't create new instances
}
```

**Three Main Methods**:

1. **`registerDoctor(request:completion:)`** - POST request
   ```swift
   func registerDoctor(request: RegistrationRequest, 
                       completion: @escaping (Result<Doctor, APIError>) -> Void)
   ```
   - Creates URLRequest with POST method
   - Sets headers: `Content-Type: application/json`, `X-CSRF-Token: X`
   - Encodes `RegistrationRequest` to JSON
   - Decodes response to `Doctor`

2. **`fetchDoctors(completion:)`** - GET all doctors
   ```swift
   func fetchDoctors(completion: @escaping (Result<[Doctor], APIError>) -> Void)
   ```
   - Appends `?$format=json` to URL (OData requirement)
   - Handles OData response structure `{d: {results: [...]}}`

3. **`fetchDoctor(guid:completion:)`** - GET single doctor
   ```swift
   func fetchDoctor(guid: String, completion: @escaping (Result<Doctor, APIError>) -> Void)
   ```
   - Uses OData key format: `(guid'<GUID_VALUE>')`

**Important Patterns in APIService**:
```swift
// 1. Always dispatch to main thread for UI updates
DispatchQueue.main.async {
    completion(.success(doctor))
}

// 2. Result type for success/failure handling
completion(.failure(.networkError(error)))
completion(.success(response.d.results))

// 3. Fallback decoding when response structure varies
do {
    let response = try decoder.decode(RegistrationResponse.self, from: data)
} catch {
    // Try alternate structure...
}
```

---

### 🔷 ViewModels

#### `RegistrationViewModel.swift`
**What it does**: Manages registration form data and validation.

**Properties**:
```swift
var name: String = ""
var email: String = ""
var phoneNumber: String = ""
var gender: String = "M"    // M, F, or O
var age: String = ""
var ageUnit: String = "Y"   // Y for Years
```

**Key Methods**:
- `validateInputs()` - Throws `ValidationError` if fields are invalid
- `register(completion:)` - Calls `APIService.shared.registerDoctor()`
- `isValidEmail(_:)` - Regex validation for email format

---

#### `DoctorsListViewModel.swift`
**What it does**: Manages the list of doctors with search/filter capability.

```swift
private var allDoctors: [Doctor] = []  // Complete list from API
private(set) var doctors: [Doctor] = [] // Filtered list for display

func search(query: String) {
    doctors = allDoctors.filter { 
        $0.name.localizedCaseInsensitiveContains(query) 
    }
}
```

---

#### `DashboardViewModel.swift`
**What it does**: Manages doctor details for the dashboard screen.

**Key Pattern - Computed Properties**:
```swift
var doctorName: String {
    return doctor?.name ?? "Doctor"  // Safe unwrapping with default
}

var greetingMessage: String {
    return "Hello, \(doctorName)!"   // Derived from other property
}
```

---

### 🔷 Controllers (Views)

#### `MultiStepRegistrationViewController.swift`
**What it does**: 3-step registration wizard with animated transitions.

**Hybrid Approach**:
- **From Storyboard**: `progressContainer`, `stepLabel`, `titleLabel`, `actionButton`
- **Programmatic**: All text fields created in code for better control

```swift
// IBOutlets - connected in Storyboard
@IBOutlet weak var progressContainer: UIView!
@IBOutlet weak var stepLabel: UILabel!

// Programmatic - created in code
private let nameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Full Name"
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
}()
```

**Step Navigation**:
```swift
private var currentStep = 0
private let totalSteps = 3

@IBAction func actionButtonTapped(_ sender: UIButton) {
    switch currentStep {
    case 0: /* validate step 1, move to step 2 */
    case 1: /* validate step 2, move to step 3 */
    case 2: /* submit registration */
    }
}
```

---

#### `DoctorsListViewController.swift`
**What it does**: Displays all registered doctors in a searchable table.

**Key Components**:
1. **UITableView** with custom cell (`DoctorTableViewCell`)
2. **UISearchController** for filtering
3. **UIRefreshControl** for pull-to-refresh

**Protocol Conformances**:
```swift
extension DoctorsListViewController: UITableViewDataSource {
    func tableView(_:numberOfRowsInSection:) -> Int {
        return viewModel.numberOfDoctors
    }
    
    func tableView(_:cellForRowAt:) -> UITableViewCell {
        let doctor = viewModel.doctor(at: indexPath.row)
        cell.configure(with: doctor)
        return cell
    }
}

extension DoctorsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(query: text)
        tableView.reloadData()
    }
}
```

---

#### `DashboardViewController.swift`
**What it does**: Doctor's home screen after login/registration.

**Hybrid UI Pattern**:
- Storyboard: Basic layout, name label, activity indicator
- Programmatic: Grid of buttons, bottom navigation bar

```swift
// Called in viewDidLoad
func setupProgrammaticUI() {
    // Create logout button
    // Create 2x3 grid of feature buttons
    // Create bottom tab bar
}
```

---

### 🔷 Views

#### `DoctorTableViewCell.swift`
**What it does**: Custom cell for displaying doctor info in the list.

**100% Programmatic** (no Storyboard):
```swift
class DoctorTableViewCell: UITableViewCell {
    static let identifier = "DoctorTableViewCell"  // For dequeuing
    
    private let nameLabel: UILabel = { ... }()
    private let emailLabel: UILabel = { ... }()
    private let avatarView: UIView = { ... }()
    
    func configure(with doctor: Doctor) {
        nameLabel.text = doctor.name
        emailLabel.text = doctor.email
        // Generate initials for avatar
    }
}
```

---

### 🔷 Extensions

#### `UIView+Extensions.swift`
**What it does**: Adds reusable styling methods to UIKit classes.

```swift
extension UIView {
    func addCornerRadius(_ radius: CGFloat) { ... }
    func addBorder(color: UIColor, width: CGFloat) { ... }
    func addShadow(color: UIColor, opacity: Float, ...) { ... }
}

extension UIButton {
    func styleAsFilledButton(backgroundColor: UIColor, ...) { ... }
    func styleAsBorderedButton(borderColor: UIColor, ...) { ... }
}
```

**Usage**:
```swift
myButton.addCornerRadius(8)
myTextField.addBorder(color: .gray, width: 1)
```

---

## 🔗 How Storyboard & Swift Code Connect

### Connection Types

| Type | Direction | Example |
|------|-----------|---------|
| **IBOutlet** | Storyboard → Code | `@IBOutlet weak var nameLabel: UILabel!` |
| **IBAction** | Code ← Storyboard | `@IBAction func loginTapped(_ sender: UIButton)` |
| **Segue** | Screen → Screen | `performSegue(withIdentifier: "showDashboard", sender: nil)` |

### How IBOutlet Works
```
┌─────────────────────┐         ┌─────────────────────┐
│    Storyboard       │         │    Swift Code       │
│                     │         │                     │
│  [UILabel] ─────────┼────────►│ @IBOutlet weak var  │
│  (nameLabel)        │         │   nameLabel: UILabel│
│                     │         │                     │
│  [UIButton] ────────┼────────►│ @IBAction func      │
│  (Touch Up Inside)  │         │   buttonTapped()    │
└─────────────────────┘         └─────────────────────┘
```

### How Segues Work
1. **In Storyboard**: Control-drag from one ViewController to another, give it an identifier
2. **In Code**: 
```swift
// Trigger the navigation
performSegue(withIdentifier: "showDashboard", sender: nil)

// Pass data before transition
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDashboard",
       let dashboardVC = segue.destination as? DashboardViewController {
        dashboardVC.viewModel.setDoctor(selectedDoctor)
    }
}
```

---

## 🌐 How API Calls Work

### Complete Flow: Registering a Doctor

```
┌──────────────────────────────────────────────────────────────────────┐
│ 1. USER fills form and taps "Register"                               │
└──────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│ 2. ViewController.actionButtonTapped()                                │
│    • Collects text field values                                       │
│    • Passes to ViewModel                                              │
└──────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│ 3. ViewModel.register(completion:)                                    │
│    • Creates RegistrationRequest struct                               │
│    • Calls APIService.shared.registerDoctor()                         │
└──────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│ 4. APIService.registerDoctor()                                        │
│    • Creates URLRequest with POST method                              │
│    • Sets headers (Content-Type, X-CSRF-Token)                        │
│    • Encodes request to JSON                                          │
│    • Sends via URLSession.shared.dataTask()                           │
└──────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│ 5. SERVER processes request, returns JSON response                    │
│    { "d": { "ID": "...", "Name": "...", ... } }                       │
└──────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│ 6. APIService receives response                                       │
│    • Decodes JSON to Doctor struct                                    │
│    • Calls completion(.success(doctor)) on main thread                │
└──────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│ 7. ViewController receives result                                     │
│    • Shows success alert                                              │
│    • Navigates to DoctorsList                                         │
└──────────────────────────────────────────────────────────────────────┘
```

### API Details

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/ZCDS_C_TEST_REGISTER_NEW` | POST | Register new doctor |
| `/ZCDS_C_TEST_REGISTER_NEW?$format=json` | GET | Fetch all doctors |
| `/ZCDS_C_TEST_REGISTER_NEW(guid'<ID>')` | GET | Fetch single doctor |

### Request Headers
```swift
urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
urlRequest.setValue("X", forHTTPHeaderField: "X-CSRF-Token")  // SAP OData requirement
```

---

## 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          APP LAUNCH                                  │
│                              │                                       │
│                              ▼                                       │
│               ┌──────────────────────────────┐                       │
│               │   RegistrationViewController  │                       │
│               │         (Entry Point)         │                       │
│               └──────────────────────────────┘                       │
│                              │                                       │
│              ┌───────────────┼───────────────┐                       │
│              ▼                               ▼                       │
│   ┌─────────────────────┐        ┌─────────────────────┐            │
│   │  Multi-Step Form    │        │  Single-Step Form   │            │
│   │  (3 steps wizard)   │        │  (all fields)       │            │
│   └─────────────────────┘        └─────────────────────┘            │
│              │                               │                       │
│              └───────────────┬───────────────┘                       │
│                              │                                       │
│                              ▼                                       │
│               ┌──────────────────────────────┐                       │
│               │     RegistrationViewModel     │                       │
│               │   • Validates input           │                       │
│               │   • Calls API                 │                       │
│               └──────────────────────────────┘                       │
│                              │                                       │
│                              ▼                                       │
│               ┌──────────────────────────────┐                       │
│               │        APIService            │                       │
│               │   • POST /register           │                       │
│               └──────────────────────────────┘                       │
│                              │                                       │
│                              ▼                                       │
│               ┌──────────────────────────────┐                       │
│               │    DoctorsListViewController  │                       │
│               │   • Displays all doctors      │                       │
│               │   • Search/Filter             │                       │
│               └──────────────────────────────┘                       │
│                              │                                       │
│                              ▼                                       │
│               ┌──────────────────────────────┐                       │
│               │     DashboardViewController   │                       │
│               │   • Doctor profile            │                       │
│               │   • Feature buttons           │                       │
│               └──────────────────────────────┘                       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Key Concepts to Remember

### 1. Singleton Pattern (APIService)
```swift
static let shared = APIService()  // One instance for entire app
private init() {}                  // Prevents creating new instances
```
**Why?** Ensures single point of network access, easy to mock for testing.

### 2. Codable Protocol
```swift
struct Doctor: Codable { ... }  // Can encode to JSON and decode from JSON
```
**Why?** Automatic JSON serialization without third-party libraries.

### 3. Result Type
```swift
func fetchDoctors(completion: @escaping (Result<[Doctor], APIError>) -> Void)
```
**Why?** Type-safe way to handle success and failure cases.

### 4. Weak Self in Closures
```swift
viewModel.register { [weak self] result in
    self?.showAlert()  // Prevents retain cycles
}
```
**Why?** Prevents memory leaks when closure captures self.

### 5. DispatchQueue.main.async
```swift
DispatchQueue.main.async {
    completion(.success(doctor))
}
```
**Why?** UIKit updates must happen on main thread; network callbacks are on background threads.

---

## 💬 Interview Talking Points

### "Walk me through the app architecture"
> "This app uses MVVM architecture. ViewControllers handle UI interactions and connect to Storyboard elements via IBOutlets. ViewModels contain business logic and validation, keeping controllers thin. The APIService is a singleton that handles all network requests using URLSession. Models are Codable structs that map directly to API responses."

### "How does the API integration work?"
> "We use URLSession with the native iOS networking stack. The APIService is a singleton that exposes three methods: registerDoctor for POST requests, fetchDoctors for getting all doctors, and fetchDoctor for individual lookups. We handle OData response format where data comes wrapped in a 'd' object. All callbacks are dispatched to the main thread for safe UI updates."

### "Why MVVM instead of MVC?"
> "MVVM provides better separation of concerns. The ViewController stays focused on UI, while the ViewModel handles business logic like form validation and API calls. This makes the code more testable - I could unit test the RegistrationViewModel without involving any UI. It also makes the codebase more maintainable as it grows."

### "How do Storyboard and code work together?"
> "We use a hybrid approach. Storyboard defines the basic layout and navigation flow with segues. IBOutlets connect UI elements to code for data binding, while IBActions handle user interactions. For complex dynamic UIs like the dashboard grid, we build programmatically and add subviews in viewDidLoad."

### "How do you handle errors?"
> "We have custom error enums - APIError for network issues and ValidationError for form validation. These conform to LocalizedError protocol so they have user-friendly messages. Errors propagate through the Result type, and ViewControllers show appropriate alerts based on the error type."

---

## 🏃 Quick Run Commands

```bash
# Open project in Xcode
open DoctorRegistrationApp.xcodeproj

# Build from command line
xcodebuild -project DoctorRegistrationApp.xcodeproj -scheme DoctorRegistrationApp build

# Run tests
xcodebuild test -project DoctorRegistrationApp.xcodeproj -scheme DoctorRegistrationApp
```

---

**Good luck with your interview! 🍀**
