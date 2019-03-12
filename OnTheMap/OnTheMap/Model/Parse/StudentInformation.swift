//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// MARK: - StudentInformation: Codable

struct StudentInformaiton: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let location: String
    let mediaURL: URL?
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, mediaURL, latitude, longitude
        case id = "objectId"
        case location = "mapString"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        firstName = (try? values.decode(String.self, forKey: .firstName)) ?? ""
        lastName = (try? values.decode(String.self, forKey: .lastName)) ?? ""
        location = (try? values.decode(String.self, forKey: .location)) ?? ""
        mediaURL = (try? values.decode(URL.self, forKey: .mediaURL)) ?? nil
        latitude = (try? values.decode(Double.self, forKey: .latitude)) ?? 0.0
        longitude = (try? values.decode(Double.self, forKey: .longitude)) ?? 0.0
    }
}
