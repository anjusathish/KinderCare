//
//  CalendarModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 4/13/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct HolidayList: Codable {
    let data: [HoildayData]?
}

// MARK: - Datum
struct HoildayData: Codable {
    let id, instituteID, schoolID: Int
    let date, day, holiday: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case instituteID = "institute_id"
        case schoolID = "school_id"
        case date, day, holiday, status
        
    }
}
