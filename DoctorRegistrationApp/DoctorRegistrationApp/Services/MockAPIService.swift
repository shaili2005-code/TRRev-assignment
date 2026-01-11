//
//  MockAPIService.swift
//  DoctorRegistrationApp
//
//  Mock API Service using local storage
//

import Foundation

/// Mock API Service using UserDefaults for local storage
final class MockAPIService {
    
    // MARK: - Singleton
    
    static let shared = MockAPIService()
    
    private init() {
        // Load existing doctors from storage
        loadDoctors()
    }
    
    // MARK: - Storage Keys
    
    private let doctorsKey = "stored_doctors"
    
    // MARK: - Properties
    
    private var doctors: [Doctor] = []
    
    // MARK: - Storage Methods
    
    private func loadDoctors() {
        if let data = UserDefaults.standard.data(forKey: doctorsKey),
           let storedDoctors = try? JSONDecoder().decode([Doctor].self, from: data) {
            doctors = storedDoctors
        }
    }
    
    private func saveDoctors() {
        if let data = try? JSONEncoder().encode(doctors) {
            UserDefaults.standard.set(data, forKey: doctorsKey)
        }
    }
    
    // MARK: - Registration
    
    /// Register a new doctor
    func registerDoctor(request: RegistrationRequest, completion: @escaping (Result<Doctor, APIError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Create new doctor with unique GUID
            let newDoctor = Doctor(
                guid: UUID().uuidString,
                name: request.name,
                nameUpper: request.nameUpper,
                email: request.email,
                phoneNumber: request.phoneNumber,
                whatsappNumber: request.whatsappNumber,
                countryCode: request.countryCode,
                gender: request.gender,
                age: request.age,
                ageUnit: request.ageUnit,
                practFromMonth: request.practFromMonth,
                practFromYear: request.practFromYear
            )
            
            // Add to storage
            self.doctors.append(newDoctor)
            self.saveDoctors()
            
            completion(.success(newDoctor))
        }
    }
    
    // MARK: - Fetch All Doctors
    
    /// Fetch all registered doctors
    func fetchDoctors(completion: @escaping (Result<[Doctor], APIError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            completion(.success(self.doctors))
        }
    }
    
    // MARK: - Fetch Single Doctor
    
    /// Fetch a specific doctor by GUID
    func fetchDoctor(guid: String, completion: @escaping (Result<Doctor, APIError>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            if let doctor = self.doctors.first(where: { $0.guid == guid }) {
                completion(.success(doctor))
            } else {
                completion(.failure(.noData))
            }
        }
    }
    
    // MARK: - Clear Data (for testing)
    
    func clearAllDoctors() {
        doctors.removeAll()
        UserDefaults.standard.removeObject(forKey: doctorsKey)
    }
}
