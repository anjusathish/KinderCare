//
//  MessageModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 17/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct ListMessageModel: Codable {
    
    let status: String
    let msg:String?
    let data: [MessageModel]?
    
}

struct MessageModel: Codable {
    let msgID,fromID,attachment_cnt: Int?
    let name, date, subject,toType,receiverType: String?
    let profile: String?
    let senderType : String?
    var read_status:Int?
    let attachment_size:String?

    enum CodingKeys: String, CodingKey {
        case msgID = "msg_id"
        case name, date, subject,attachment_cnt,attachment_size,read_status
        case senderType = "sender_type"
        case profile
        case fromID = "from_id"
        case toType = "to_type"
        case receiverType = "receiver_type"
      
    }
}
struct ViewMessageModel: Codable {
    let status: String
    let data: [MessageDetails]
}


struct MessageDetails: Codable {
    let msgID: String
    let to, name: [String]
    let subject: String
    let attachment: [String]?
    let from, fromUserType, date: String
    let userID: [Int]
    let sendTo: [String]
    let schoolID: Int
    let profile : String?
    let webattachments: [Webattachment]?
    let message:String?

    enum CodingKeys: String, CodingKey {
        case msgID = "msg_id"
        case to, name, subject, message, attachment, from,webattachments
        case fromUserType = "from_user_type"
        case date
        case userID = "user_id"
        case sendTo = "send_to"
        case schoolID = "school_id"
        case profile = "from_user_profile"
    }
}

struct Webattachment: Codable {
    let link: String?
    let name: String?
}

/*struct viewMessageModel: Codable {
    let status: String
    let data: [viewMessageData]
}

struct viewMessageData: Codable {
    let msgID: String
    let to, name: [String]
    let subject, message: String
    let attachment: 
    let from, fromUserType, date: String
    let userID: [Int]
    let sendTo: [String]
    let schoolID: Int

    enum CodingKeys: String, CodingKey {
        case msgID = "msg_id"
        case to, name, subject, message, attachment, from
        case fromUserType = "from_user_type"
        case date
        case userID = "user_id"
        case sendTo = "send_to"
        case schoolID = "school_id"
    }
}
*/
