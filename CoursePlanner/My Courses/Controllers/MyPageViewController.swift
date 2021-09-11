//
//  MyPageViewController.swift
//  CoursePlanner
//
//  Created by Aney Paul on 1/21/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, DataSendFromCreateCourse{

    @IBOutlet weak var myPageTableView: UITableView!
    var myPage : [NewCourse] = []
    var courseArray = [NewCourse]()
    
    var titleCourse: String!
    var start: String!
    var end: String!
    
    func sendCourseTitleFromCreateCourse(data: String) {
        titleCourse = data
    }
    func sendStartDateFromCreateCourse(data: String) {
        start = data
    }
    func sendEndDateFromCreateCourse(data: String) {
        end = data
       
        loadNewCourse()
        self.myPageTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMyPage") as! MyPageTableViewCell
        cell.place.text = (myPage[ indexPath.row ].courseTitle)
        cell.startDate.text = (myPage[ indexPath.row ].startDate)
        cell.endDate.text = (myPage[ indexPath.row ].endDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.removeObject(forKey: "SelectedCourseTitle")
        UserDefaults.standard.removeObject(forKey: "LastSelectedCourse")
        UserDefaults.standard.set(indexPath.row + 1, forKey: "LastSelectedCourse")
        UserDefaults.standard.set("CourseClicked", forKey: "CourseClicked")
        let selectedCourseTitle = myPage[ indexPath.row ].courseTitle
        //print(selectedCourseTitle)
        UserDefaults.standard.set(selectedCourseTitle, forKey: "SelectedCourseTitle")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as!DetailViewController
        self.navigationController?.pushViewController(vc, animated: false)
        
        var selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.myPageTableView.tableFooterView = UIView()
        self.navigationItem.title = "My Courses"
        
        loadNewCourse()
    }
   
    func loadNewCourse(){
        //UserDefaults.standard.removeObject(forKey: "Courses")
        let courseData = UserDefaults.standard.object(forKey: "Courses")
        if courseData != nil {
            let courseArray = NSKeyedUnarchiver.unarchiveObject(with: courseData as! Data) as? [NewCourse] as! [NewCourse]
            if courseArray != nil {
                self.myPage = courseArray
            }
        }
        let courseTitle = UserDefaults.standard.string(forKey: "CourseTitle")
        let startDate = UserDefaults.standard.string(forKey: "StartDate")
        let endDate = UserDefaults.standard.string(forKey: "EndDate")
        if courseTitle != nil && startDate != "" && endDate != "" {
            let newCourse = NewCourse(courseTitle: courseTitle!, startDate: startDate!, endDate: endDate!)
            self.myPage.append(newCourse)
            UserDefaults.standard.removeObject(forKey: "CourseTitle")
            UserDefaults.standard.removeObject(forKey: "StartDate")
            UserDefaults.standard.removeObject(forKey: "EndDate")
            let myData = NSKeyedArchiver.archivedData(withRootObject: myPage)
            UserDefaults.standard.set(myData, forKey: "Courses")
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateCourseViewController") as!CreateCourseViewController
        vc.sendDataFromCreateCourse = (self as DataSendFromCreateCourse)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
