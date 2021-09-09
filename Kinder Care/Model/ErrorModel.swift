//
//  ErrorModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 26/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct ErrorModel: Codable {
    let errors: Errors?
}
struct Errors: Codable {
    let msg: String?
}

