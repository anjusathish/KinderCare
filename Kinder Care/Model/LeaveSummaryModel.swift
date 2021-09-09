//
//  LeaveSummaryModel.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 22/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import Foundation


struct LeaveSummaryListResponse: Codable {
  let data: [LeaveSummaryDatum]?
}

// MARK: - Datum
struct LeaveSummaryDatum: Codable {
  let id: Int?
  let leaveType: String?
  let allowedCount, appliedCount, balanceCount: Int
  
  enum CodingKeys: String, CodingKey {
    case id
    case leaveType = "leave_type"
    case allowedCount = "allowed_cnt"
    case appliedCount = "applied_cnt"
    case balanceCount = "balance_cnt"
  }
}
