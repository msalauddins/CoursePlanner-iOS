//
//  SecondViewController.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 1/10/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet var tableView: UITableView!
    var areaID: String = ""
    var ui2data = [Course]()
    var uiImageArray = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = "Back"
        getdata2()
    }
    
    func getdata2(){
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicatorView.color = .blue
        activityIndicatorView.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
        activityIndicatorView.center = view.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        var apiurl = URL(string: "https://api.myjson.com/bins/12ndzs")
        //var apiurl = URL(string: "http://192.168.0.110:3000/courses?area_id=BD002")
        
        if areaID == "BD001" {
            apiurl = URL(string: "https://api.myjson.com/bins/y100w")
            //apiurl = URL(string: "http://192.168.0.110:3000/courses?area_id=BD001")
            print("URL Selected for areaID BD001")
        }
        else if areaID == "BD002"{
            print("URL Selected for areaID BD002")
        }
        else{
            print ("No URL Selected!")
        }
        
        URLSession.shared.dataTask(with: apiurl!) { (data, response, error) in
            do {if error == nil {
                self.ui2data = try JSONDecoder().decode([Course].self, from: data!)
                for _ in self.ui2data {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                         activityIndicatorView.stopAnimating()
                        }
                    }
                }
            else{
                let alertController = UIAlertController( title: "Network Error", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert )
                alertController.addAction(UIAlertAction( title: "Dismiss", style: UIAlertAction.Style.default,handler: nil ))
                self.present( alertController, animated: true, completion: nil )
                }
                
            } catch {
                print("Error in get json data")
                }
            }
            .resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ui2data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! TableViewCell2
        cell.ttl.text = (ui2data[ indexPath.row ].title)
        cell.des.text = (ui2data[ indexPath.row ].description)
        cell.clipsToBounds = true;
        cell.layer.cornerRadius = 10;
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3;
        
        //image load
        let course = ui2data[indexPath.row]
        cell.imgView.image = nil
        cell.tag = indexPath.row
        self.uiImageArray.append( nil )
        let imgURL = NSURL(string: course.spots[ 0 ].image )
        if let JSONimage = self.uiImageArray[ indexPath.row ]{
            if cell.tag == indexPath.row {
                cell.imgView.image = JSONimage
           
            }
        } else {
            DispatchQueue.global().async {
                if imgURL != nil {
                    let imgdata = NSData(contentsOf: (imgURL as URL?)!)
                    if imgdata != nil {
                    DispatchQueue.main.async {
                        let JSONimage = UIImage(data: imgdata! as Data)
                        self.uiImageArray[ indexPath.row ] = JSONimage
                        self.tableView!.reloadData()
                    }
                }
            } else {
                    print( "ImgURL not received" )
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue2", sender: indexPath.row )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let guest = segue.destination as! ThirdViewController
        let index = sender as! Int
        guest.course = ui2data[ index ]
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
    
    @IBAction func myPageItem(_ sender: Any) {
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController") as!MyPageViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }
}

