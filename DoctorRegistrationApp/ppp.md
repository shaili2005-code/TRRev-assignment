# 🎬 Doctor Registration App - Demo Recording Script

> **Total Duration:** ~10-12 minutes  
> **Before Recording:** Have Xcode open with the project, Simulator ready

---

## 🎯 INTRO (30 seconds)

**[Show Xcode Project Navigator]**

> "Hi! I'm going to walk you through the Doctor Registration App I built. This is an iOS application developed using **Swift** and **UIKit**, following the **MVVM architecture pattern**. The app connects to a real **SAP OData API** for doctor registration and retrieval."

---

## 📁 SCENE 1: Understanding the File Structure (1.5 minutes)

**[Expand folder structure in Xcode]**

> "Before diving into code, let me explain what each folder contains and why we organize code this way."

### 📂 The Folders & Their Purpose:

| Folder | What It Contains | Why It Exists |
|--------|------------------|---------------|
| **Controllers/** | ViewControllers (4 files) | Handles what user sees and interacts with |
| **ViewModels/** | Business logic (3 files) | Keeps logic separate from UI for testing |
| **Models/** | Data structures (2 files) | Defines the shape of our data |
| **Services/** | API networking (2 files) | Handles all server communication |
| **Views/** | Custom UI components (1 file) | Reusable custom interface elements |
| **Extensions/** | Helper methods (1 file) | Adds convenience methods to existing classes |
| **Base.lproj/** | Storyboards (2 files) | Visual UI design files |

> "This organization follows **MVVM** - Model-View-ViewModel pattern. It makes code maintainable, testable, and easier to understand."

---

## 📄 SCENE 2: AppDelegate.swift

### 🤔 What is this file?
> "**AppDelegate** is like the **manager of the entire app**. It's the first code that runs when your app starts, and it handles app-wide events like launching, going to background, or terminating."

### ❓ Why is it important?
> "Without AppDelegate, iOS wouldn't know how to start your app. It's where you put **one-time setup code** that affects the whole app - like setting default colors for navigation bars."

### 🔧 What does it do in THIS app?
> "In our app, it sets up **navigation bar styling** so all screens have the same look - white background with a blue tint color."

**[Open AppDelegate.swift]**

```swift
// Line 10: @main tells iOS "start here!"
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // This runs ONCE when app launches
    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create a style configuration object
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // Solid, not transparent
        appearance.backgroundColor = .white          // White background
        
        // Apply this style to ALL navigation bars in the app
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(red: 0.25, green: 0.35, blue: 0.65, alpha: 1.0)
        
        return true  // Yes, app launched successfully
    }
}
```

---

## 📄 SCENE 2B: Info.plist (Configuration File)

### 🤔 What is this file?
> "**Info.plist** is the app's **configuration file**. It tells iOS everything about your app - its name, version, what permissions it needs, which storyboard to load first, what orientations it supports."

### ❓ Why is it important?
> "Without Info.plist, your app won't run. iOS reads this file BEFORE launching your app to know how to configure it. If you need camera access, location, or network permissions - they go here."

### 🔧 What does it do in THIS app?

```xml
<!-- App Version -->
<key>CFBundleShortVersionString</key>
<string>1.0</string>

<!-- CRITICAL: Allows HTTP (not just HTTPS) connections -->
<!-- Our API uses HTTP, so we NEED this -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

<!-- Which Storyboard loads first -->
<key>UIMainStoryboardFile</key>
<string>Main</string>

<!-- Launch screen storyboard -->
<key>UILaunchStoryboardName</key>
<string>LaunchScreen</string>

<!-- Supported orientations (Portrait only on iPhone) -->
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>

<!-- Scene configuration - points to SceneDelegate -->
<key>UISceneDelegateClassName</key>
<string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
```

> "Key setting here: **NSAllowsArbitraryLoads = true** allows our app to connect to the HTTP API. By default, iOS blocks non-HTTPS connections for security."

---

## 📄 SCENE 2C: DoctorRegistrationApp.entitlements

### 🤔 What is this file?
> "**Entitlements** are special permissions your app requests from Apple - things like iCloud, Push Notifications, Apple Pay, Keychain sharing."

### ❓ Why is it important?
> "If you want to use Apple services, you declare them here. The App Store checks these entitlements match what your app actually does."

### 🔧 What does it do in THIS app?
> "Currently **empty** - we don't use any Apple services. If we added push notifications or iCloud later, we'd add entitlements here."

```xml
<plist version="1.0">
<dict>
    <!-- Empty - no special Apple services used -->
</dict>
</plist>
```

---

## 📄 SCENE 2D: MockAPIService.swift

### 🤔 What is this file?
> "**MockAPIService** is a fake version of APIService that returns dummy data. It's used for **testing** when you don't want to hit the real server."

### ❓ Why is it important?
> "When developing, the server might be down, slow, or you don't want to create real data. Mocks let you test UI without real network calls."

### 🔧 What does it do in THIS app?
> "It's **NOT actively used** - we use the real APIService. But it's kept as a placeholder if we need to test offline."

```swift
final class MockAPIService {
    static let shared = MockAPIService()
    private init() {}
    
    // Returns empty data - just a placeholder
    func fetchDoctors(completion: @escaping (Result<[Doctor], APIError>) -> Void) {
        completion(.success([]))  // Empty list
    }
}
```

---

## 📄 SCENE 2E: Assets.xcassets (Asset Catalog)

### 🤔 What is this file?
> "**Assets.xcassets** is the **asset catalog** - it stores all images, app icons, and colors used in your app in an organized way."

### ❓ Why is it important?
> "iOS needs different image sizes for different devices (@1x, @2x, @3x). The asset catalog manages this automatically. Also stores the app icon that appears on home screen."

### 🔧 What does it do in THIS app?
> "Contains **AppIcon** (the app's icon on home screen) and **AccentColor** (default tint color). Access images using `UIImage(named: "imageName")`."

---

## 📄 SCENE 2F: Main.storyboard & LaunchScreen.storyboard

### 🤔 What are these files?
> "**Storyboards** are visual files where you design your app's UI by dragging and dropping elements. They show all screens and how they connect."

### ❓ Why are they important?
> "They provide a visual way to design UI without writing code. You can see the entire app flow at once. Great for rapid prototyping."

### 🔧 What do they do in THIS app?

| Storyboard | Purpose |
|------------|---------|
| **Main.storyboard** | Contains ALL app screens: Registration, Doctors List, Dashboard. Defines segues (navigation) between screens. |
| **LaunchScreen.storyboard** | The splash screen shown for 1-2 seconds while app loads. Usually just shows logo/brand. |

> "In Main.storyboard, screens are connected via **segues** (arrows). When you call `performSegue(withIdentifier:)`, iOS follows these arrows to navigate."

---

## 📄 SCENE 2G: DoctorRegistrationApp.xcodeproj (Xcode Project)

### 🤔 What is this folder?
> "**.xcodeproj** is not a single file - it's a **package** (folder) containing all project settings, build configurations, and file references."

### ❓ Why is it important?
> "This IS your project. Double-click it to open the project in Xcode. Without it, Xcode wouldn't know what files belong together."

### 🔧 What's inside?

| File | Purpose |
|------|---------|
| **project.pbxproj** | The actual project file - lists ALL files, build settings, targets. (Don't edit manually!) |
| **project.xcworkspace** | Workspace container that Xcode uses |
| **xcuserdata/** | YOUR personal settings (window positions, breakpoints). NOT shared with team. |
| **xcshareddata/** | Shared schemes - build/run/test configurations that ARE shared with team |

```
DoctorRegistrationApp.xcodeproj/
├── project.pbxproj          ← Main project file (auto-generated)
├── project.xcworkspace/     ← Workspace settings
│   └── contents.xcworkspacedata
├── xcuserdata/              ← Your personal Xcode settings (gitignored)
└── xcshareddata/            ← Shared build schemes
```

> "**Important**: `xcuserdata` should be in `.gitignore` - it's personal preferences. `project.pbxproj` must NEVER be manually edited or you'll corrupt your project."

---

## 📄 SCENE 2H: RegistrationViewController.swift (Alternative Registration)

### 🤔 What is this file?
> "This is an **alternative single-page registration form** - all fields on one screen instead of the 3-step wizard."

### ❓ Why does it exist?
> "It was likely the original implementation before the multi-step version. Having two approaches shows flexibility - some users prefer one long form, others prefer steps."

### 🔧 Key difference from MultiStepRegistration:
> "Same functionality, different UX. Uses all IBOutlets from Storyboard instead of programmatic text fields."

---

## 📄 SCENE 3: SceneDelegate.swift

### 🤔 What is this file?
> "**SceneDelegate** manages the app's **window** - the container that holds all your UI. It was introduced in iOS 13 to support iPads showing multiple windows of the same app."

### ❓ Why is it important?
> "Before iOS 13, window management was in AppDelegate. Now it's here. If you delete this file, your app would show a black screen - no window means no UI!"

### 🔧 What does it do in THIS app?
> "In our simple app, it just holds a reference to the window. The default Storyboard loads automatically."

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?  // This holds your entire app's UI
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, ...) {
        // The window connects to the scene automatically when using Storyboard
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
```

---

## 📄 SCENE 4: Doctor.swift (Model)

### 🤔 What is this file?
> "**Doctor.swift** is a **Model** - it defines what a 'Doctor' looks like in our app. Think of it as a **blueprint** or **template** for doctor data."

### ❓ Why is it important?
> "Without this, we'd be passing around messy dictionaries. With a Model, Swift knows exactly what properties a doctor has, and the compiler catches errors if we use wrong property names."

### 🔧 What does it do in THIS app?
> "It describes a doctor with properties like name, email, phone, gender, and age. It also knows how to **convert itself to/from JSON** for API communication."

**[Open Models/Doctor.swift]**

```swift
// "Codable" means: I can become JSON, and JSON can become me
struct Doctor: Codable {
    let guid: String           // Unique ID from server
    let name: String           // "Dr. John Smith"
    let email: String          // "john@hospital.com"
    let phoneNumber: String    // "9876543210"
    let gender: String         // "M", "F", or "O"
    let age: String            // "35"
    let ageUnit: String        // "Y" for years
    
    // PROBLEM: API sends "PhoneNo", but we want to call it "phoneNumber"
    // SOLUTION: CodingKeys - a translator between API names and Swift names
    enum CodingKeys: String, CodingKey {
        case guid = "ID"              // API: "ID" → Swift: "guid"
        case name = "Name"            // API: "Name" → Swift: "name"
        case phoneNumber = "PhoneNo"  // API: "PhoneNo" → Swift: "phoneNumber"
        case email = "Email"
        case gender = "Gender"
        case age = "Age"
        case ageUnit = "AgeUnit"
    }
    
    // Computed property - calculates value on-the-fly
    var shortGuid: String {
        if guid.count > 12 {
            return String(guid.prefix(12)) + "..."  // Shorten long IDs for display
        }
        return guid
    }
}
```

---

## 📄 SCENE 5: APIModels.swift

### 🤔 What is this file?
> "**APIModels** contains **all the data structures related to API communication** - what we SEND to the server and what we RECEIVE back, plus error definitions."

### ❓ Why is it important?
> "APIs don't just accept/return Doctor objects. They have wrappers, different structures. This file defines those exact shapes so Swift can understand server responses."

### 🔧 What does it do in THIS app?
> "Defines: **RegistrationRequest** (what we send), **DoctorsListResponse** (list wrapper from API), **APIError** (what went wrong), and **ValidationError** (form problems)."

**[Open Models/APIModels.swift]**

```swift
// WHAT WE SEND when registering a new doctor
struct RegistrationRequest: Codable {
    let name: String
    let nameUpper: String      // API wants uppercase version too
    let phoneNumber: String
    let email: String
    let gender: String         // "M", "F", or "O"
    let age: String
    let ageUnit: String        // "Y"
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case phoneNumber = "PhoneNo"
        // ... maps Swift names to API names
    }
}

// WHAT WE RECEIVE - API wraps data like: { "d": { "results": [...] } }
struct DoctorsListResponse: Codable {
    let d: DoctorsResults     // The "d" wrapper (OData format)
}
struct DoctorsResults: Codable {
    let results: [Doctor]     // The actual list of doctors
}

// WHAT CAN GO WRONG - custom error types
enum APIError: Error, LocalizedError {
    case invalidURL           // Bad URL string
    case noData               // Server returned empty
    case networkError(Error)  // No internet, timeout
    case serverError(Int)     // Server returned error code (500, 404, etc.)
    case decodingError(Error) // JSON didn't match our struct
    
    // Human-readable error messages
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .serverError(let code): return "Server error: \(code)"
        // ...
        }
    }
}

// FORM VALIDATION PROBLEMS
enum ValidationError: Error, LocalizedError {
    case emptyField(String)   // "Name is required"
    case invalidEmail         // "Please enter valid email"
    case invalidPhoneNumber
    case invalidAge
}
```

---

## 📄 SCENE 6: APIService.swift ⭐ (Most Important!)

### 🤔 What is this file?
> "**APIService** is the **networking layer** - it's the ONLY file that talks to the internet. All API calls go through here."

### ❓ Why is it important?
> "Centralizing network code means: 1) One place to debug network issues, 2) Easy to add authentication later, 3) Can swap with mock for testing. Without this, network code would be scattered everywhere."

### 🔧 What does it do in THIS app?
> "Provides 3 functions: **registerDoctor** (POST new doctor), **fetchDoctors** (GET all doctors), **fetchDoctor** (GET one doctor by ID)."

### 💡 Design Pattern Used: SINGLETON
> "There's only ONE instance of APIService in the entire app. Everyone uses `APIService.shared` - this ensures consistent networking behavior."

**[Open Services/APIService.swift]**

```swift
// "final" = cannot be inherited/subclassed
final class APIService {
    
    // SINGLETON: One shared instance for entire app
    static let shared = APIService()   // Create ONE instance
    private init() {}                   // "private" prevents others from creating more
    
    // The API URL we're connecting to
    private let baseURL = "http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_C_TEST_REGISTER_NEW_CDS/ZCDS_C_TEST_REGISTER_NEW"
    
    // ═══════════════════════════════════════════════════════════════
    // FUNCTION 1: Register a new doctor (POST request)
    // ═══════════════════════════════════════════════════════════════
    func registerDoctor(request: RegistrationRequest, 
                        completion: @escaping (Result<Doctor, APIError>) -> Void) {
        
        // Step 1: Create URL from string
        guard let url = URL(string: baseURL) else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }
        
        // Step 2: Configure the HTTP request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"                                      // POST = create new data
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // Sending JSON
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")        // Want JSON back
        urlRequest.setValue("X", forHTTPHeaderField: "X-CSRF-Token")        // SAP security requirement
        
        // Step 3: Convert Swift object to JSON bytes
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(request)   // RegistrationRequest → JSON
            urlRequest.httpBody = jsonData               // Attach to request
        } catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        // Step 4: Send the request asynchronously
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            // Check for network failure (no internet, etc.)
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            // Check if server returned success (200-299)
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(.serverError(httpResponse.statusCode)))
                    }
                    return
                }
            }
            
            // Step 5: Decode JSON response to Doctor object
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RegistrationResponse.self, from: data!)
                
                // ⚠️ CRITICAL: Must switch to main thread for UI updates
                DispatchQueue.main.async {
                    completion(.success(response.d))  // Return the Doctor
                }
            } catch {
                // Handle JSON decoding errors...
            }
        }
        
        task.resume()  // Actually starts the network request
    }
    
    // ═══════════════════════════════════════════════════════════════
    // FUNCTION 2: Get all doctors (GET request)
    // ═══════════════════════════════════════════════════════════════
    func fetchDoctors(completion: @escaping (Result<[Doctor], APIError>) -> Void) {
        let urlString = baseURL + "?$format=json"  // OData needs this for JSON
        // Similar pattern: create request, send, decode response
        // Response: { "d": { "results": [doctor1, doctor2, ...] } }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // FUNCTION 3: Get one doctor by ID (GET request)
    // ═══════════════════════════════════════════════════════════════
    func fetchDoctor(guid: String, completion: @escaping (Result<Doctor, APIError>) -> Void) {
        let urlString = "\(baseURL)(guid'\(guid)')"  // OData format for single item
        // ...
    }
}
```

### 🔑 Key Concepts:
1. **`@escaping`** - The closure will be called LATER (after network finishes)
2. **`Result<Success, Failure>`** - Either success with data OR failure with error
3. **`DispatchQueue.main.async`** - Switch to main thread for UI safety
4. **`URLSession.shared.dataTask`** - iOS's built-in way to make HTTP requests

---

## 📄 SCENE 7: RegistrationViewModel.swift

### 🤔 What is this file?
> "**RegistrationViewModel** holds the **registration form's data and logic**. It stores what the user types, validates it, and sends it to the API."

### ❓ Why is it important?
> "In MVVM, ViewControllers should be 'dumb' - just display and collect input. The ViewModel handles 'thinking': Is this email valid? Should I enable the submit button? This makes testing easy - we can test validation without UI."

### 🔧 What does it do in THIS app?
> "Stores form fields (name, email, phone, etc.), validates all inputs, and calls APIService to register the doctor."

**[Open ViewModels/RegistrationViewModel.swift]**

```swift
final class RegistrationViewModel {
    
    // ═══════════════════════════════════════════════════════════════
    // STORED DATA: The ViewController writes here as user types
    // ═══════════════════════════════════════════════════════════════
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var whatsappNumber: String = ""
    var countryCode: String = "IN"   // Default: India
    var gender: String = "M"         // Default: Male
    var age: String = ""
    var ageUnit: String = "Y"        // Years
    
    // ═══════════════════════════════════════════════════════════════
    // VALIDATION: Check if all inputs are correct
    // ═══════════════════════════════════════════════════════════════
    func validateInputs() throws {
        // Check name is not empty
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Full Name")
        }
        
        // Check email is not empty
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Email ID")
        }
        
        // Check email format is valid (regex)
        guard isValidEmail(email) else {
            throw ValidationError.invalidEmail
        }
        
        // Check phone is provided
        guard !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Phone Number")
        }
        
        // If no WhatsApp number, use phone number
        if whatsappNumber.isEmpty {
            whatsappNumber = phoneNumber
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // SUBMIT: Create request and call API
    // ═══════════════════════════════════════════════════════════════
    func register(completion: @escaping (Result<Doctor, APIError>) -> Void) {
        // Build the request object from our stored data
        let request = RegistrationRequest(
            name: name.trimmingCharacters(in: .whitespaces),
            nameUpper: name.uppercased(),
            phoneNumber: phoneNumber,
            whatsappNumber: whatsappNumber.isEmpty ? phoneNumber : whatsappNumber,
            countryCode: "IN",
            email: email,
            gender: gender,
            age: age,
            ageUnit: "Y"
        )
        
        // Call the API service
        APIService.shared.registerDoctor(request: request, completion: completion)
    }
    
    // ═══════════════════════════════════════════════════════════════
    // HELPER: Email validation using Regular Expression (Regex)
    // ═══════════════════════════════════════════════════════════════
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
```

---

## 📄 SCENE 8: MultiStepRegistrationViewController.swift

### 🤔 What is this file?
> "This is the **3-step registration wizard ViewController**. It controls the entire registration flow - showing different form fields at each step."

### ❓ Why is it important?
> "ViewControllers are the **glue between UI and logic**. They receive user actions (button taps), update the ViewModel, and refresh the screen when needed. Without them, you'd see UI but nothing would work."

### 🔧 What does it do in THIS app?
> "Manages 3 steps: Step 1 (Name, Email) → Step 2 (Phone) → Step 3 (Gender, Age) → Submit. Uses animation to transition between steps."

### 💡 Design: Hybrid Approach
> "Some UI from Storyboard (progress bar, labels), some programmatic (text fields). Best of both worlds!"

**[Open Controllers/MultiStepRegistrationViewController.swift]**

```swift
class MultiStepRegistrationViewController: UIViewController {
    
    // ═══════════════════════════════════════════════════════════════
    // STORYBOARD CONNECTIONS (@IBOutlet = connected in Storyboard)
    // ═══════════════════════════════════════════════════════════════
    @IBOutlet weak var progressContainer: UIView!    // Gray background bar
    @IBOutlet weak var progressBarOrange: UIView!    // Orange filled part
    @IBOutlet weak var stepLabel: UILabel!           // "1/3", "2/3", "3/3"
    @IBOutlet weak var titleLabel: UILabel!          // "Basic Details"
    @IBOutlet weak var actionButton: UIButton!       // "Continue" / "Register"
    
    // ═══════════════════════════════════════════════════════════════
    // PROGRAMMATIC TEXT FIELDS (created in code, not Storyboard)
    // ═══════════════════════════════════════════════════════════════
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false  // Required for code-based layout
        return tf
    }()
    
    private let emailTextField: UITextField = { /* similar */ }()
    private let phoneTextField: UITextField = { /* similar */ }()
    private let ageTextField: UITextField = { /* similar */ }()
    
    // ═══════════════════════════════════════════════════════════════
    // STATE MANAGEMENT
    // ═══════════════════════════════════════════════════════════════
    private let viewModel = RegistrationViewModel()  // Holds form data
    private var currentStep = 0                       // 0, 1, or 2
    private let totalSteps = 3
    
    private let step1Container = UIView()  // Holds step 1 fields
    private let step2Container = UIView()  // Holds step 2 fields
    private let step3Container = UIView()  // Holds step 3 fields
    
    // ═══════════════════════════════════════════════════════════════
    // LIFECYCLE - Called when screen loads
    // ═══════════════════════════════════════════════════════════════
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgrammaticUI()   // Add text fields to screen
        updateProgress()         // Set progress bar to step 1
        updateStepUI()           // Set labels for step 1
    }
    
    // ═══════════════════════════════════════════════════════════════
    // BUTTON ACTION - When user taps Continue/Register
    // ═══════════════════════════════════════════════════════════════
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        switch currentStep {
        case 0:  // Step 1 → Step 2
            guard let name = nameTextField.text, !name.isEmpty else {
                showAlert("Please enter your name")
                return
            }
            viewModel.name = name        // Store in ViewModel
            viewModel.email = emailTextField.text ?? ""
            currentStep = 1              // Move to step 2
            animateStepTransition()
            
        case 1:  // Step 2 → Step 3
            guard let phone = phoneTextField.text, !phone.isEmpty else {
                showAlert("Please enter phone number")
                return
            }
            viewModel.phoneNumber = phone
            currentStep = 2
            animateStepTransition()
            
        case 2:  // Step 3 → Submit to API
            viewModel.age = ageTextField.text ?? ""
            submitRegistration()
            
        default: break
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // ANIMATION - Smooth transition between steps
    // ═══════════════════════════════════════════════════════════════
    private func animateStepTransition() {
        UIView.animate(withDuration: 0.3) {
            self.step1Container.isHidden = (self.currentStep != 0)
            self.step2Container.isHidden = (self.currentStep != 1)
            self.step3Container.isHidden = (self.currentStep != 2)
        }
        updateProgress()  // Animate progress bar
        updateStepUI()    // Update "1/3" → "2/3"
    }
    
    // ═══════════════════════════════════════════════════════════════
    // SUBMIT - Call API through ViewModel
    // ═══════════════════════════════════════════════════════════════
    private func submitRegistration() {
        activityIndicator?.startAnimating()
        
        // Validate first
        do {
            try viewModel.validateInputs()
        } catch {
            showAlert(error.localizedDescription)
            return
        }
        
        // Call API
        viewModel.register { [weak self] result in
            self?.activityIndicator?.stopAnimating()
            
            switch result {
            case .success(_):
                self?.showSuccessAndNavigate()
            case .failure(let error):
                self?.showAlert("Failed: \(error.localizedDescription)")
            }
        }
    }
}
```

### 🔑 Key Concepts:
- **`@IBOutlet`** - Connection from Storyboard element to code
- **`@IBAction`** - Function called when user interacts with Storyboard element
- **`[weak self]`** - Prevents memory leak in closures
- **`UIView.animate`** - Smooth visual transitions

---

## 📄 SCENE 9: DoctorsListViewController.swift

### 🤔 What is this file?
> "This ViewController **displays all registered doctors in a scrollable list** (UITableView). It also has search functionality."

### ❓ Why is it important?
> "It demonstrates iOS's **delegation pattern** - UITableView asks this controller 'how many rows?' and 'what should each row show?' This is how iOS lists work."

### 🔧 What does it do in THIS app?
> "Fetches doctors from API, displays them in a table with custom cells, allows searching by name, and navigates to Dashboard when a doctor is tapped."

**[Open Controllers/DoctorsListViewController.swift]**

```swift
class DoctorsListViewController: UIViewController {
    
