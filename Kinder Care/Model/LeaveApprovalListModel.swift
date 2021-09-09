//
//  LeaveApprovalListModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 14/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation


enum DateFormatType : String{
    case type1 = "d MMM yyyy HH:mm a"
    case type2 = "dd MMM"
    case type3 = "dd/MM/yyyy"
    case type4 = "yyyy"
}

struct AddLeaveEmptyResponse : Codable {

}
/*struct AddLeaveRequestResponse: Codable {
    let data: [AddLeaveRequest]?
}

// MARK: - Datum
struct AddLeaveRequest: Codable {
    let id, leaveDays: Int?
    let fromDate, toDate, leaveType, reason: String?
    let contact: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case leaveDays = "leave_days"
        case fromDate = "from_date"
        case toDate = "to_date"
        case leaveType = "leave_type"
        case reason, contact, status
    }
}*/

struct DeleteLeaveEmptyResponse : Codable {
    
}

struct LeaveApprovalModel: Codable {
    let data: [LeaveApprovalList]?
    let message:String?
}
struct LeaveApprovalList: Codable {
    let id: Int?
    let name,section,stuClass, fromDate, toDate: String?
    let totDays: Int?
    let leaveType, reason, contactNo, requestedDate: String?
    let profile: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name,section
        case stuClass = "class"
        case fromDate = "from_date"
        case toDate = "to_date"
        case totDays = "tot_days"
        case leaveType = "leave_type"
        case reason
        case contactNo = "contact_no"
        case requestedDate = "requested_date"
        case profile, status
    }
}


struct LeaveApplicationModel: Codable {
    let data: [LeaveApplicationList]?
    let Message:String?
}

struct LeaveApplicationList: Codable {
    let id: Int
    let requestedDate, fromDate, toDate, contact: String?
    let leaveDays : Int
    let status: Int?
    let leaveType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case requestedDate = "requested date"
        case fromDate = "from_date"
        case toDate = "to_date"
        case contact
        case leaveDays = "leave_days"
        case status
        case leaveType = "leave_type"
    }
    
    func convertFromDate(currentFormate: String, toFormate : String) ->  String {
        
        let dateFormatterGet = DateFormatter()
        let fromDate = self.fromDate ?? ""
        dateFormatterGet.dateFormat = currentFormate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormate
        if let fromdate: Date = dateFormatterGet.date(from: fromDate){
            return dateFormatter.string(from: fromdate)
        }
        return ""
    }
    
    func convertToDate(currentFormate: String, toFormate : String) ->  String {
        
        let dateFormatterGet = DateFormatter()
        let toDate = self.toDate ?? ""
        dateFormatterGet.dateFormat = currentFormate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormate
        if let toDate: Date = dateFormatterGet.date(from: toDate){
            return dateFormatter.string(from: toDate)
        }
        return ""
    }
}


struct LeaveTypeName: Codable {
    let data: [LeaveTypeList]?
}

// MARK: - Datum
struct LeaveTypeList: Codable {
    let id: Int
    let leaveTypeName: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case leaveTypeName = "leave_type_name"
    }
}
