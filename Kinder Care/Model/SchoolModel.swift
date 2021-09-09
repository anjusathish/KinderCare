//
//  SchoolModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/7/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct SchoolList: Codable {
    let data: [SchoolListData]?
}

// MARK: - Datum
struct SchoolListData: Codable {
    let id, instituteID: Int
    let schoolName, email, contact, location: String
    let address, logoImage: String
    let status: Int
    // let deletedAt: JSONNull?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case instituteID = "institute_id"
        case schoolName = "school_name"
        case email, contact, location, address
        case logoImage = "logo_image"
        case status
        //case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DashboardCountResponse: Codable {
    let data: [DashboardCount]?
}

// MARK: - Datum
struct DashboardCount: Codable {
    let teacher, supportStaff,school,  adminsCount: Int?
    let schools: Int?
    let student : Int?
    
    enum CodingKeys: String, CodingKey {
        case teacher = "teacher"
        case supportStaff = "support_staff"
        case student
        case adminsCount = "admins_count"
        case schools
        case school
    }
}



// MARK: - AdminDashboardResponse
struct AdminDashboardResponse: Codable {
    let data: [AdminDashboardData]?
}

// MARK: - Datum
struct AdminDashboardData: Codable {
    
    let totalClassRoomCount, totalStudentCount, totalSuportStaffCount, totalStaffCount: Int
    let studentPresentCount, studentAbsentCount, teacherPresentCount, teacherAbsentCount: Int
    let studentBirthday, teachersBirthday: [String]?
    
    enum CodingKeys: String, CodingKey {
        case totalClassRoomCount = "total_class_room_count"
        case totalStudentCount = "total_student_count"
        case totalSuportStaffCount = "total_suport_staff_count"
        case totalStaffCount = "total_staff_count"
        case studentPresentCount = "student_present_count"
        case studentAbsentCount = "student_absent_count"
        case teacherPresentCount = "teacher_present_count"
        case teacherAbsentCount = "teacher_absent_count"
        case studentBirthday = "student_birthday"
        case teachersBirthday = "teachers_birthday"
    }
}

// MARK: - TeacherDashboardResponse
struct TeacherDashboardResponse: Codable {
    let data: [TeacherDashboardData]?
}

// MARK: - Datum
struct TeacherDashboardData: Codable {
    let noOfClassrooms, noOfStudents, noOfWorkingDays, noOfLeaveDays: Int?

    enum CodingKeys: String, CodingKey {
        case noOfClassrooms = "no_of_classrooms"
        case noOfStudents = "no_of_students"
        case noOfWorkingDays = "no_of_working_days"
        case noOfLeaveDays = "no_of_leave_days"
    }
}

struct ChildNameList: Codable {
    let data: [ChildName]?
}


struct ChildName: Codable {
    let id: Int
    let name, className, section: String
    let profile: String
    let schoolID: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case className = "class"
        case section, profile
        case schoolID = "school_id"
    }
}



struct ParentDashboardActivity: Codable {
    let currentPage: Int
    let data: [DashboardActivity]?
    let firstPageURL: String
    let from, lastPage: Int
    let lastPageURL, nextPageURL: String
    let perPage: Int
    let prevPageURL: String
    let to, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct DashboardActivity: Codable {
    let id: Int
    let type: String
    let classID, sectionID: Int
    let date, startTime, endTime,classroomCategoryID: String?
    let title: String?
    let datumDescription: String
    let  bathroomTypeID, diaperChange: Int?
    let state: Int
    let createdAt, className, classSection: String
    let  classroomMilestoneName, bathroomTypeName,classroomMilestoneID: String?
    let classroomCategoryName:String?
    let attachments: [Attachment]?
    let meals :[mealsData]?
    let temperature, sanitizer: Int

    enum CodingKeys: String, CodingKey {
        case id, type
        case classID = "class_id"
        case sectionID = "section_id"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case title
        case datumDescription = "description"
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
        case attachments, meals, temperature, sanitizer
    }
}
//struct attachmentsData:Codable {
//    let activity_id:Int?
//    let mimetype:String?
//    let file:String?
//    let description:String?
//    
//}
struct mealsData:Codable {
    let course_type_name: String?
    let food_name: String?
    let description:String?
    let start_time,end_time:String?
}
