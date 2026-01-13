//
//  RegistrationViewModel.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import Foundation

/// ViewModel for the Registration screen
final class RegistrationViewModel {
    
    // MARK: - Properties
    
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var whatsappNumber: String = ""
    var countryCode: String = "IN"  // CountryCode should be "IN" not "+91"
    var gender: String = "M"        // Gender should be single letter
    var age: String = ""
    var ageUnit: String = "Y"       // AgeUnit should be single letter
    
    // MARK: - Validation
    
    /// Validates all input fields
    /// - Throws: ValidationError if any field is invalid
    func validateInputs() throws {
        // Name validation
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Full Name")
        }
        
        // Email validation
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Email ID")
        }
        
        guard isValidEmail(email) else {
            throw ValidationError.invalidEmail
        }
        
        // Phone validation
        guard !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Phone Number")
        }
        
        // Age validation
        guard !age.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Age")
        }
        
        // Set WhatsApp to phone if empty
        if whatsappNumber.isEmpty {
            whatsappNumber = phoneNumber
        }
    }
    
    // MARK: - Registration
    
    /// Registers the doctor with the API
    /// - Parameter completion: Completion handler with Result
    func register(completion: @escaping (Result<Doctor, APIError>) -> Void) {
        let request = RegistrationRequest(
            name: name.trimmingCharacters(in: .whitespaces),
            nameUpper: name.trimmingCharacters(in: .whitespaces).uppercased(),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespaces),
            whatsappNumber: (whatsappNumber.isEmpty ? phoneNumber : whatsappNumber).trimmingCharacters(in: .whitespaces),
            countryCode: "IN",  // As per assignment spec
            email: email.trimmingCharacters(in: .whitespaces),
            gender: gender,     // Should be "M", "F", or "O"
            age: age.trimmingCharacters(in: .whitespaces),
            ageUnit: "Y"        // As per assignment spec
        )
        
        APIService.shared.registerDoctor(request: request, completion: completion)
    }
    
    // MARK: - Private Helpers
    
    /// Validates email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
