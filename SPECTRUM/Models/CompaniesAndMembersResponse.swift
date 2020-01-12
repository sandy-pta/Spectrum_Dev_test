//
//  CompaniesAndMembersResponse.swift
//  SPECTRUM
//
//  Created by Sandeep Malhotra on 04/01/20.
//  Copyright © 2020 Sandeep Malhotra. All rights reserved.
//

struct CompaniesAndMembersResponse : Codable {
    let _id : String?
    let company : String?
    let website : String?
    let logo : String?
    let about : String?
    let members : [Members]?
    var isFav: Bool = false
    var isFollowing: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case company = "company"
        case website = "website"
        case logo = "logo"
        case about = "about"
        case members = "members"
    }
}

struct Members : Codable {
    let _id : String?
    let age : Int?
    let name : Name?
    let email : String?
    let phone : String?
    var isFav: Bool = false

    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case age = "age"
        case name = "name"
        case email = "email"
        case phone = "phone"
    }
}

struct Name : Codable {
    let first : String?
    let last : String?
    
    enum CodingKeys: String, CodingKey {
        case first = "first"
        case last = "last"
    }
}
