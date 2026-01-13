//
//  MockAPIService.swift
//  DoctorRegistrationApp
//
//  Mock API Service (kept for testing, but real API is used)
//

import Foundation

/// Mock API Service - NOT USED, real APIService is used instead
final class MockAPIService {
    
    static let shared = MockAPIService()
    private init() {}
    
    // Placeholder to satisfy any references
    func registerDoctor(request: RegistrationRequest, completion: @escaping (Result<Doctor, APIError>) -> Void) {
        // Not used - real API is used
        completion(.failure(.unknownError))
    }
    
    func fetchDoctors(completion: @escaping (Result<[Doctor], APIError>) -> Void) {
        completion(.success([]))
    }
    
    func fetchDoctor(guid: String, completion: @escaping (Result<Doctor, APIError>) -> Void) {
        completion(.failure(.noData))
    }
}
