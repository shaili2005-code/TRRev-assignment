//
//  DoctorsListViewModel.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import Foundation

/// ViewModel for the Doctors List screen
final class DoctorsListViewModel {
    
    // MARK: - Properties
    
    private(set) var doctors: [Doctor] = []
    
    /// Number of doctors in the list
    var numberOfDoctors: Int {
        return doctors.count
    }
    
    /// Whether the list is empty
    var isEmpty: Bool {
        return doctors.isEmpty
    }
    
    // MARK: - Methods
    
    /// Fetches all doctors from the Mock API
    /// - Parameter completion: Completion handler with optional error
    func fetchDoctors(completion: @escaping (Error?) -> Void) {
        MockAPIService.shared.fetchDoctors { [weak self] result in
            switch result {
            case .success(let doctors):
                self?.doctors = doctors
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    /// Gets a doctor at a specific index
    /// - Parameter index: Index of the doctor
    /// - Returns: Doctor at the index, or nil if out of bounds
    func doctor(at index: Int) -> Doctor? {
        guard index >= 0 && index < doctors.count else {
            return nil
        }
        return doctors[index]
    }
    
    /// Gets the GUID for a doctor at a specific index
    /// - Parameter index: Index of the doctor
    /// - Returns: GUID string, or nil if out of bounds
    func doctorGuid(at index: Int) -> String? {
        return doctor(at: index)?.guid
    }
}
