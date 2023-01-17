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
    var dob: String?
    var city: String?
    var country: String?
    var gender: String?
    static var isStudent: Bool?
    init(name: String? = nil, email: String? = nil, phone: String? = nil) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}

class Student: UserDetails {
    var resume: URL?
    var additionalDoc: URL?
    var university: String?
    var degree: String?
    var graduation: Int?
    var course: String?
}

class Professional: UserDetails {
    var company: String?
    var position: String?
}

var userDetails = UserDetails()
var student = Student()
var professional = Professional()
