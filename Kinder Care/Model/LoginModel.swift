//
//  LoginModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 04/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//
//..
import Foundation

struct UserDetails: Codable {
    let userID: Int?
    let token, tokenType: String?
    let userType: Int
    let userTypeName, expiresAt,name: String?
    let instituteID: Int?
    let instituteName:String?
    var school_id: Int?
    var profile: String
    var permissions: PermissionsData?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token
        case name
        case tokenType = "token_type"
        case userType = "user_type"
        case userTypeName = "user_type_name"
        case expiresAt = "expires_at"
        case instituteID = "institute_id"
        case profile,permissions
        case school_id = "school_id"
        case instituteName = "institute_name"
        
    }
}

// MARK: - Permissions
//struct Permissions: Codable {
//    let viewSalary, addStaff, editStaffAttendance, invoiceTrackPayment: Int?
//    let msgToParents, msgToTeachers, studentLeaveApprove, multiLevelStudentLeaveDays: Int?
//    let multiLevelStudentLeaveApprove, multiLevelTeacherLeaveDays, studentSignin, teacherSignin,adminLogin,teacherLogin,studentLogin: Int?
//    let foodCourseType: [[String: String]]?
//    let dailyActivityApproval: Int?
//    let dailyActivityByTeacher: [[String: String]]?
//
//    enum CodingKeys: String, CodingKey {
//        case viewSalary = "view_salary"
//        case addStaff = "add_staff"
//        case editStaffAttendance = "edit_staff_attendance"
//        case invoiceTrackPayment = "invoice_track_payment"
//        case msgToParents = "msg_to_parents"
//        case msgToTeachers = "msg_to_teachers"
//        case studentLeaveApprove = "student_leave_approve"
//        case multiLevelStudentLeaveDays = "multi_level_student_leave_days"
//        case multiLevelStudentLeaveApprove = "multi_level_student_leave_approve"
//        case multiLevelTeacherLeaveDays = "multi_level_teacher_leave_days"
//        case studentSignin = "student_signin"
//        case teacherSignin = "teacher_signin"
//        case teacherLogin = "student_login"
//        case studentLogin = "teacher_login"
//        case adminLogin = "admin_login"
//        case foodCourseType = "food_course_type"
//        case dailyActivityApproval = "daily_activity_approval"
//        case dailyActivityByTeacher = "daily_activity_by_teacher"
//    }
//}
struct PermissionsLogin: Codable {
    let data: PermissionsData?
}

// MARK: - DataClass
struct PermissionsData: Codable {
    let  viewSalary, editStaffAttendance, msgToParents: Int?
    let msgToTeachers, studentLeaveApprove, multiLevelStudentLeaveDays, multiLevelStudentLeaveApprove: Int?
    let multiLevelTeacherLeaveDays, multiLevelTeacherLeaveApprove, adminLogin, studentLogin: Int?
    let teacherLogin, schoolFood: Int?
    let foodCourseIDS, foodCourseDetail: [String]?
    let dailyActivityApproval: Int?
  //  let dailyActivityByTeacher: [String]?

    enum CodingKeys: String, CodingKey {
        
        case viewSalary = "view_salary"
        case editStaffAttendance = "edit_staff_attendance"
        case msgToParents = "msg_to_parents"
        case msgToTeachers = "msg_to_teachers"
        case studentLeaveApprove = "student_leave_approve"
        case multiLevelStudentLeaveDays = "multi_level_student_leave_days"
        case multiLevelStudentLeaveApprove = "multi_level_student_leave_approve"
        case multiLevelTeacherLeaveDays = "multi_level_teacher_leave_days"
        case multiLevelTeacherLeaveApprove = "multi_level_teacher_leave_approve"
        case adminLogin = "admin_login"
        case studentLogin = "student_login"
        case teacherLogin = "teacher_login"
        case schoolFood = "school_food"
        case foodCourseIDS = "food_course_ids"
        case foodCourseDetail = "food_course_detail"
        case dailyActivityApproval = "daily_activity_approval"
        //case dailyActivityByTeacher = "daily_activity_by_teacher"
    }
}
