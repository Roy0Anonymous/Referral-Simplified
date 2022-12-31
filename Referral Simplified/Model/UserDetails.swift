//
//  UserDetails.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import Foundation

class UserDetails {
    var name: String?
    var email: String?
    var phone: String?
    var isStudent: Bool?
    init(name: String? = nil, email: String? = nil, phone: String? = nil, isStudent: Bool? = nil) {
        self.name = name
        self.email = email
        self.phone = phone
        self.isStudent = isStudent
    }
}

class Student: UserDetails {
    var resume: Data?
    var university: String?
    var dob: String?
    var graduation: Int?
}

class Professional: UserDetails {
    var company: String?
    var position: String?
}
