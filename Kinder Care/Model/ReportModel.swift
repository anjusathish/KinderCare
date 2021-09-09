//
//  ReportModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/20/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct ReportAttendanceResponse: Codable {
    let message :String?
    let data: [ReportAttendance]?
}

// MARK: - Datum
struct ReportAttendance: Codable {
    let id: Int
    let name, userType: String
    let presentDays, absentDays,workingDays: Int?
    let salary: Double?
    let  email: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case userType = "user_type"
        case workingDays = "working_days"
        case presentDays = "present_days"
        case absentDays = "absent_days"
         case email, salary
    }
}
struct ExportResponse:Codable{
    let data:String?
}
