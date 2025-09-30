//
//  LoginViewModel.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 05/09/25.
//

import Foundation
import Combine



@MainActor
class LoginViewModel : ObservableObject {
    
    @Published var email : String = ""
    @Published var role : String = ""
    @Published var password : String = ""
    @Published var errorMessage =  ""
    @Published var isLoggedIn = false
    @Published var user : User?
    
    // Additional Registration Fields
        @Published var name: String = ""
        @Published var phoneNumber: String = ""
        @Published var branch: String = ""
        @Published var confirmPassword: String = ""
        
        // Registration Success State
        @Published var isRegistrationSuccessful: Bool = false
        @Published var registrationMessage: String = ""
    
    let roles = ["student","faculty"]
    
    let availableBranches = [
        "Computer Science and Engineering",
        "Electronics and Communication Engineering",
        "Electrical Engineering",
        "Mechanical Engineering",
        "Civil Engineering",
        "Chemical Engineering"
    ]
    
    func loginFuntion() async{
        
        guard !email.isEmpty else{
            errorMessage = "Please eneter the email";
            return
        }
        
        guard !password.isEmpty else {
             errorMessage = "Please enter your password"
             return
        }
               
        guard !role.isEmpty else {
             errorMessage = "Please select your role"
             return
        }
        
        errorMessage = ""
        
        do{
            
            guard let url = URL(string: "http://localhost:4000/api/v1/user/login") else{
                print("Url error")
                return
            }
            
            var request = URLRequest(url:url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let loginData = LoginRequest(email: email, password: password, role: role)
            print("error encode")
            request.httpBody = try JSONEncoder().encode(loginData)
            print("error url")
            let (data,response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else{
                print("http error")
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else{
                print("status code error")
                return
            }
            
            print("error decode")
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("error decode")
            
            if loginResponse.success {
                self.isLoggedIn = true
                self.user = loginResponse.user
                self.errorMessage = ""
                
                if let token = loginResponse.token {
                    UserDefaults.standard.set(token, forKey: "auth_token")
                }
                
                print("Login Succesfull")
                
            }else{
                print(loginResponse.message)
                self.errorMessage = loginResponse.message
            }
            
            
        }catch{
            if let loginError = error as? LoginError {
                    self.errorMessage = loginError.localizedDescription
            } else {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
        }
        
    }
    
    func register() async {
            // Validate all registration fields
            guard !name.isEmpty else {
                errorMessage = "Please enter your name"
                return
            }
            
            guard !email.isEmpty else {
                errorMessage = "Please enter your email"
                return
            }
            
            guard !password.isEmpty else {
                errorMessage = "Please enter your password"
                return
            }
            
            guard !phoneNumber.isEmpty else {
                errorMessage = "Please enter your phone number"
                return
            }
            
            guard !role.isEmpty else {
                errorMessage = "Please select your role"
                return
            }
            
            guard !branch.isEmpty else {
                errorMessage = "Please select your branch"
                return
            }
            
            // Validate password confirmation
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match"
                return
            }
            
            // Validate email format (basic validation)
            
            
           
            errorMessage = ""
            
            do {
                // Create request
                guard let url = URL(string: "http://localhost:4000/api/v1/user/register") else {
                    throw LoginError.invalidURL
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let registerData = RegisterRequest(
                    name: name,
                    email: email.lowercased(),
                    password: password,
                    phoneNumber: phoneNumber,
                    role: role.lowercased(),
                    branch: branch
                )
                
                request.httpBody = try JSONEncoder().encode(registerData)
                
                // Make API call
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Debug: Print raw response
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw register response: \(responseString)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw LoginError.invalidResponse
                }
                
                // Check for HTTP errors
                guard 200...299 ~= httpResponse.statusCode else {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        throw LoginError.serverError(errorResponse.message)
                    } else {
                        throw LoginError.serverError("Registration failed with status code: \(httpResponse.statusCode)")
                    }
                }
                
                // Decode success response
                let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                
                if registerResponse.success {
                    // Registration successful
                    self.isRegistrationSuccessful = true
                    self.registrationMessage = registerResponse.message
                    self.errorMessage = ""
                    
                    // Store token if provided
                    if let token = registerResponse.token {
                        UserDefaults.standard.set(token, forKey: "auth_token")
                    }
                    
                    // Set user data if provided
                    if let user = registerResponse.user {
                        self.user = user
                        self.isLoggedIn = true
                    }
                    
                    print("Registration successful: \(registerResponse.message)")
                    
                    // Clear form data after successful registration
                    clearRegistrationForm()
                    
                } else {
                    self.errorMessage = registerResponse.message
                }
                
            } catch let decodingError as DecodingError {
                // Specific decoding error handling
                switch decodingError {
                case .keyNotFound(let key, let context):
                    self.errorMessage = "Registration failed: Missing key \(key.stringValue)"
                case .typeMismatch(_, let context):
                    self.errorMessage = "Registration failed: Invalid data format"
                case .valueNotFound(_, let context):
                    self.errorMessage = "Registration failed: Missing required data"
                case .dataCorrupted(let context):
                    self.errorMessage = "Registration failed: Data corrupted"
                @unknown default:
                    self.errorMessage = "Registration failed: Unknown error"
                }
                print("Registration decoding error: \(decodingError)")
                
            } catch {
                if let loginError = error as? LoginError {
                    self.errorMessage = loginError.localizedDescription
                } else {
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
                print("Registration error: \(error)")
            }
            
           
        }
    
    func clearRegistrationForm() {
            name = ""
            email = ""
            password = ""
            phoneNumber = ""
            branch = ""
            confirmPassword = ""
            role = ""
        }
    
    func logout() {
        self.isLoggedIn = false
        self.errorMessage = ""
        self.email = ""
        self.password = ""
        self.role = ""
        self.user = nil
        
        UserDefaults.standard.removeObject(forKey: "auth_token")
    }
    
    
    
    func clearError() {
            errorMessage = ""
        }
    
}

enum LoginError: LocalizedError {
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

