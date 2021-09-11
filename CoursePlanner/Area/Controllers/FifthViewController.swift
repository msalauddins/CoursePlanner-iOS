//
//  FifthViewController.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 25/11/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    var origin: String!
    var destination: String!
    var t1: String!
    var t2: String!
    var t3: String!
    var img1 = UIImage()
    var img2 = UIImage()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewCell2
            cell2.originLabel.text = origin
            
            cell2.clipsToBounds = true;
            cell2.layer.borderColor = UIColor.white.cgColor
            cell2.layer.borderWidth = 2
            cell2.layer.cornerRadius = 10;
            
            return cell2
        }
        else if indexPath.section == 1 {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CollectionViewCell3
            cell3.transit1.text = "Bus"
            
            cell3.clipsToBounds = true;
            cell3.layer.borderColor = UIColor.white.cgColor
            cell3.layer.borderWidth = 2
            cell3.layer.cornerRadius = 10;
            
            return cell3
        }
        else if indexPath.section == 2 {
            let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell4", for: indexPath) as! CollectionViewCell4
            
            if img1.size.width != 0  {
            cell4.img1.image = img1
            }
            else{
                print ("No image to display in img1")
            }
            
            cell4.clipsToBounds = true;
            cell4.layer.borderColor = UIColor.white.cgColor
            cell4.layer.borderWidth = 2
            cell4.layer.cornerRadius = 10;
            
            return cell4
        }
        else if indexPath.section == 3 {
            let cell5 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell5", for: indexPath) as! CollectionViewCell5
            cell5.transit2.text = "Train"
            
            cell5.clipsToBounds = true;
            cell5.layer.borderColor = UIColor.white.cgColor
            cell5.layer.borderWidth = 2
            cell5.layer.cornerRadius = 10;
            
            return cell5
        }
        else if indexPath.section == 4 {
            let cell6 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell6", for: indexPath) as! CollectionViewCell6
            
            if img2.size.width != 0  {
                cell6.img2.image = img2
            }
            else{
                print ("No image to display in img2")
            }
            
            cell6.clipsToBounds = true;
            cell6.layer.borderColor = UIColor.white.cgColor
            cell6.layer.borderWidth = 2
            cell6.layer.cornerRadius = 10;
            
            return cell6
        }
        else if indexPath.section == 5 {
            let cell7 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell7", for: indexPath) as! CollectionViewCell7
            cell7.transit3.text = "Cycle"
            
            cell7.clipsToBounds = true;
            cell7.layer.borderColor = UIColor.white.cgColor
            cell7.layer.borderWidth = 2
            cell7.layer.cornerRadius = 10;
            
            return cell7
        }
        else{
            let cell8 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell8", for: indexPath) as! CollectionViewCell8
            cell8.destinationLabel.text = destination
            
            cell8.clipsToBounds = true;
            cell8.layer.borderColor = UIColor.white.cgColor
            cell8.layer.borderWidth = 2
            cell8.layer.cornerRadius = 10;
            
            return cell8
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
