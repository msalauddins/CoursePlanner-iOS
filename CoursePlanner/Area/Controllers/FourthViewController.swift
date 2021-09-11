//
//  FourthViewController.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 6/11/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController, DataSendDelegate, DataSendDelegate2 {

    func sendDataDelegate(data: String) {
        self.originLabel.text = data
    }
    
    func sendDataDelegate2(data: String) {
        self.destinationLabel.text = data
    }

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    var uiImageArray = [UIImage?]()
    var course2: Course!
    var courseSpots2 = [Course]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getimages ()
    }
    
    func getimages(){
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicatorView.color = .blue
        activityIndicatorView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        activityIndicatorView.center = img2.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        if let course2 = course2 {
            print("4th screen data received:", course2.title)
        } else {
            print( "No Course data on 4th screen!" )
        }
        
        if img1.image == nil{
            
            let imgURL = NSURL(string: course2.spots[ 0 ].image )
            
            DispatchQueue.global().async {
                if imgURL != nil {
                    let imgdata = NSData(contentsOf: (imgURL as URL?)!)
                    if imgdata != nil {
                    DispatchQueue.main.async {
                        let JSONimage = UIImage(data: imgdata! as Data)
                        self.img1.image = JSONimage
                        self.img1.clipsToBounds = true;
                        self.img1.layer.cornerRadius = 10;
                        activityIndicatorView.stopAnimating()
                    }
                }
            }
          }
        }
        else {
            print( "image already loaded" )
        }
        if img2.image == nil{
            let imgURL = NSURL(string: course2.spots[ 1 ].image )
            DispatchQueue.global().async {
                if imgURL != nil {
                    let imgdata = NSData(contentsOf: (imgURL as URL?)!)
                    if imgdata != nil {
                    DispatchQueue.main.async {
                        let JSONimage = UIImage(data: imgdata! as Data)
                        self.img2.image = JSONimage
                        self.img2.clipsToBounds = true;
                        self.img2.layer.cornerRadius = 10;
                    }
                }
            }
        }
     }
    else {
            print( "image already loaded" )
        }
    }
    
    @IBAction func selectOrigin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OriginViewController") as!OriginViewController
        vc.dataSendDelegate=(self as DataSendDelegate)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectDestination(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DestinationViewController") as!DestinationViewController
        vc.dataSendDelegate2=(self as DataSendDelegate2)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue4") {
            let vc = segue.destination as! FifthViewController
        
            vc.origin = originLabel.text
            vc.destination = destinationLabel.text
            vc.t1 = "Train"
            vc.t2 = "Bus"
            vc.t3 = "Cycle"
            
            if img1.image != nil  {
                vc.img1 = img1.image!
            }
            else {
                print ("img1 is empty")
            }
            
            
            if img2.image != nil  {
                vc.img2 = img2.image!
            }
            else {
                print ("img2 is empty")
            }
          
        }
    }
    
    @IBAction func settingsItem(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as!WelcomeViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as!SettingsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
    
    


