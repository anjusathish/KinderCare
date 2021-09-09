//
//  AddActivity.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 21/04/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct AddNapActivityRequest: Codable {
  let type: String
  let class_id: Int
  let section_id: Int
  let start_time: String
  let end_time: String
  let description: String
  let students: [Int]
  let studentName: [String]
  let date:String
  
}


struct AddMedicineActivityRequest: Codable {
  let type: String
  let class_id: Int
  let section_id: Int
  let start_time: String
  let end_time: String
  let description: String
  let students: [Int]
  let studentName: [String]
  let sanitizer:Int
  let temperature:String
    let date:String
}

struct AddIncidentActivityRequest: Codable {
  let type: String
  let class_id: Int
  let section_id: Int
  let start_time: String
  let end_time: String
  let description: String
  let students: [Int]
  let attachments: [URL]
  let studentName: [String]
    let date:String
}

struct AddClassRoomActivityRequest: Codable {
  let type: String
  let class_id: Int
  let section_id: Int
  let start_time: String
  let end_time: String
  let description: String
  let students: [Int]
  let attachments: [URL]
  let classroom_category_id: String
  let classroom_milestone_id:String
  let title: String
  let classroomCategoryName: String
  let classroomMilestoneName: String
  let studentName: [String]
  let date:String
}

struct AddBathRoomActivityRequest: Codable {
  let type: String
  let class_id: Int
  let section_id: Int
  let start_time: String
  let end_time: String
  let description: String
  let bathroomTypeID: Int
  let disperChange: Int
  let students: [Int]
  let studentName: [String]
    let date:String
}

struct AddMealActivityRequest: Codable {
  let type: String
  let class_id: Int
  let section_id: Int
  let start_time: String
  let end_time: String
  let description: String
  let students: [Int]
  let studentName: [String]
  let meals: [String]
  let date:String
}

struct UpdateDailyActivityRequest: Codable {
  let state: String
  let type: String
  let class_id: Int
  let section_id: Int
  let start_time: String
  let end_time: String
  let description: String
  let students: [Int]
  let studentName: [String]
  let bathroom_type_id: Int
  let diaper_change: Int 
  let classroom_category_id: String
  let classroom_milestone_id:Int
  let title: String
  let attachments: [URL]
  let date:String
}

//MARK:- ClassRoomCategoryListResponse

struct ClassRoomCategoryListResponse: Codable {
  
  let data: [CategoryListDatum]?
}

// MARK: - Datum
struct CategoryListDatum: Codable {
    let id: Int?
    let name: String
}
