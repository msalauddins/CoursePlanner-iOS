//
//  SettingsViewController.swift
//  CoursePlanner
//
//  Created by Aney Paul on 12/10/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var sideBarTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sidebarMenu: UIView!
    var isSideViewOpen: Bool = false
    
    var arrData = ["API Type"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDebug") as! TableViewCellDebug
        cell.urlAPI.text = arrData[indexPath.row]
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebugViewController") as!DebugViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sidebarMenu.isHidden = true
        isSideViewOpen = false
       
        self.sideBarTableView.tableFooterView = UIView()
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as!WelcomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        loginButton.addGestureRecognizer(longGesture)
        longGesture.minimumPressDuration = 1
        
        //navigationItem.hidesBackButton = true
        //let newBackButton = UIBarButtonItem(title: "Area", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        //navigationItem.leftBarButtonItem = newBackButton
    }
    /* @objc func back(sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as!ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
     */
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            let addButton: UIBarButtonItem = UIBarButtonItem(title: "Debug Mode", style: UIBarButtonItem.Style.done, target: self, action: #selector(debugButtonClicked(_:)))
             toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: addButton.action),addButton]
             self.navigationController!.setToolbarHidden(false, animated: false)
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "ScreenStatus")
        UserDefaults.standard.set(true, forKey: "ScreenStatus")
        if userNameTextField.text == "admin" && passwordTextField.text == "sa" {
            UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as!WelcomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
        let alertController = UIAlertController( title: "Error!", message: "Username or Password is incorrect!", preferredStyle: UIAlertController.Style.alert )
        alertController.addAction(UIAlertAction( title: "Ok", style: UIAlertAction.Style.default,handler: nil ))
        self.present( alertController, animated: true, completion: nil )
    }
    }
   
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func debugButtonClicked(_ button:UIBarButtonItem!){
        print("Debug clicked")
        //openNextView()
        openSidebarMenu()
        
    }
    /*
    func openNextView(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebugViewController") as!DebugViewController
        self.navigationController?.pushViewController(vc, animated: false)
        self.navigationController!.setToolbarHidden(true, animated: false)
    }
 */
    func openSidebarMenu(){
        sidebarMenu.isHidden = false
        self.view.bringSubviewToFront(sidebarMenu)
        if !isSideViewOpen{
            isSideViewOpen = true
            sidebarMenu.frame = CGRect(x: 0, y: 0, width: 0, height: 818)
            sideBarTableView.frame = CGRect(x: 8, y: 19, width: 0, height: 708)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sidebarMenu.frame = CGRect(x: 0, y: 0, width: 280, height: 818)
            sideBarTableView.frame = CGRect(x: 8, y: 19, width: 270, height: 708)
            UIView.commitAnimations()
        }else {
            sidebarMenu.isHidden = true
            isSideViewOpen = false
            sidebarMenu.frame = CGRect(x: 0, y: 0, width: 280, height: 818)
            sideBarTableView.frame = CGRect(x: 10, y: 0, width: 270, height: 708)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sidebarMenu.frame = CGRect(x: 0, y: 0, width: 0, height: 818)
            sideBarTableView.frame = CGRect(x: 10, y: 0, width: 0, height: 708)
            UIView.commitAnimations()
            self.navigationController!.setToolbarHidden(true, animated: false)
        }
        
    }
}
