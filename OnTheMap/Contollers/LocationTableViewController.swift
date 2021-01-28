//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/24/21.
//

import UIKit

class LocationTableViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        handleStudentData()
        self.tableView.reloadData()
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        Client.deleteSession { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    var selectedIndex = 0
    var studentArray = [student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleStudentData()
        tableView.reloadData()
    }
}


extension LocationTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        let student = studentArray[indexPath.row]
        let fullName: String = "\(student.firstName) \(student.lastName)"
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentArray[indexPath.row]
        let urlString = student.mediaURL
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url, options: [:]) { (Bool) in
                return
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    func handleStudentData()  {
        Client.getStudentData() { (data: StudentData?, error: Error?) in
            if let error = error {
                let networkError = LoginErrorResponse (status: 99, error: "The Network Is Down")
                DispatchQueue.main.async {
                    self.showFailure(message: "The Network is Down")
                }
                return
            } else {
                var sortedStudentData: StudentData = data!
                sortedStudentData.results = sortedStudentData.results.sorted(by: { $0.updatedAt > $1.updatedAt })
                for student in sortedStudentData.results {
                    self.studentArray.append(student)
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Refresh Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
