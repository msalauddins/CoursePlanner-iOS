//
//  ThirdViewController.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 9/10/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    var course: Course!
    var courseSpots = [Course]()
    
    var uiImageArray = [UIImage?]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var Spottitle: UILabel!
    @IBOutlet weak var secondaryText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let course = course {
            Spottitle.text = course.title
            secondaryText.text = course.description
            
        } else {
            print( "Course is nil, so it's dangerous..." )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.course.spots.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicatorView.color = .blue
        activityIndicatorView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        activityIndicatorView.center = collectionView.center
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CollectionViewCell1
        
        //image load
        cell.image.image = nil
        cell.tag = indexPath.row
        self.uiImageArray.append( nil )
        let imgURL = NSURL(string: course.spots[ indexPath.row ].image )
        if let JSONimage = self.uiImageArray[ indexPath.row ]{
            if cell.tag == indexPath.row {
                cell.image.image = JSONimage
                activityIndicatorView.stopAnimating()
           }
        } else {
            DispatchQueue.global().async {
                if imgURL != nil {
                    let imgdata = NSData(contentsOf: (imgURL as URL?)!)
                    if imgdata != nil {
                    DispatchQueue.main.async {
                        let JSONimage = UIImage(data: imgdata! as Data)
                        self.uiImageArray[ indexPath.row ] = JSONimage
                        self.collectionView!.reloadData()
                        activityIndicatorView.stopAnimating()
                    }
                }
            } else {
                    print( "ImgURL not received" )
                }
            }
        }
        cell.clipsToBounds = true;
        cell.layer.cornerRadius = 0;
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3;

        cell.image.image = uiImageArray[ indexPath.row ]
        cell.spotTitle.text = course.spots[ indexPath.row ].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue3", sender: indexPath.row )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! FourthViewController
        guest.course2 = course
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
