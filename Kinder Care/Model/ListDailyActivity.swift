//
//  ListDailyActivity.swift
//  Kinder Care
//
//  Created by CIPL0419 on 09/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

//MARK:- ListDailyActivityRequest

struct ListDailyActivityRequest {
    let page: Int
}

// MARK: - ListDailyActivityResponse
struct ListDailyActivityResponse: Codable {
    let data: ListDailyActivityDataClass?
  //let data: [DailyActivity]?
}

// MARK: - DataClass
struct ListDailyActivityDataClass: Codable {
    let currentPage: Int?
    let data: [DailyActivity]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL, nextPageURL, path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - ListDailyActivityData
struct DailyActivity: Codable {
    let id: Int
    let type: String
    let className: String
    let classSection: String
    let state: Int?
    let createdAt: String
    let classID, sectionID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case className = "class_name"
        case classSection = "class_section"
        case state
        case createdAt = "created_at"
        case classID = "class_id"
        case sectionID = "section_id"
    }
}


// MARK: - ViewDailyActivityResponse
struct EditPhotoActivityEmptyResponse: Codable {
    
}

struct AddDailyAtivityPhotoResponse:Codable{
  
}

// MARK: - ViewDailyActivityResponse
struct ViewDailyActivityResponse: Codable {
    let data: DailyActivityDetail
}

// MARK: - DataClass
struct DailyActivityDetail: Codable {
    let id: Int
    let type: String
    let classID, sectionID: Int
    let date, startTime, endTime: String?
    let title: String?
    let dataDescription: String
    let   bathroomTypeID, diaperChange: Int?
    let state: Int
    let createdAt, className, classSection: String
    let  classroomMilestoneName, bathroomTypeName,classroomMilestoneID: String?
    let students: [Student]?
    let classroomCategoryName,classroomCategoryID:String?
    var attachments: [Attachment]?
    let meals: [Meal]?

    enum CodingKeys: String, CodingKey {
        case id, type
        case classID = "class_id"
        case sectionID = "section_id"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case title
        case dataDescription = "description"
        case classroomCategoryID = "classroom_category_id"
        case classroomMilestoneID = "classroom_milestone_id"
        case bathroomTypeID = "bathroom_type_id"
        case diaperChange = "diaper_change"
        case state
        case createdAt = "created_at"
        case className = "class_name"
        case classSection = "class_section"
        case classroomCategoryName = "classroom_category_name"
        case classroomMilestoneName = "classroom_milestone_name"
        case bathroomTypeName = "bathroom_type_name"
        case students, attachments
        case meals
    }
}

//// MARK: - Student
//struct StudentObj: Codable {
//    let activityID, studentID: Int
//    let studentName: String
//
//    enum CodingKeys: String, CodingKey {
//        case activityID = "activity_id"
//        case studentID = "student_id"
//        case studentName = "student_name"
//    }
//}
// MARK: - Attachment
struct Attachment: Codable {
    let activityID: Int?
    let mimetype: String?
    let file, thumb: String?
    let profile:String?
    let attachment: [String]?
     let description:String?
    let emptyURL:URL?

    enum CodingKeys: String, CodingKey {
        case activityID = "activity_id"
        case mimetype, file, thumb,profile,attachment,description,emptyURL
    }
}
//struct attachmentsData:Codable {
//    let activity_id:Int?
//    let mimetype:String?
//    let file:String?
//    let description:String?
//
//}
// MARK: - Meal
struct Meal: Codable {
    let activityID, presetFoodID: Int
    let foodName: String
    let courseType: Int
    let courseTypeName: String

    enum CodingKeys: String, CodingKey {
        case activityID = "activity_id"
        case presetFoodID = "preset_food_id"
        case foodName = "food_name"
        case courseType = "course_type"
        case courseTypeName = "course_type_name"
    }
}
