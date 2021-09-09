//
//  FamilyInformationModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 4/8/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct FamilyInformation: Codable {
    let data: FamilyInformationData?
}

// MARK: - DataClass
struct FamilyInformationData: Codable {
    let familyDetail: FamilyDetail
    let pickupPerson: PickupPerson
  let assignedTeachers: [AssignedTeacher]?

    enum CodingKeys: String, CodingKey {
        case familyDetail = "family detail"
        case pickupPerson = "pickup person"
        case assignedTeachers = "assigned_teachers"
    }
}

// MARK: - FamilyDetail
struct FamilyDetail: Codable {
    let id: Int
    let fatherName, motherName, primaryEmail: String
    let secondaryEmail: String?
    let fatherContact: String
    let motherContact: String?
    let address: String

    enum CodingKeys: String, CodingKey {
        case id
        case fatherName = "father_name"
        case motherName = "mother_name"
        case primaryEmail = "primary_email"
        case secondaryEmail = "secondary_email"
        case fatherContact = "father_contact"
        case motherContact = "mother_contact"
        case address
    }
}

// MARK: - PickupPerson
struct PickupPerson: Codable {
    let id: Int
    let pickupPerson, relationship, pickupContact, status: String

    enum CodingKeys: String, CodingKey {
        case id
        case pickupPerson = "pickup_person"
        case relationship
        case pickupContact = "pickup_contact"
        case status
    }
}

struct AssignedTeacher: Codable {
    let id: Int
    let name, contactNo, email, address: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case contactNo = "contact_no"
        case email, address
    }
}

struct PaymentList: Codable {
    let data: [PaymentListData]?
}

// MARK: - Datum
struct PaymentListData: Codable {
    let invoiceMasterID, invTblID: Int
    let studentInvoiceID, invoiceName, date: String
    let paymentType, totalAmount, received, pending: Int
    
    let terms: [Terms]?

    enum CodingKeys: String, CodingKey {
        case invoiceMasterID = "invoice_master_id"
        case invTblID = "inv_tbl_id"
        case studentInvoiceID = "student_invoice_id"
        case invoiceName = "invoice_name"
        case date
        case paymentType = "payment_type"
        case totalAmount = "total_amount"
        case received, pending
        case terms
    }
}

// MARK: - Term
struct Terms: Codable {
    let termName: String
    let termID, amount: Int
   

    enum CodingKeys: String, CodingKey {
        case termName = "term_name"
        case termID = "term_id"
        case amount
    }
}
