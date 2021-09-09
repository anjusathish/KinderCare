//
//  Student.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 28/04/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

// MARK: - StudentListResponse
struct StudentListResponse: Codable {
  let data: [Student]
}

// MARK: - Datum
struct Student: Codable {
  let id: Int
  let instituteID, schoolID: Int?
  let rollNo,fatherName, motherName: String?
  let datumClass, section, contact: String?
  let activityID: Int?
  let studentName:String
  
  enum CodingKeys: String, CodingKey {
    case id = "student_id"
    case instituteID = "institute_id"
    case schoolID = "school_id"
    case rollNo = "roll_no"
    case studentName = "student_name"
    case fatherName = "father_name"
    case motherName = "mother_name"
    case datumClass = "class"
    case section, contact
    case activityID = "activity_id"
  }
}

struct TeacherList: Codable {
  let data: [TeacherListData]
}

// MARK: - Datum
struct TeacherListData: Codable {
  let id, userRowID, instituteID, schoolID: Int
  let parentID: Int
  let firstname: String
  let email, contact, dateOfBirth: String
  let gender: Int
  let address: String
  let usertypeID, status: Int
  
  
  
  
  enum CodingKeys: String, CodingKey {
    case id
    case userRowID = "user_row_id"
    case instituteID = "institute_id"
    case schoolID = "school_id"
    case parentID = "parent_id"
    case firstname, email, contact
    case dateOfBirth = "date_of_birth"
    case gender, address
    case usertypeID = "usertype_id"
    case status
    
    
    
  }
}
