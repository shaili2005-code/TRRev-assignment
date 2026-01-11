//
//  APIModels.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import Foundation

// MARK: - Registration Request

/// Request model for doctor registration API
struct RegistrationRequest: Codable {
    let name: String
    let nameUpper: String
    let email: String
    let phoneNumber: String
    let whatsappNumber: String
    let countryCode: String
    let gender: String
    let age: String
    let ageUnit: String
    let practFromMonth: String
    let practFromYear: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case nameUpper = "NameUpper"
        case email = "Email"
        case phoneNumber = "PhoneNumber"
        case whatsappNumber = "WhatsappNumber"
        case countryCode = "CountryCode"
        case gender = "Gender"
        case age = "Age"
        case ageUnit = "AgeUnit"
        case practFromMonth = "PractFromMonth"
        case practFromYear = "PractFromYear"
    }
}

// MARK: - API Response Wrappers

/// Wrapper for OData response containing multiple doctors
struct DoctorsListResponse: Codable {
    let d: DoctorsResults
}

struct DoctorsResults: Codable {
    let results: [Doctor]
}

/// Wrapper for OData response containing single doctor
struct SingleDoctorResponse: Codable {
    let d: Doctor
}

/// Wrapper for registration response
struct RegistrationResponse: Codable {
    let d: Doctor
}

// MARK: - API Error

/// Custom error types for API operations
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}

// MARK: - Validation Error

/// Validation error for form inputs
enum ValidationError: Error, LocalizedError {
    case emptyField(String)
    case invalidEmail
    case invalidPhoneNumber
    case invalidAge
    
    var errorDescription: String? {
        switch self {
        case .emptyField(let field):
            return "\(field) is required"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPhoneNumber:
            return "Please enter a valid phone number"
        case .invalidAge:
            return "Please enter a valid age"
        }
    }
}
