//
//  DashboardViewModel.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import Foundation

/// ViewModel for the Dashboard screen
final class DashboardViewModel {
    
    // MARK: - Properties
    
    private(set) var doctor: Doctor?
    var doctorGuid: String?
    
    /// Doctor's name for display
    var doctorName: String {
        return doctor?.name ?? "Doctor"
    }
    
    /// Greeting message
    var greetingMessage: String {
        return "Hello, \(doctorName)!"
    }
    
    /// Doctor's email
    var email: String {
        return doctor?.email ?? ""
    }
    
    /// Doctor's phone number
    var phoneNumber: String {
        return doctor?.phoneNumber ?? ""
    }
    
    /// Doctor's gender
    var gender: String {
        return doctor?.gender ?? ""
    }
    
    // MARK: - Methods
    
    /// Fetches doctor details from the API using real APIService
    /// - Parameter completion: Completion handler with optional error
    func fetchDoctorDetails(completion: @escaping (Error?) -> Void) {
        guard let guid = doctorGuid else {
            completion(APIError.invalidURL)
            return
        }
        
        // Using REAL API
        APIService.shared.fetchDoctor(guid: guid) { [weak self] result in
            switch result {
            case .success(let doctor):
                self?.doctor = doctor
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    /// Sets doctor directly (used when passing from list)
    /// - Parameter doctor: Doctor object
    func setDoctor(_ doctor: Doctor) {
        self.doctor = doctor
        self.doctorGuid = doctor.guid
    }
}
