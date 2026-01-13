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
    
    // No authorization required for this API
    
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
        urlRequest.setValue("X", forHTTPHeaderField: "X-CSRF-Token")  // SAP requires this for POST
        urlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(request)
            urlRequest.httpBody = jsonData
            
            // Debug: Print the JSON payload
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 API Request Payload: \(jsonString)")
            }
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
                    // Debug: Print error response
                    if let data = data, let errorBody = String(data: data, encoding: .utf8) {
                        print("❌ Server Error (\(httpResponse.statusCode)): \(errorBody)")
                    }
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
            
            // Debug: Print raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 API Response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RegistrationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.d))
                }
            } catch {
                print("⚠️ RegistrationResponse decode failed: \(error)")
                // Try to decode as plain Doctor if wrapper fails
                do {
                    let decoder = JSONDecoder()
                    let doctor = try decoder.decode(Doctor.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(doctor))
                    }
                } catch {
                    print("⚠️ Doctor decode failed: \(error)")
                    // Try to decode OData response with "d" wrapper but different structure
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        if let dWrapper = json?["d"] as? [String: Any] {
                            // Create Doctor manually from the dictionary
                            let doctor = Doctor(
                                guid: dWrapper["ID"] as? String ?? UUID().uuidString,
                                name: dWrapper["Name"] as? String ?? "",
                                nameUpper: dWrapper["NameUpper"] as? String ?? "",
                                email: dWrapper["Email"] as? String ?? "",
                                phoneNumber: dWrapper["PhoneNo"] as? String ?? "",
                                whatsappNumber: dWrapper["WhatsappNo"] as? String ?? "",
                                countryCode: dWrapper["CountryCode"] as? String ?? "",
                                gender: dWrapper["Gender"] as? String ?? "",
                                age: dWrapper["Age"] as? String ?? "",
                                ageUnit: dWrapper["AgeUnit"] as? String ?? "",
                                practFromMonth: dWrapper["PractFromMonth"] as? String,
                                practFromYear: dWrapper["PractFromYear"] as? String
                            )
                            DispatchQueue.main.async {
                                completion(.success(doctor))
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(.failure(.decodingError(error)))
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(.decodingError(error)))
                        }
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
        let urlString = baseURL + "?$format=json"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
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
            
            // Debug: Print raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 GET Doctors Response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DoctorsListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.d.results))
                }
            } catch {
                print("⚠️ DoctorsListResponse decode failed: \(error)")
                
                // Try manual decoding for OData structure
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    print("🔍 JSON Structure Keys: \(json?.keys.map { $0 } ?? [])")
                    if let dDict = json?["d"] as? [String: Any] {
                         print("🔍 d Dictionary Keys: \(dDict.keys.map { $0 })")
                    }
                    
                    var results: [[String: Any]]?
                    
                    // Case 1: d -> results -> [...]
                    if let dWrapper = json?["d"] as? [String: Any],
                       let res = dWrapper["results"] as? [[String: Any]] {
                        results = res
                    }
                    // Case 2: d -> [...] (sometimes OData returns array directly in d)
                    else if let dArray = json?["d"] as? [[String: Any]] {
                        results = dArray
                    }
                    
                    if let results = results {
                        print("✅ Found \(results.count) doctors in response")
                        let doctors = results.compactMap { dict -> Doctor? in
                            // Handle inconsistent ID keys
                            let id = (dict["ID"] as? String) ?? 
                                     (dict["Guid"] as? String) ?? 
                                     (dict["id"] as? String) ?? 
                                     UUID().uuidString
                                     
                            return Doctor(
                                guid: id,
                                name: dict["Name"] as? String ?? "",
                                nameUpper: dict["NameUpper"] as? String ?? "",
                                email: dict["Email"] as? String ?? "",
                                phoneNumber: dict["PhoneNo"] as? String ?? "",
                                whatsappNumber: dict["WhatsappNo"] as? String ?? "",
                                countryCode: dict["CountryCode"] as? String ?? "",
                                gender: dict["Gender"] as? String ?? "",
                                age: dict["Age"] as? String ?? "",
                                ageUnit: dict["AgeUnit"] as? String ?? "",
                                practFromMonth: dict["PractFromMonth"] as? String,
                                practFromYear: dict["PractFromYear"] as? String
                            )
                        }
                        
                        DispatchQueue.main.async {
                            completion(.success(doctors))
                        }
                    } else {
                        print("❌ Could not find 'results' array in 'd' wrapper")
                        DispatchQueue.main.async {
                            completion(.failure(.decodingError(error)))
                        }
                    }
                } catch {
                    print("❌ JSONSerialization failed: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(error)))
                    }
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
