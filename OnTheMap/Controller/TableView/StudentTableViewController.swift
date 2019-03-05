//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: - StudentTableViewController: UIViewController

class StudentTableViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [StudentInformaiton]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getStudents()
    }
    
    // MARK: UI Actions
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getStudents()
        tableView.reloadData()
    }
    
    // MARK: Get and Refresh Students
    
    func getStudents() {
        Students.shared.refreshStudents { (students, error) in
            DispatchQueue.main.async {
                guard let students = students else {
                    self.presentAlert()
                    return
                }
                self.students = students
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

// MARK: - StudentTableViewController: UITableViewDataSource, UITableViewDelegate

extension StudentTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as! StudentTableViewCell
        cell.studentNameLabel.text = "\(students[indexPath.row].firstName) \(students[indexPath.row].lastName)"
        cell.studentUrlLabel.text = students[indexPath.row].mediaURL?.baseURL?.absoluteString ?? students[indexPath.row].location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = students[indexPath.row].mediaURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            presentAlert("Invalid URL")
        }
    }
}
