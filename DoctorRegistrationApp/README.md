# Doctor Registration iOS App

A complete iOS application for doctor registration and management built with UIKit and MVVM architecture.

## 📱 Features

### Multi-Step Registration (3 slides)
- **Step 1/3** - Name & Email
- **Step 2/3** - Phone Number & WhatsApp Number  
- **Step 3/3** - Gender, Age, Practicing From
- Slidable pages with arrow navigation
- Progress bar indicator

### Dashboard
- Profile header with "Hello, [Name]!" greeting
- Search bar
- Health tip banner (closeable)
- 6 Quick action buttons (Scan, Vaccine, My Bookings, Clinic, Ambulance, Nurse)
- Footer tab bar (Home, Appointments, Chat, History, Profile)
- **Logout button** to return to registration

### Doctors List
- TableView showing all registered doctors
- Pull-to-refresh functionality
- Tap to view doctor dashboard

### Real API Integration
- Integrated with SAP OData Service (`ZCDS_C_TEST_REGISTER_NEW`)
- Handles complex JSON/OData structures (d-wrapper parsing)
- Supported Operations: POST (Register), GET (List Doctors), GET (Doctor Details)

---

## 🚀 How to Run

### Prerequisites
- **macOS** with Xcode 15+ installed
- iOS Simulator (iPhone 14 or later recommended)

### Steps

1. **Open the project:**
   ```bash
   open DoctorRegistrationApp.xcodeproj
   ```

2. **Select a development team:**
   - Project → Signing & Capabilities → Select Team

3. **Build and Run:**
   - Press `Cmd + R` or click the ▶️ Play button

4. **Test the app:**
   - Fill in registration (3 steps)
   - View doctors list
   - Tap doctor → Dashboard
   - Tap logout icon to return to start

---

## 📁 Project Structure

```
DoctorRegistrationApp/
├── Models/
│   ├── Doctor.swift
│   └── APIModels.swift
├── ViewModels/
│   ├── RegistrationViewModel.swift
│   ├── DoctorsListViewModel.swift
│   └── DashboardViewModel.swift
├── Controllers/
│   ├── MultiStepRegistrationViewController.swift  ← NEW
│   ├── RegistrationViewController.swift
│   ├── DoctorsListViewController.swift
│   └── DashboardViewController.swift
├── Views/
│   └── DoctorTableViewCell.swift
├── Services/
│   ├── APIService.swift      ← NEW (Real OData Networking)
│   └── MockAPIService.swift  (Legacy/Fallback)
├── Extensions/
│   └── UIView+Extensions.swift
├── Base.lproj/
│   ├── Main.storyboard
│   └── LaunchScreen.storyboard
└── Info.plist
```

---

## � Registration Fields

| Step | Fields |
|------|--------|
| 1/3 | Full Name, Email ID |
| 2/3 | Country Code, Phone Number, WhatsApp Number |
| 3/3 | Gender (M/F/O), Age, Age Unit, Practicing From (Months/Years) |

### Sample JSON
```json
{
    "Name": "Mahesh",
    "NameUpper": "MAHESH",
    "PhoneNo": "7828827654",
    "WhatsappNo": "7828827654",
    "CountryCode": "+91",
    "Email": "mahesh@gmail.com",
    "Gender": "M",
    "Age": "21",
    "AgeUnit": "Y"
}
```

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|------------|
| UI Framework | UIKit (Programmatic + Storyboard) |
| Architecture | MVVM |
| Data Storage | SAP OData Service (Remote) |
| Min iOS | 13.0 |
| Language | Swift 5.0 |

---

## � Troubleshooting

### "Signing requires a development team"
1. Open Project → Signing & Capabilities
2. Select your Team from dropdown

### Storyboard errors
1. Close Xcode (`Cmd + Q`)
2. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/DoctorRegistrationApp-*`
3. Reopen and clean build (`Cmd + Shift + K`)

---

## 📧 Author

**Shaili Nishad**  
Built for TRRev Assignment