    // Storyboard connections
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    // Properties
    private let viewModel = DoctorsListViewModel()
    private var searchController: UISearchController!
    private var selectedDoctor: Doctor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearch()
        fetchDoctors()  // Load data from API
    }
    
    // ═══════════════════════════════════════════════════════════════
    // SETUP: Configure table view
    // ═══════════════════════════════════════════════════════════════
    private func setupTableView() {
        tableView.delegate = self      // "I'll handle row taps"
        tableView.dataSource = self    // "I'll provide the data"
        
        // Register our custom cell class
        tableView.register(DoctorTableViewCell.self, 
                          forCellReuseIdentifier: DoctorTableViewCell.identifier)
    }
    
    // ═══════════════════════════════════════════════════════════════
    // FETCH: Get doctors from API
    // ═══════════════════════════════════════════════════════════════
    private func fetchDoctors() {
        activityIndicator.startAnimating()
        
        viewModel.fetchDoctors { [weak self] error in
            self?.activityIndicator.stopAnimating()
            
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            self?.tableView.reloadData()  // Refresh the list
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // NAVIGATION: Pass data to next screen
    // ═══════════════════════════════════════════════════════════════
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDashboard",
           let dashboardVC = segue.destination as? DashboardViewController {
            dashboardVC.viewModel.setDoctor(selectedDoctor!)  // Pass doctor data
        }
    }
}

