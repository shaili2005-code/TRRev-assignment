//
//  APIService.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import Foundation

/// Singleton service for handling all API communications
final class APIService {
    
    // MARK: - Singleton
    
    static let shared = APIService()
    
    private init() {}
    
    // MARK: - Constants
    
    private let baseURL = "http://199.192.26.248:8000/sap/opu/odata/sap/ZCDS_C_TEST_REGISTER_NEW_CDS/ZCDS_C_TEST_REGISTER_NEW"
    
    // Basic Auth credentials for SAP OData service
    private let username = "FIORI_DEV"
    private let password = "Init.12345"
    
    // MARK: - Helper Methods
    
    /// Creates Basic Auth header value
    private func createAuthHeader() -> String {
        let credentials = "\(username):\(password)"
        let credentialsData = credentials.data(using: .utf8)!
        return "Basic \(credentialsData.base64EncodedString())"
    }
    
    // MARK: - Registration
    
    /// Register a new doctor
    /// - Parameters:
    ///   - request: Registration request with doctor details
    ///   - completion: Completion handler with Result containing Doctor or APIError
    func registerDoctor(request: RegistrationRequest, completion: @escaping (Result<Doctor, APIError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(createAuthHeader(), forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            urlRequest.httpBody = try encoder.encode(request)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(.decodingError(error)))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(.serverError(httpResponse.statusCode)))
                    }
                    return
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RegistrationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.d))
                }
            } catch {
                // Try to decode as plain Doctor if wrapper fails
                do {
                    let decoder = JSONDecoder()
                    let doctor = try decoder.decode(Doctor.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(doctor))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Fetch All Doctors
    
    /// Fetch all registered doctors
    /// - Parameter completion: Completion handler with Result containing array of Doctors or APIError
    func fetchDoctors(completion: @escaping (Result<[Doctor], APIError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(createAuthHeader(), forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(.serverError(httpResponse.statusCode)))
                    }
                    return
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DoctorsListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.d.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Fetch Single Doctor
    
    /// Fetch a specific doctor by GUID
    /// - Parameters:
    ///   - guid: The unique identifier of the doctor
    ///   - completion: Completion handler with Result containing Doctor or APIError
    func fetchDoctor(guid: String, completion: @escaping (Result<Doctor, APIError>) -> Void) {
        let urlString = "\(baseURL)(guid'\(guid)')"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(createAuthHeader(), forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(.serverError(httpResponse.statusCode)))
                    }
                    return
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SingleDoctorResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.d))
                }
            } catch {
                // Try to decode as plain Doctor if wrapper fails
                do {
                    let decoder = JSONDecoder()
                    let doctor = try decoder.decode(Doctor.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(doctor))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
        }
        
        task.resume()
    }
}
