//
//  DestinationViewController.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 14/11/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

protocol DataSendDelegate2 {
    func sendDataDelegate2(data:String)
}

class DestinationViewController: UIViewController {

    @IBOutlet weak var destinationText: UITextField!
    
    var dataSendDelegate2: DataSendDelegate2? = nil
    
    override func viewDidLoad() {
        self.navigationItem.title = "Destination"
        super.viewDidLoad()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if dataSendDelegate2 != nil{
            if (destinationText.text?.count)! > 0{
                let data = "Destination: \(destinationText.text!)"
                dataSendDelegate2?.sendDataDelegate2(data: data)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}
