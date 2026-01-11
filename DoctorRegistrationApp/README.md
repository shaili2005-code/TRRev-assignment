# Doctor Registration iOS App

A complete iOS application for doctor registration and management built with UIKit, Storyboards, and MVVM architecture.

## 📱 Screenshots

| Registration | Doctors List | Dashboard |
|--------------|--------------|-----------|
| Basic Details Form | TableView with doctors | Doctor greeting & actions |

---

## 🚀 How to Run

### Prerequisites
- **macOS** with Xcode 15+ installed
- iOS Simulator (iPhone 11 or later recommended)

### Steps

1. **Open the project in Xcode:**
   ```bash
   open DoctorRegistrationApp.xcodeproj
   ```

2. **Select a simulator:**
   - Click on the device dropdown in Xcode toolbar
   - Choose **iPhone 14** or **iPhone 11**

3. **Build and Run:**
   - Press `Cmd + R` or click the ▶️ Play button

4. **Test the app:**
   - Fill in the registration form
   - Tap the blue arrow button to submit
   - View the doctors list
   - Tap a doctor to see the dashboard

---

## 🔧 Troubleshooting

### Error: "The document could not be opened"

**Symptom:** Storyboard files show errors about duplicate IDs

**Fix:**
1. Close Xcode completely (`Cmd + Q`)
2. Delete derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/DoctorRegistrationApp-*
   ```
3. Reopen the project and rebuild (`Cmd + Shift + K`, then `Cmd + B`)

---

### Error: "No such module 'UIKit'"

**Fix:**
1. Clean build folder: `Cmd + Shift + K`
2. Close and reopen Xcode
3. Build again: `Cmd + B`

---

### Error: "Could not connect to server" / Network errors

**Symptom:** API calls fail

**Check:**
1. Ensure you have internet connectivity
2. The API endpoint uses HTTP (not HTTPS) - this is already configured in `Info.plist`
3. Test the API with curl:
   ```bash
   curl -X GET "http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_C_TEST_REGISTER_NEW_CDS/ZCDS_C_TEST_REGISTER_NEW" -H "Accept: application/json"
   ```

---

### Error: "Signing requires a development team"

**Fix:**
1. Open Xcode → Project Navigator → DoctorRegistrationApp
2. Go to **Signing & Capabilities** tab
3. Select your **Team** from the dropdown
4. Or select "None" if running on simulator only

---

## 📁 Project Structure

```
DoctorRegistrationApp/
├── Models/
│   ├── Doctor.swift           # Doctor data model
│   └── APIModels.swift        # Request/Response models
├── ViewModels/
│   ├── RegistrationViewModel.swift
│   ├── DoctorsListViewModel.swift
│   └── DashboardViewModel.swift
├── Controllers/
│   ├── RegistrationViewController.swift
│   ├── DoctorsListViewController.swift
│   └── DashboardViewController.swift
├── Views/
│   └── DoctorTableViewCell.swift
├── Services/
│   └── APIService.swift       # Network layer
├── Extensions/
│   └── UIView+Extensions.swift
├── Base.lproj/
│   ├── Main.storyboard        # All 3 screens
│   └── LaunchScreen.storyboard
└── Info.plist                 # App config (HTTP enabled)
```

---

## 🔌 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/ZCDS_C_TEST_REGISTER_NEW` | Register new doctor |
| GET | `/ZCDS_C_TEST_REGISTER_NEW` | Get all doctors |
| GET | `/ZCDS_C_TEST_REGISTER_NEW(guid'...')` | Get single doctor |

**Base URL:** `http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_C_TEST_REGISTER_NEW_CDS`

---

## 📋 Features

- ✅ Registration form with validation
- ✅ Gender selection (Male/Female/Others)
- ✅ API integration with URLSession
- ✅ Doctors list with pull-to-refresh
- ✅ Dashboard with doctor greeting
- ✅ Clean MVVM architecture
- ✅ iOS 13+ support

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|------------|
| UI Framework | UIKit |
| Layout | Storyboard + Auto Layout |
| Architecture | MVVM |
| Networking | URLSession (no 3rd party) |
| Min iOS | 13.0 |
| Language | Swift 5.0 |

---

## 📝 Testing the App

### Registration Test Data
```
Full Name: John Doe
Email: john@example.com
Gender: Male
Practicing From: 06 / 2020
```

### Expected Flow
1. Fill form → Tap Submit → Success alert
2. Tap "Continue" → Doctors List appears
3. Tap any doctor → Dashboard shows greeting

---

## ⚠️ Known Limitations

- Phone, WhatsApp, Country Code, Age fields use default values (hidden in UI)
- Dashboard quick action buttons are UI-only (no functionality)
- No data persistence (API is the source of truth)

---

## 📧 Support

If you encounter issues not covered here, try:
1. Clean build: `Cmd + Shift + K`
2. Delete derived data
3. Restart Xcode
4. Check Xcode console for detailed error messages
