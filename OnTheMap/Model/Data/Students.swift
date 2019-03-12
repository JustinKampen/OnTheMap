//
//  Student.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// MARK: Student

class Students {
    
    static var shared = Students()
    
    var all = [StudentInformaiton]()
    
    func refreshStudents(completion: @escaping ([StudentInformaiton]?, Error?) -> Void) {
        ParseClient.getStudents { (students, error) in
            if let students = students {
                self.all = students
            }
            completion(self.all, error)
        }
    }
}
