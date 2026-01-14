# Doctor Registration App

A native iOS application for doctor registration and management, built with Swift and UIKit.

## Features

- **Multi-step Registration** - 3-step wizard for doctor registration
- **Doctor List** - View all registered doctors with search functionality
- **Dashboard** - Doctor profile and quick actions
- **Real API Integration** - Connected to SAP OData backend

## Tech Stack

- **Language:** Swift 5
- **UI Framework:** UIKit
- **Architecture:** MVVM
- **Networking:** URLSession
- **UI Design:** Storyboard + Programmatic

## Project Structure

```
DoctorRegistrationApp/
├── Controllers/          # ViewControllers
├── ViewModels/           # Business logic
├── Models/               # Data models
├── Services/             # API networking
├── Views/                # Custom UI components
├── Extensions/           # Helper methods
└── Base.lproj/           # Storyboards
```

## Requirements

- iOS 13.0+
- Xcode 14.0+

## Getting Started

1. Clone the repository
2. Open `DoctorRegistrationApp.xcodeproj` in Xcode
3. Build and run on simulator or device

## API

The app connects to a SAP OData API for:
- POST - Register new doctor
- GET - Fetch all doctors
- GET - Fetch doctor by ID

## Screenshots

*Registration → Doctors List → Dashboard*
