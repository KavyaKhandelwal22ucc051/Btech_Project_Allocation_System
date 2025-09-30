//
//  ApplicationViewModel.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 25/09/25.
//

import Foundation
import SwiftUI

// MARK: - Application Model
struct Application: Codable, Identifiable , Hashable  {
    let id: String
    let name: String
    let email: String
    let coverLetter: String
    let phone: Int
    let address: String
    let applicantID: ApplicantID
    let facultyID: FacultyID
    let projectId: String
    let branch: String
    let cgpa: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, coverLetter, phone, address
        case applicantID, facultyID, projectId, branch, cgpa
    }
}






struct ApplicantID: Codable , Hashable {
    let user: String
    let role: String
}

struct FacultyID: Codable  , Hashable{
    let user: String
    let role: String
}

// MARK: - API Response Models
struct ApplicationResponse: Codable {
    let success: Bool
    let message: String
    let application: Application?
}

struct MyApplicationsResponse : Codable {
    let success: Bool
    let applications : [Application] 
}

struct ApplicationsResponse: Codable {
    let success: Bool
    let applications: [Application]
}

// MARK: - Application ViewModel
@MainActor
class ApplicationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var coverLetter = ""
    @Published var phone = ""
    @Published var address = ""
    @Published var cgpa = ""
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var successMessage = ""
    @Published var isSubmitted = false
    @Published var myApplications : [Application] = []
    @Published var getAllApplications: [Application] = []
    
    
    // Validation properties
    var isNameValid: Bool {
        name.count >= 3 && name.count <= 30
    }
    
    var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var isCoverLetterValid: Bool {
        !coverLetter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isPhoneValid: Bool {
        phone.count >= 10 && Int(phone) != nil
    }
    
    var isAddressValid: Bool {
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isCGPAValid: Bool {
        if let cgpaValue = Double(cgpa) {
            return cgpaValue >= 4.0 && cgpaValue <= 10.0
        }
        return false
    }
    
    var isFormValid: Bool {
        isNameValid && isEmailValid && isCoverLetterValid &&
        isPhoneValid && isAddressValid && isCGPAValid
    }
    
    // MARK: - GET all applications
    
    
    func fetchAllApplications() async {
        errorMessage =  ""
        
        do{
            guard let url = URL(string:  "http://localhost:4000/api/v1/application/getAll")else{
                errorMessage = "Invalid URL"
                print(errorMessage)
                return
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaults.standard.string(forKey: "auth_token"){
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data,response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else{
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("error in status code")
                return
            }
            
            let allApplications = try JSONDecoder().decode(ApplicationsResponse.self, from: data)
            
            self.getAllApplications = allApplications.applications
            
        }catch{
            print("errot in try")
        }
    }
    
    
    
    
    // MARK: - Submit Applications
    func submitApplication(for project: Project) async {
        guard isFormValid else {
            errorMessage = "Please fill all fields correctly"
            return
        }
        
        guard let phoneInt = Int(phone) else {
            errorMessage = "Invalid phone number"
            return
        }
        
        guard let cgpaDouble = Double(cgpa) else {
            errorMessage = "Invalid CGPA value"
            return
        }
        
        isLoading = true
        errorMessage = ""
        successMessage = ""
        
        do {
            guard let url = URL(string: "http://localhost:4000/api/v1/application/post") else {
                throw ApplicationError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Add authentication token
            if let token = UserDefaults.standard.string(forKey: "auth_token") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            // Create JSON payload with proper data types
            let payload: [String: Any] = [
                "name": name,
                "email": email,
                "coverLetter": coverLetter,
                "phone": phoneInt,
                "address": address,
                "projectId": project.id,
                "cgpa": cgpaDouble
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug: Print response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Application response: \(responseString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApplicationError.invalidResponse
            }
            
            if httpResponse.statusCode == 200 {
                let applicationResponse = try JSONDecoder().decode(ApplicationResponse.self, from: data)
                
                if applicationResponse.success {
                    successMessage = applicationResponse.message
                    isSubmitted = true
                    clearForm()
                } else {
                    errorMessage = applicationResponse.message
                }
            } else {
                // Handle error response
                if let errorResponse = try? JSONDecoder().decode(ApplicationResponse.self, from: data) {
                    errorMessage = errorResponse.message
                } else {
                    errorMessage = "Server returned status code: \(httpResponse.statusCode)"
                }
            }
            
        } catch let decodingError as DecodingError {
            handleDecodingError(decodingError)
        } catch {
            if let appError = error as? ApplicationError {
                errorMessage = appError.localizedDescription
            } else {
                errorMessage = "Failed to submit application: \(error.localizedDescription)"
            }
            print("Application submission error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - my application
    
    func getMyApplications() async {
        errorMessage = ""
        
        do{
            guard let url = URL(string: "http://localhost:4000/api/v1/application/myapplications") else{
                errorMessage = "Invalid url"
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaults.standard.string(forKey: "auth_token"){
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data,response) = try await URLSession.shared.data(for: request)
            
            guard let httpresponse = response as? HTTPURLResponse else{
                print("error in response")
                return
            }
            
            guard 200...299 ~= httpresponse.statusCode else {
                print("error in status code")
                return
            }
               
            let myApplication = try JSONDecoder().decode(MyApplicationsResponse.self, from: data)
                
                
            self.myApplications = myApplication.applications
           
            
        }catch{
            print("error in try")
        }
    }
    
    private func handleDecodingError(_ error: DecodingError) {
        switch error {
        case .keyNotFound(let key, let context):
            errorMessage = "Missing key: \(key.stringValue). Context: \(context.debugDescription)"
        case .typeMismatch(let type, let context):
            errorMessage = "Type mismatch for type: \(type). Context: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            errorMessage = "Value not found for type: \(type). Context: \(context.debugDescription)"
        case .dataCorrupted(let context):
            errorMessage = "Data corrupted. Context: \(context.debugDescription)"
        @unknown default:
            errorMessage = "Unknown decoding error: \(error.localizedDescription)"
        }
        print("Decoding error: \(error)")
    }
    
    func clearForm() {
        name = ""
        email = ""
        coverLetter = ""
        phone = ""
        address = ""
        cgpa = ""
        errorMessage = ""
        successMessage = ""
    }
}

// MARK: - Application Errors
enum ApplicationError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid server URL"
        case .invalidResponse:
            return "Invalid server response"
        case .serverError(let message):
            return message
        }
    }
}
