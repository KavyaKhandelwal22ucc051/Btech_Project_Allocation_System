//
//  User.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 22/09/25.
//

import Foundation

struct User : Codable {
    let id : String
    let name : String
    let email : String
    let phoneNumber : String
    let role : String
    let createdAt: String
    let currProjects: Int
    let totalProjects: Int
    let branch: String
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
            case email
            case phoneNumber
            case role
            case createdAt
            case currProjects
            case totalProjects 
            case branch
        }
    
}

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

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
    let phoneNumber: String
    let role: String
    let branch: String
}

struct RegisterResponse: Codable {
    let success: Bool      // Did registration work?
    let message: String    // What happened?
    let user: User?        // User data (if successful)
    let token: String?     // Auth token (if successful)
}
