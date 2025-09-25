//
//  LoginViewModel.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 05/09/25.
//

import Foundation
import Combine

struct LoginRequest: Codable {
    let email : String
    let password : String
    let role : String
}

struct LoginResponse : Codable {
    let success : Bool
    let user : User?
    let message : String
    let token : String?
}

@MainActor
class LoginViewModel : ObservableObject {
    
    @Published var email : String = ""
    @Published var role : String = ""
    @Published var password : String = ""
    @Published var errorMessage =  ""
    @Published var isLoggedIn = false
    @Published var user : User?
    
    let roles = ["student","faculty"]
    
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
    
    func logout() {
        self.isLoggedIn = false
        self.errorMessage = ""
        self.email = ""
        self.password = ""
        self.role = "student"
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

