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