// ═══════════════════════════════════════════════════════════════
// PROTOCOL: UITableViewDataSource - "What data to show?"
// ═══════════════════════════════════════════════════════════════
extension DoctorsListViewController: UITableViewDataSource {
    
    // "How many rows should the table have?"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDoctors
    }
    
    // "What should each row look like?"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DoctorTableViewCell.identifier) as! DoctorTableViewCell
        
        if let doctor = viewModel.doctor(at: indexPath.row) {
            cell.configure(with: doctor)  // Fill cell with doctor data
        }
        return cell
    }
}

// ═══════════════════════════════════════════════════════════════
// PROTOCOL: UITableViewDelegate - "What happens on interaction?"
// ═══════════════════════════════════════════════════════════════
extension DoctorsListViewController: UITableViewDelegate {
    
    // "User tapped a row"
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDoctor = viewModel.doctor(at: indexPath.row)
        performSegue(withIdentifier: "showDashboard", sender: nil)  // Navigate!
    }
}

// ═══════════════════════════════════════════════════════════════
// PROTOCOL: UISearchResultsUpdating - "Search text changed"
// ═══════════════════════════════════════════════════════════════
extension DoctorsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.search(query: query)   // Filter in ViewModel
        tableView.reloadData()           // Refresh display
    }
}
```

---

## 📄 SCENE 10: DoctorTableViewCell.swift

### 🤔 What is this file?
> "This is a **custom table cell** - a reusable row design that shows doctor info with an avatar, name, email, etc."

### ❓ Why is it important?
> "Default cells are boring. Custom cells let us design exactly how each item looks. Plus, it's **reusable** - the table recycles cells as you scroll."

### 🔧 What does it do in THIS app?
> "Displays: Avatar with initials, doctor name, email, gender, ID - all styled nicely with shadows and rounded corners."

**[Open Views/DoctorTableViewCell.swift]**

```swift
class DoctorTableViewCell: UITableViewCell {
    
