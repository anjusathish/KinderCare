//
//  AttendanceListModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/7/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct AttendanceResponse: Codable {
    let status: String?
    let data: [Attendance]?
}

// MARK: - Datum
struct Attendance: Codable {
    
    let userID: Int
    let name: String
    var profile: String
    let signInTime, signOutTime: String
    let status: Int
    let date: String
    let schoolID: Int?
    let datumClass, section: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, profile
        case signInTime = "sign_in_time"
        case signOutTime = "sign_out_time"
        case status, date
        case schoolID = "school_id"
        case datumClass = "class"
        case section
    }
}

struct ClassResponse: Codable {
    let data: [ClassModel]?
}

// MARK: - Datum

struct ClassModel: Codable {
    let id: Int?
    let className: String
    let status: Int
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case className = "class_name"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct SectionResponse: Codable {
    let data: [Section]?
}

// MARK: - Datum
struct Section: Codable {
    let id, instituteID: Int?
    let noOfStudents: Int?
    let section,schoolName,schoolID, classID: String?
    let status: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "section_id"
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case classID = "class_id"
        case noOfStudents = "no_of_students"
        case section, status
        case schoolName = "school_name"
        
    }
}





