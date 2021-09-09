//
//  MessageUserList.swift
//  Kinder Care
//
//  Created by CIPL0419 on 26/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

// MARK: - MessageUserList
struct MessageUserList: Codable {
    let data: [MessageUserData]
}

// MARK: - Datum
struct MessageUserData: Codable {
    let id,institute_id,school_id: Int
    let detail : String
    let email : String?
}
