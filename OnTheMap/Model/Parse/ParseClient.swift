//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// MARK: ParseClient

class ParseClient {
    
    // MARK: - Parse URL Properties
    
    static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    // MARK: - Parse URL Endpoints
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case getStudents(Int)
        case getStudent(String)
        case postStudent
        case putStudent(String)
        
        var stringValue: String {
            switch self {
            case .getStudents(let limit):
                return Endpoints.base + "/StudentLocation?limit=\(limit)&order=-updatedAt"
            case .getStudent(let key):
                return Endpoints.base + "/StudentLocation?\(key)"
            case .postStudent:
                return Endpoints.base + "/StudentLocation"
            case .putStudent(let objectId):
                return Endpoints.base + "/StudentLocation?\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - ParseClient Class Functions
    
    class func getStudents(limit: Int = 100, completion: @escaping ([StudentInformaiton]?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudents(limit).url)
        request.httpMethod = "GET"
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("An error occured loading students")
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentResults.self, from: data)
                let students = responseObject.results
                completion(students, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func getStudent(byKey key: String, completion: @escaping ([StudentInformaiton]?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudent(key).url)
        request.httpMethod = "GET"
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse_REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("No student was found")
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentResults.self, from: data)
                let student = responseObject.results
                print(student)
                completion(student, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func postStudent(objectId: String, firstName: String, lastName: String, mapString: String, mediaURL: URL, latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: Endpoints.postStudent.url)
        request.httpMethod = "POST"
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(objectId)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL.absoluteString)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil,
                let data = data,
                let response = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String : Any]??),
                (response?["updatedAt"] as? String != nil || response?["createdAt"] as? String != nil) else {
                    completion(false)
                    return
            }
            completion(true)
        }
        task.resume()
    }
    
    class func putStudent(objectId: String, firstName: String, lastName: String, mapString: String, mediaURL: URL, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.putStudent(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(objectId)\",\"firstName\": \"\(firstName)\",\"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\",\"mediaURL\": \"\(mediaURL.absoluteString)\",\"latitude\": \(latitude),\"longitude\": \(longitude)}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil,
                let data = data,
                let response = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String : Any]??),
                (response?["updatedAt"] as? String != nil || response?["createdAt"] as? String != nil) else {
                    completion(false, error)
                    return
            }
            completion(true, nil)
        }
        task.resume()
    }
}
