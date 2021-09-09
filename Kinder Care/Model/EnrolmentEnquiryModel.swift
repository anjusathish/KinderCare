//
//  EnrolmentEnquiryModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/13/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct EnquiryList: Codable {
    let data: EnquiryListData?
}

// MARK: - DataClass
struct EnquiryListData: Codable {
    let list: [EnrolmentList]?
    let totalCount, acceptedCount, rejectedCount: Int

    enum CodingKeys: String, CodingKey {
        case list
        case totalCount = "total_count"
        case acceptedCount = "accepted_count"
        case rejectedCount = "rejected_count"
    }
}

// MARK: - List
struct EnrolmentList: Codable {
    let id, instituteID, schoolID: Int
    let studentName: String
    let age: Int
    let dob, listClass, fatherName, motherName: String
    let contact, email: String
    let status: Int
    let createdAt, updatedAt,className,purpose: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case studentName = "student_name"
        case age, dob
        case listClass = "class"
        case fatherName = "father_name"
        case motherName = "mother_name"
        case contact, email, purpose, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case className = "class_name"
    }
}
struct EnrolmentExtra: Codable {
    
}
