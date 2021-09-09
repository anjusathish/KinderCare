//
//  NotificationModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 24/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct NotificationModel: Codable {
    let data: [NotificationsList]
    let message:String?
}

// MARK: - Datum
struct NotificationsList: Codable {
    let id: Int
    let type, name, datumDescription, createdAt: String
    let leaveDays: Int?

    enum CodingKeys: String, CodingKey {
        case id, type, name
        case datumDescription = "description"
        case createdAt = "created_at"
        case leaveDays = "leave_days"
    }
}