    // Identifier for cell reuse
    static let identifier = "DoctorTableViewCell"
    
    // ═══════════════════════════════════════════════════════════════
    // UI ELEMENTS (all created in code)
    // ═══════════════════════════════════════════════════════════════
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = { /* ... */ }()
    private let emailLabel: UILabel = { /* ... */ }()
    
    // ═══════════════════════════════════════════════════════════════
    // INITIALIZATION
    // ═══════════════════════════════════════════════════════════════
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()  // Add all subviews and set constraints
    }
    
    // ═══════════════════════════════════════════════════════════════
    // CONFIGURE: Fill cell with doctor data
    // ═══════════════════════════════════════════════════════════════
    func configure(with doctor: Doctor) {
        nameLabel.text = doctor.name
        emailLabel.text = doctor.email
        
        // Generate initials: "John Smith" → "JS"
        let initials = doctor.name
            .split(separator: " ")     // ["John", "Smith"]
            .prefix(2)                  // Take first 2 words
            .compactMap { $0.first }   // Get first letter of each
            .map { String($0).uppercased() }
            .joined()                   // "JS"
        avatarLabel.text = initials.isEmpty ? "?" : initials
    }
    
    // ═══════════════════════════════════════════════════════════════
    // REUSE: Clean up before cell is recycled
    // ═══════════════════════════════════════════════════════════════
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil      // Clear old data
        emailLabel.text = nil
        avatarLabel.text = nil
    }
}
```

---

## 📄 SCENE 11: UIView+Extensions.swift

### 🤔 What is this file?
> "This file adds **helper methods** to existing UIKit classes using Swift **Extensions**. Instead of repeating styling code, we write it once here."

### ❓ Why is it important?
> "**DRY Principle** - Don't Repeat Yourself. Instead of writing `view.layer.cornerRadius = 8` everywhere, we write `view.addCornerRadius(8)`. Cleaner and less error-prone."

### 🔧 What does it do in THIS app?
> "Adds methods like `addCornerRadius()`, `addShadow()`, `addBorder()` to all views, and button styling helpers."

**[Open Extensions/UIView+Extensions.swift]**

```swift
// Add methods to ALL UIViews (UIButton, UILabel, etc. inherit these)
extension UIView {
    
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func addBorder(color: UIColor, width: CGFloat = 1.0) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.1, 
                   offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.masksToBounds = false  // Shadows need to draw outside bounds
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}

