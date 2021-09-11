//
//  WelcomeViewController.swift
//  CoursePlanner
//
//  Created by Aney Paul on 12/12/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var screenLabel: UILabel!
    var loginScreen: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        navigationItem.leftBarButtonItem = newBackButton
        loginScreen = UserDefaults.standard.integer(forKey: "ScreenStatus")
        self.removeStatuses(loginScreen)
    }
    
    func removeStatuses(_ status: Int) {
        if status == 0 || status == 1 {
            UserDefaults.standard.removeObject(forKey: "ScreenStatus")
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let allViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if loginScreen == 0
        {
            self.navigationController?.popToViewController(allViewController[allViewController.count - 2], animated: true)
        }
        if loginScreen == 1 {
            self.navigationController?.popToViewController(allViewController[allViewController.count - 3], animated: true)
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        let allViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if loginScreen == 0
        {
            self.navigationController?.popToViewController(allViewController[allViewController.count - 2], animated: true)
        }
        if loginScreen == 1 {
            self.navigationController?.popToViewController(allViewController[allViewController.count - 3], animated: true)
        }
    }
    
}
