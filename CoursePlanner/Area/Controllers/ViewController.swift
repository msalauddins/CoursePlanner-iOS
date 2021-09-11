//
//  ViewController.swift
//  CoursePlanner
//
//  Created by Dan Lee on 2018-08-08.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var ui1data = [Area]()
    var uiImageArray = [UIImage?]()
    var url: URL!
    
    var screen: Int!
    override func viewDidLoad(){
        super.viewDidLoad()
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        self.tableView.addGestureRecognizer(longpress)
        
        self.navigationController!.setToolbarHidden(true, animated: false)
        navigationItem.hidesBackButton = true
        if UserDefaults.standard.integer(forKey: "Status") == 1 {
            url = URL(string: "http://192.168.0.110:3000/areas")
            self.view.setNeedsDisplay()
        }
        else if UserDefaults.standard.integer(forKey: "Status") == 2 {
            url = URL(string: "https://api.myjson.com/bins/168kgg")
            self.view.setNeedsDisplay()
        }
        else {
            url = URL(string: "https://api.myjson.com/bins/168kgg")
        }
        
        getdata()
    }
    
    func getdata(){
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicatorView.color = .blue
        activityIndicatorView.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
        activityIndicatorView.center = view.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        //url = URL(string: "https://api.myjson.com/bins/168kgg")
        //url = URL(string: "http://192.168.0.110:3000/areas")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {if error == nil {
                self.ui1data = try JSONDecoder().decode([Area].self, from: data!)
                for _ in self.ui1data {
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
        }
            catch {
                print("Error in get json data")
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ui1data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! TableViewCell1
        cell.nameLabel.text = (ui1data[ indexPath.row ].name)
        
        //image load and view
        cell.imgView.image = nil
        cell.tag = indexPath.row
        self.uiImageArray.append( nil )
        let imgURL = NSURL(string: ui1data[ indexPath.row ].image)
        if let JSONimage = self.uiImageArray[ indexPath.row ]{
            if cell.tag == indexPath.row {
                cell.imgView.image = JSONimage
                cell.clipsToBounds = true;
                cell.layer.cornerRadius = 10;
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 3;
                }
            } else {
                DispatchQueue.global().async {
                    if imgURL != nil {
                        let imgdata = NSData(contentsOf: (imgURL as URL?)!)
                        if imgdata != nil {
                        DispatchQueue.main.async {
                            let JSONimage = UIImage(data: imgdata! as Data)
                            self.uiImageArray[ indexPath.row ] = JSONimage
                            self.tableView.reloadData()
                        }
                      }
                    }
                }
            }
            return cell
        }
    
    //Sending data to next UI
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue1", sender: ui1data[ indexPath.row ].area_id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! SecondViewController
        guest.areaID = sender as! String
    }
    
    //Reorderable Cells using long press gesture
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        let longpress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longpress.state
        let locationInView = longpress.location(in: self.tableView)
        var indexPath = self.tableView.indexPathForRow(at: locationInView)
        
        switch state {
        case .began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = self.tableView.cellForRow(at: indexPath!) as! TableViewCell1
                My.cellSnapShot = snapshopOfCell(inputView: cell)
                var center = cell.center
                My.cellSnapShot?.center = center
                My.cellSnapShot?.alpha = 0.0
                self.tableView.addSubview(My.cellSnapShot!)
                
                UIView.animate(withDuration: 0.25, animations: {
                    center.y = locationInView.y
                    My.cellSnapShot?.center = center
                    My.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    My.cellSnapShot?.alpha = 0.98
                    cell.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        cell.isHidden = true
                    }
                })
            }
            
        case .changed:
            var center = My.cellSnapShot?.center
            center?.y = locationInView.y
            My.cellSnapShot?.center = center!
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                
                self.ui1data.swapAt((indexPath?.row)!, (Path.initialIndexPath?.row)!)
//                swap(&self.wayPoints[(indexPath?.row)!], &self.wayPoints[(Path.initialIndexPath?.row)!])
                self.tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }
            
        default:
            let cell = self.tableView.cellForRow(at: Path.initialIndexPath!) as! TableViewCell1
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                My.cellSnapShot?.center = cell.center
                My.cellSnapShot?.transform = .identity
                My.cellSnapShot?.alpha = 0.0
                cell.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    My.cellSnapShot?.removeFromSuperview()
                    My.cellSnapShot = nil
                }
            })
        }
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    struct My {
        static var cellSnapShot: UIView? = nil
    }
    
    struct Path {
        static var initialIndexPath: IndexPath? = nil
    }
    
    @IBAction func settingItem(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as!WelcomeViewController
            
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as!SettingsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func myPageItem(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController") as!MyPageViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
