//
//  Doctor.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import Foundation

/// Model representing a Doctor entity from the API
struct Doctor: Codable {
    let guid: String
    let name: String
    let nameUpper: String
    let email: String
    let phoneNumber: String
    let whatsappNumber: String
    let countryCode: String
    let gender: String
    let age: String
    let ageUnit: String
    let practFromMonth: String?  // Optional - may not be in response
    let practFromYear: String?   // Optional - may not be in response
    
    enum CodingKeys: String, CodingKey {
        case guid = "ID" // API returns "ID", not "Guid"
        case name = "Name"
        case nameUpper = "NameUpper"
        case email = "Email"
        case phoneNumber = "PhoneNo"
        case whatsappNumber = "WhatsappNo"
        case countryCode = "CountryCode"
        case gender = "Gender"
        case age = "Age"
        case ageUnit = "AgeUnit"
        case practFromMonth = "PractFromMonth"
        case practFromYear = "PractFromYear"
    }
    
    /// Short GUID for display purposes
    var shortGuid: String {
        if guid.count > 12 {
            return String(guid.prefix(12)) + "..."
        }
        return guid
    }
}
