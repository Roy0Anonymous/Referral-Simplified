//
//  UserDetails.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import Foundation

class UserDetails {
    var name: String
    var email: String
    var phone: String
    var isStudent: Bool?
    init(name: String, email: String, phone: String, isStudent: Bool? = nil) {
        self.name = name
        self.email = email
        self.phone = phone
        self.isStudent = isStudent
    }
}

class Student: UserDetails {
    var resume: NSData?
    var university: String?
    var degree: String?
    var dob: String?
    var graduation: Int?
}

class Professional: UserDetails {
    var company: String?
    var position: String?
}
