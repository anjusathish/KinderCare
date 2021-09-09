//
//  ProfileModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 06/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

// MARK: - ProfileModel

struct EmptyResponse: Codable {

}
//Profile Model
struct ProfileResponse: Codable {
    let status: String
    let data: ProfileData?
}

// MARK: - DataClass
struct ProfileData: Codable {
    let id, userRowID, instituteID, schoolID: Int?
    let parentID: Int?
    let firstname, lastname, email, contact: String?
    let dateOfBirth: String?
    let gender: Int?
    let address: String?
    let profile: String?
    let usertypeID, status: Int?
    let verificationToken: String?
    let verified: Int?
    let resetKey: String?
    let createdAt, updatedAt: String?
    let deletedAt, deletedBy: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userRowID = "user_row_id"
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case parentID = "parent_id"
        case firstname, lastname, email, contact
        case dateOfBirth = "date_of_birth"
        case gender, address, profile
        case usertypeID = "usertype_id"
        case status
     
        case verificationToken = "verification_token"
        case verified
        case resetKey = "reset_key"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case deletedBy = "deleted_by"
    }
}
struct ListHelathStatus: Codable {
    let data: [ListHelath]?
}


struct ListHelath: Codable {
    let id, userID, userType, instituteID: Int
    let schoolID: Int
    let temp: Double
    let santizer: Int
    let date, time, createdAt: String
   

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case userType = "user_type"
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case temp, santizer, date, time
        case createdAt = "created_at"
        
    }
}
struct ViewHelathStatus: Codable {
    let data: [viewHealth]?
}

// MARK: - Datum
struct viewHealth: Codable {
    let id, userID, userType, instituteID: Int
    let schoolID: Int
    let temp: Double
    let santizer: Int
    let date, time, createdAt: String
  

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case userType = "user_type"
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case temp, santizer, date, time
        case createdAt = "created_at"
        
      
    }
}
