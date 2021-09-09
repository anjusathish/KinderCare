//
//  WeeklyMenuModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 3/11/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

// MARK: - ListWeeklyMenuResponse
struct ListWeeklyMenuResponse: Codable {
  let data: [DatumDish]
}

// MARK: - Datum
struct DatumDish: Codable {
  
  let id, instituteID, schoolID: Int
  let date, datumClass: String
  let status: Int
  let createdAt, updatedAt: String
  let deletedAt: String?
  let dishes: [Dish]
  let weeklyMenuItems: [WeeklyMenuItem]
  
  enum CodingKeys: String, CodingKey {
    case id
    case instituteID = "institute_id"
    case schoolID = "school_id"
    case date
    case datumClass = "class"
    case status
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case deletedAt = "deleted_at"
    case dishes
    case weeklyMenuItems = "weekly_menu_items"
  }
}

// MARK: - Dish
struct Dish: Codable {
  let courseType: String
  let items: [String]
  
  enum CodingKeys: String, CodingKey {
    case courseType = "course_type"
    case items
  }
}

// MARK: - WeeklyMenuItem
struct WeeklyMenuItem: Codable {
    let id, weeklyMenuID, courseType, items: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case weeklyMenuID = "weekly_menu_id"
        case courseType = "course_type"
        case items = "items"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CourseTypeResponce: Codable {
  let data: [CourseType]?
}


struct  CourseType: Codable {
  let id: Int
  let name: String
  let status: Int
  
  enum CodingKeys: String, CodingKey {
    case id, name, status
    
  }
}

// MARK: - MenuItemsResponse
struct MenuItemsResponse: Codable {
  let data: [MenuItem]
}

// MARK: - Datum
struct MenuItem: Codable {
  let id, instituteID, schoolID, courseType: Int
  let foodDetails: String
  let status: Int
  let createdAt, updatedAt: String
  let deletedAt: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case instituteID = "institute_id"
    case schoolID = "school_id"
    case courseType = "course_type"
    case foodDetails = "food_details"
    case status
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case deletedAt = "deleted_at"
  }
}