// Add methods to UIButton specifically
extension UIButton {
    
    func styleAsFilledButton(backgroundColor: UIColor, titleColor: UIColor = .white) {
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        addCornerRadius(8)
    }
    
    func styleAsBorderedButton(borderColor: UIColor, titleColor: UIColor) {
        backgroundColor = .clear
        setTitleColor(titleColor, for: .normal)
        addCornerRadius(8)
        addBorder(color: borderColor, width: 1.5)
    }
}

// USAGE anywhere in the app:
// myButton.addCornerRadius(16)
// myView.addShadow(opacity: 0.2)
// submitButton.styleAsFilledButton(backgroundColor: .blue)
```

---

## 🎬 DEMO: Running the App (2 minutes)

**[Run app on Simulator - walk through the complete flow]**

1. Fill Step 1: Name and Email
2. Fill Step 2: Phone numbers  
3. Fill Step 3: Gender and Age
4. Submit: Watch API call
5. Doctors List: See registered doctors
6. Search: Filter by name
7. Dashboard: Tap to see details
8. Logout: Return to start

---

## ✅ Pre-Recording Checklist

- [ ] Xcode project builds successfully
- [ ] Simulator reset
- [ ] Screen recording ready
- [ ] Sample data:
  - Name: `Dr. John Smith`
  - Email: `john.smith@hospital.com`  
  - Phone: `9876543210`
  - Age: `35`

---

**Good luck with your recording! 🍀**
