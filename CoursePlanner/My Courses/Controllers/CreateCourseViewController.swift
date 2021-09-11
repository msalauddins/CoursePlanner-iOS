//
//  CreateCourseViewController.swift
//  CoursePlanner
//
//  Created by Aney Paul on 1/20/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

protocol DataSendFromCreateCourse {
    func sendCourseTitleFromCreateCourse(data:String)
    func sendStartDateFromCreateCourse(data:String)
    func sendEndDateFromCreateCourse(data:String)
}

class CreateCourseViewController: UIViewController {
    
    var sendDataFromCreateCourse: DataSendFromCreateCourse? = nil

    @IBOutlet weak var courseTitle: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    let datePicker = UIDatePicker()
    var dateStart = Date()
    var dateEnd = Date()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "New Course"
        createDatePicker(startDate)
        createDatePicker(endDate)
    }
    func createDatePicker(_ sender: UITextField){
        datePicker.datePickerMode = .date
        sender.inputView = datePicker
    
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        if sender == startDate {
        let doneButtonStart = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneButtonClickedForStart))
        toolbar.setItems([doneButtonStart], animated: true)
        sender.inputAccessoryView = toolbar
        }
        else if sender == endDate {
            let doneButtonEnd = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneButtonClickedForEnd))
            toolbar.setItems([doneButtonEnd], animated: true)
            sender.inputAccessoryView = toolbar
        }
    }
    
    @objc func doneButtonClickedForStart(){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateformatter.string(from: datePicker.date)
        dateStart = dateformatter.date(from: dateString)!
        print(dateStart)
        startDate.text = dateString
        self.view.endEditing(true)
    }
    @objc func doneButtonClickedForEnd(){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateformatter.string(from: datePicker.date)
        dateEnd = dateformatter.date(from: dateString)!
        print(dateEnd)
        endDate.text = dateString
        self.view.endEditing(true)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if courseTitle.text != "" && startDate.text != nil && endDate.text != nil {
            if dateEnd > dateStart {
        UserDefaults.standard.set(courseTitle.text, forKey: "CourseTitle")
        UserDefaults.standard.set(startDate.text, forKey: "StartDate")
        UserDefaults.standard.set(endDate.text, forKey: "EndDate")
        UserDefaults.standard.synchronize()
                
                self.showToast(message: "Data Saved Successfully")
                if sendDataFromCreateCourse != nil{
                    print("Data found")
                    let title = courseTitle.text
                    let start = startDate.text
                    let end = endDate.text
                    sendDataFromCreateCourse?.sendCourseTitleFromCreateCourse(data: title!)
                    sendDataFromCreateCourse?.sendStartDateFromCreateCourse(data: start!)
                    sendDataFromCreateCourse?.sendEndDateFromCreateCourse(data: end!)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    print("Not Found")
                }
            }
            else {
                let alertController = UIAlertController( title: "Error!", message: "The End Date must not be before the Start Date and It cannot be the same date", preferredStyle: UIAlertController.Style.alert )
                alertController.addAction(UIAlertAction( title: "Ok", style: UIAlertAction.Style.default,handler: nil ))
                self.present( alertController, animated: true, completion: nil )
            }
        }
    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
