//
//  OriginViewController.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 6/11/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

protocol DataSendDelegate {
    func sendDataDelegate(data:String)
}

class OriginViewController: UIViewController {

    @IBOutlet weak var originText: UITextField!
    
    var dataSendDelegate: DataSendDelegate? = nil
    
    override func viewDidLoad() {
        self.navigationItem.title = "Origin"
        super.viewDidLoad()

    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if dataSendDelegate != nil{
            print("Found")
            if (originText.text?.count)! > 0{
                let data = "Origin: \(originText.text!)"
                dataSendDelegate?.sendDataDelegate(data: data)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
