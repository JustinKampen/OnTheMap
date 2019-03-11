//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// MARK: - SessionResponse: Codable

struct SessionResponse: Codable {
    var account: Account
    var session: Session
    
    struct Account: Codable {
        var registered: Bool
        var key: String
    }
    
    struct Session: Codable {
        var id: String
        var expiration: String
    }
}
