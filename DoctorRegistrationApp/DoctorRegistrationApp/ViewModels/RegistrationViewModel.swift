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
    var countryCode: String = "+91"
    var gender: String = "Male"
    var age: String = ""
    var ageUnit: String = "Years"
    var practFromMonth: String = ""
    var practFromYear: String = ""
    
    // MARK: - Validation
    
    /// Validates all input fields (only visible fields in UI)
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
        
        // Practicing From validation (visible in UI)
        guard !practFromMonth.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Practicing From (Months)")
        }
        
        guard !practFromYear.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Practicing From (Years)")
        }
        
        // Set default values for hidden fields if empty
        if phoneNumber.isEmpty {
            phoneNumber = "9999999999"
        }
        if whatsappNumber.isEmpty {
            whatsappNumber = phoneNumber
        }
        if age.isEmpty {
            age = "30"
        }
    }
    
    // MARK: - Registration
    
    /// Registers the doctor with the API
    /// - Parameter completion: Completion handler with Result
    func register(completion: @escaping (Result<Doctor, APIError>) -> Void) {
        let request = RegistrationRequest(
            name: name.trimmingCharacters(in: .whitespaces),
            nameUpper: name.trimmingCharacters(in: .whitespaces).uppercased(),
            email: email.trimmingCharacters(in: .whitespaces),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespaces),
            whatsappNumber: whatsappNumber.trimmingCharacters(in: .whitespaces),
            countryCode: countryCode.trimmingCharacters(in: .whitespaces),
            gender: gender,
            age: age.trimmingCharacters(in: .whitespaces),
            ageUnit: ageUnit,
            practFromMonth: practFromMonth.trimmingCharacters(in: .whitespaces),
            practFromYear: practFromYear.trimmingCharacters(in: .whitespaces)
        )
        
        MockAPIService.shared.registerDoctor(request: request, completion: completion)
    }
    
    // MARK: - Private Helpers
    
    /// Validates email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
