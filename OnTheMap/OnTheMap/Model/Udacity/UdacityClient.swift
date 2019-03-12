//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// MARK: - UdacityClient

class UdacityClient {
    
    // MARK: Udacity Authentication
    
    struct Authentication {
        static var accountKey = ""
        static var sessionId = ""
    }
    
    // MARK: User Information
    
    struct UserInfo {
        static var key = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    // MARK: Udacity URL Addresses
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case getProfile
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .getProfile:
                return Endpoints.base + "/users/\(Authentication.sessionId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: UdacityClient Class Functions
    
    class func postSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\":{\"username\":\"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, nil)
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(SessionResponse.self, from: newData)
                Authentication.accountKey = responseObject.account.key
                Authentication.sessionId = responseObject.session.id
                completion(true, nil)
            } catch {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        let body = LogoutRequest(id: Authentication.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Authentication.accountKey = ""
            Authentication.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    class func getUserProfile(completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getProfile.url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(Profile.self, from: newData)
                UserInfo.key = responseObject.key
                UserInfo.firstName = responseObject.firstName
                UserInfo.lastName = responseObject.lastName
                print("User Key: " + UserInfo.key)
                print("User First Name:" + UserInfo.firstName)
                print("User Last Name:" + UserInfo.lastName)
                completion(newData, nil)
            } catch {
                completion(nil, error)
                print(error)
            }
        }
        task.resume()
    }
}
