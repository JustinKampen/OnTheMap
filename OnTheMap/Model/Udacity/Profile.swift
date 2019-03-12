//
//  Profile.swift
//  OnTheMap
//
//  Created by Justin Kampen on 3/2/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// MARK: Profile: Codable

struct Profile: Codable {
    var key: String
    var firstName: String
    var lastName: String

    enum CodingKeys: String, CodingKey {
        case key
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
