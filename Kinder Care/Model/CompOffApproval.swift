//
//  CompOffApproval.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 22/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import Foundation

// MARK: - CompOffApporvalListResponse
struct CompOffApporvalListResponse: Codable {
    let data: [CompOffApporvalDatum]?
}

// MARK: - Datum
struct CompOffApporvalDatum: Codable {
    let id, instituteID, schoolID, userID: Int?
    let userType: Int?
    let applyDate: String?
    let status, approvedBy: Int?
    let contact, reason: String?
    let usedStatus: Int?
    let createdAt, updatedAt: String?
    let profileurl: String?
    let name: String?
    let getUser: CompOffGetUser?

    enum CodingKeys: String, CodingKey {
        case id
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case userID = "user_id"
        case userType = "user_type"
        case applyDate = "apply_date"
        case status
        case approvedBy = "approved_by"
        case contact, reason
        case usedStatus = "used_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case profileurl, name
        case getUser = "get_user"
    }
}

// MARK: - GetUser
struct CompOffGetUser: Codable {
    let id, userRowID, instituteID, schoolID: Int?
    let parentID: Int?
    let firstname: String?
    let lastname: String?
    let email, contact, dateOfBirth: String?
    let gender: Int?
    let address, profile: String?
    let usertypeID, status: Int?
    let verificationToken: String?
    let verified: Int?
    let resetKey, createdAt, updatedAt: String?
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
