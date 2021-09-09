//
//  PickUpPersonModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/14/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct PickUpPersonApproval: Codable {
    let data: [PickUpList]?
}

// MARK: - Datum
struct PickUpList: Codable {
    let id: Int
    let name, section, datumClass: String
    let instituteID, schoolID, studentID: Int
    let pickupPersonName, relationType, contactNumber, date: String
    let profile: String
    let approvalStatus, fathername, mothername: String

    enum CodingKeys: String, CodingKey {
        case id, name, section
        case datumClass = "class"
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case studentID = "student_id"
        case pickupPersonName = "pickup_person_name"
        case relationType = "relation_type"
        case contactNumber = "contact_number"
        case date, profile
        case approvalStatus = "approval_status"
        case fathername, mothername
    }
}
