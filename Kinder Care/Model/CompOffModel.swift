//
//  CompOffModel.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 18/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import Foundation

// MARK: - CompOffApplicationListResponse
struct CompOffApplicationListResponse: Codable {
    let data: [CompOffListDatum]?
}

// MARK: - Datum
struct CompOffListDatum: Codable {
    let id, instituteID, schoolID, userID: Int?
    let userType: Int?
    let applyDate: String
    let status, approvedBy: Int?
    let contact, reason: String?
    let usedStatus: Int?
    let createdAt, updatedAt: String?

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
    }
}



// MARK: - CompOffApplicationListResponse
struct AddCompOffResponse: Codable {
  let status: String?
}
