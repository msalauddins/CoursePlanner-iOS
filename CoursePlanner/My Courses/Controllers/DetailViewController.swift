//
//  DetailViewController.swift
//  CoursePlanner
//
//  Created by Aney Paul on 2/12/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController ,DataSendFromRouteSelection, UITableViewDelegate, UITableViewDataSource , UIScrollViewDelegate {
    
    let scrollView = UIScrollView(frame: CGRect(x: 10, y: 640, width: 395, height: 200))
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 110, y: 840, width: 200, height: 50))

    @IBOutlet weak var routeDetailTableView: UITableView!
    var firstJsonFile : String = "haneda-to-narita"
    var secondJsonFile : String = "shinagawa-to-koshigoe"
    var thirdJsonFile : String = "shinjuku-to-shin-osaka"
    var fourthJsonFile : String = "tokyo-to-taura"
    
    var routeListPlace : [String] = []
    var routeListTime : [String] = []
    var courseIndexList : [String] = []
    
    var placeListForAllRoute : [String] = []
    var timeListForAllRoute : [String] = []
    
    var loadedRouteListPlace : [String] = []
    var loadedRouteListTime : [String] = []
    
    var lastSelectedIndex: Int!
    func sendDataFromRouteSelection(data: Int) {
        print(data)
        lastSelectedIndex = data
        
        if lastSelectedIndex == 1  {
            loadDataFromJson(firstJsonFile)
            showDialogWindow()
        }
        else if lastSelectedIndex == 2  {
            loadDataFromJson(secondJsonFile)
            showDialogWindow()
        }
        else if lastSelectedIndex == 3  {
            loadDataFromJson(thirdJsonFile)
            showDialogWindow()
        }
        else if lastSelectedIndex == 4  {
            loadDataFromJson(fourthJsonFile)
            showDialogWindow()
        }
        
        //savePlaceTime()
        //loadSpecificRoute()
        
        //self.routeDetailTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedRouteListPlace.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteDetailCell") as! TableViewRouteDetailCell
        cell.time.text = loadedRouteListTime[indexPath.row]
        cell.place.text = loadedRouteListPlace[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController( title: "Delete!", message: "Are you sure you want to delete this route?", preferredStyle: UIAlertController.Style.alert )
        alertController.addAction(UIAlertAction( title: "Ok", style: UIAlertAction.Style.default, handler: { action in
           
            if editingStyle == .delete && tableView.cellForRow(at: indexPath as IndexPath) != nil {
                print(indexPath.row)
                
                self.loadedRouteListPlace.remove(at: indexPath.item)
                self.loadedRouteListTime.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                let lastSelectedCourse = UserDefaults.standard.integer(forKey: "LastSelectedCourse")
                let course = String(lastSelectedCourse)
                var index = self.courseIndexList.count - 1
                
                var cnt = 0
                for data in stride(from: self.courseIndexList.count - 1, through: 0, by: -1) {
                    if self.courseIndexList[data] == course {
                        if indexPath.row == cnt {
                            self.routeListPlace.remove(at: data)
                            self.routeListTime.remove(at: data)
                            self.courseIndexList.remove(at: data)
                        }
                        cnt = cnt + 1
                    }
                    index = index - 1
                }
                print(self.routeListPlace)
                print(self.routeListTime)
                print(self.courseIndexList)
                
                UserDefaults.standard.set(self.routeListPlace, forKey: "Place")
                UserDefaults.standard.set(self.routeListTime, forKey: "Time")
                UserDefaults.standard.set(self.courseIndexList, forKey: "CourseIndex")
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present( alertController, animated: true, completion: nil )
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        //self.view.addGestureRecognizer(gesture)

        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        self.routeDetailTableView.addGestureRecognizer(longpress)
        
        let selectedCourse = UserDefaults.standard.string(forKey: "SelectedCourseTitle")
        self.navigationItem.title = selectedCourse
        
        // Do any additional setup after loading the view.
     
        savePlaceTime()
        loadSpecificRoute()
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        scrollView.isHidden = true
        pageControl.isHidden = true
    }
    
    func showDialogWindow() {
        
        scrollView.isHidden = false
        pageControl.isHidden = false
        
        configurePageControl()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        self.view.addSubview(scrollView)
        for index in 0..<placeListForAllRoute.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
            button.center = CGPoint(x: 350, y: 160)
            button.backgroundColor = .orange
            button.setTitle("Select", for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            let labelTime = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 180))
            labelTime.center = CGPoint(x: 60, y: 90)
            labelTime.textAlignment = .center
            labelTime.numberOfLines = 8
            
            let labelPlace = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 180))
            labelPlace.center = CGPoint(x: 210, y: 90)
            //labelPlace.textAlignment = .center
            labelPlace.numberOfLines = 8
            
            labelPlace.text = placeListForAllRoute[index]
            labelPlace.textColor = UIColor.black
            
            labelTime.text = timeListForAllRoute[index]
            labelTime.textColor = UIColor.black
            let subView = UIView(frame: frame)
            subView.addSubview(labelPlace)
            subView.addSubview(labelTime)
            subView.addSubview(button)
            subView.backgroundColor = UIColor.lightGray
            self.scrollView .addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(placeListForAllRoute.count),height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func buttonAction(sender: UIButton!) {
       
        routeListPlace = []
        routeListTime = []
        courseIndexList = []
        
        for index in 0..<placeListForAllRoute.count {
        if(sender.tag == index){
            routeListPlace.append(placeListForAllRoute[index])
            routeListTime.append(timeListForAllRoute[index])
            let lastSelectedCourse = UserDefaults.standard.integer(forKey: "LastSelectedCourse")
            let course = String(lastSelectedCourse)
            courseIndexList.append(course)
        }
        }
        savePlaceTime()
        loadSpecificRoute()
        self.routeDetailTableView.reloadData()
       
        scrollView.isHidden = true
        pageControl.isHidden = true
    }
    func configurePageControl() {
        self.pageControl.numberOfPages = placeListForAllRoute.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.view.addSubview(pageControl)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        let longpress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longpress.state
        let locationInView = longpress.location(in: self.routeDetailTableView)
        var indexPath = self.routeDetailTableView.indexPathForRow(at: locationInView)
        
        switch state {
        case .began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = self.routeDetailTableView.cellForRow(at: indexPath!) as! TableViewRouteDetailCell
                My.cellSnapShot = snapshopOfCell(inputView: cell)
                var center = cell.center
                My.cellSnapShot?.center = center
                My.cellSnapShot?.alpha = 0.0
                self.routeDetailTableView.addSubview(My.cellSnapShot!)
                
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
                
                let lastSelectedCourse = UserDefaults.standard.integer(forKey: "LastSelectedCourse")
                let course = String(lastSelectedCourse)
                var index = courseIndexList.count - 1
                
                var cnt = 0
                var cnt1 = 0
                var source = 0
                var dest = 0
                for data in stride(from: courseIndexList.count - 1, through: 0, by: -1) {
                    if courseIndexList[data] == course {
                        if cnt == (Path.initialIndexPath?.row)! {
                             source = data
                        }
                        cnt = cnt + 1
                        if cnt1 == (indexPath?.row)! {
                           dest = data
                        }
                        cnt1 = cnt1 + 1
                    }
                    index = index - 1
                }
               
                self.routeListPlace.swapAt(dest, source)
                self.routeListTime.swapAt(dest, source)
                print(routeListPlace)
                self.loadedRouteListPlace.swapAt((indexPath?.row)!, (Path.initialIndexPath?.row)!)
                self.loadedRouteListTime.swapAt((indexPath?.row)!, (Path.initialIndexPath?.row)!)
                self.routeDetailTableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
                
                UserDefaults.standard.set(self.routeListPlace, forKey: "Place")
                UserDefaults.standard.set(self.routeListTime, forKey: "Time")
                UserDefaults.standard.set(self.courseIndexList, forKey: "CourseIndex")
            }
            
        default:
            let cell = self.routeDetailTableView.cellForRow(at: Path.initialIndexPath!) as! TableViewRouteDetailCell
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
   
    func loadDataFromJson(_ fileName : String){
        //var resultCount = 0
        var pathCount = 0
        var nodeCount = 0
        var nameCount = 0
        
        placeListForAllRoute = []
        timeListForAllRoute = []
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //guard let jsonObject = json as? [String:Any] else {return}
            
            //NSData & TemporaryFile
            let urlOfTemporaryFile = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName + ".json")
            try data.write(to: urlOfTemporaryFile, options: .atomicWrite)
            print(urlOfTemporaryFile)
            let dataFromTemporaryFile = try Data(contentsOf: urlOfTemporaryFile)
            let json = try JSONSerialization.jsonObject(with: dataFromTemporaryFile, options: .mutableContainers)
            guard let jsonObject = json as? [String:Any] else {return}
            //print("cache-result")
            //print(dataFromTemporaryFile)
            //print(jsonObject)
           
            /*cache
            let cache = NSCache<AnyObject, AnyObject>()
            cache.setObject(json as AnyObject, forKey: "FileSavedInCache" as AnyObject)
            let result = cache.object(forKey: "FileSavedInCache" as AnyObject) as AnyObject
            guard let jsonObject = result as? [String:Any] else {return}
             */
            
            guard let resultArray = jsonObject["results"] as? [Any] else {return}
            for data in resultArray {
                guard let userDict = data as? [String:Any] else {return}
                guard let pathList = userDict["paths"] as? [Any] else {return}
                
                var placeList : String = ""
                var timeList : String = ""
                
                pathCount = 0
                nodeCount = 0
                nameCount = 0
                for paths in pathList {
                    pathCount = pathCount + 1
                    if pathCount != pathList.count {
                        guard let origin = paths as? [String:Any] else {return}
                        guard let nodeList = origin["nodes"] as? [Any] else {return}
                        nodeCount = 0
                        for node in nodeList {
                            nodeCount = nodeCount + 1
                            if nodeCount == 1 {
                                guard let nodes = node as? [String:Any] else {return}
                                guard let nameList = nodes["name"] as? [Any] else {return}
                                guard let jikoku = nodes["jikoku"] as? [String:Any] else {return}
                                guard let time = jikoku["time"] as? String else {return}
                                guard let type = jikoku["type"] as? Int else {print("Not an Int"); return }
                                if type == -2 {
                                    timeList.append("\n")
                                    timeList.append("-")
                                    timeList.append("\n")
                                }else {
                                    var time = (time)
                                    time.insert(":", at: time.index(time.startIndex, offsetBy: 2))
                                    timeList.append(time)
                                    timeList.append("\n")
                                }
                                nameCount = 0
                                for name in nameList {
                                    nameCount = nameCount + 1;
                                    if nameCount == 1 {
                                        let place = (name as! String)
                                        placeList.append(place)
                                        placeList.append("\n")
                                    }
                                }
                            }
                        }
                    }
                    if pathCount == pathList.count {
                        guard let origin = paths as? [String:Any] else {return}
                        guard let nodeList = origin["nodes"] as? [Any] else {return}
                        nodeCount = 0
                        for node in nodeList {
                            nodeCount = nodeCount + 1
                            
                            if nodeCount != nodeList.count {
                                guard let nodes = node as? [String:Any] else {return}
                                guard let nameList = nodes["name"] as? [Any] else {return}
                                guard let jikoku = nodes["jikoku"] as? [String:Any] else {return}
                                guard let time = jikoku["time"] as? String else {return}
                                guard let type = jikoku["type"] as? Int else {print("Not an Int"); return }
                                if type == -2 {
                                    timeList.append("\n")
                                    timeList.append("-")
                                    timeList.append("\n")
                                }else {
                                    var time = (time)
                                    time.insert(":", at: time.index(time.startIndex, offsetBy: 2))
                                    timeList.append(time)
                                    timeList.append("\n")
                                }
                                nameCount = 0
                                for name in nameList {
                                    nameCount = nameCount + 1;
                                    if nameCount == 1 {
                                        let place = (name as! String)
                                        placeList.append(place)
                                        placeList.append("\n")
                                    }
                                }
                            }
                            if nodeCount == nodeList.count {
                                guard let nodes = node as? [String:Any] else {return}
                                guard let nameList = nodes["name"] as? [Any] else {return}
                                guard let jikoku = nodes["jikoku"] as? [String:Any] else {return}
                                guard let time = jikoku["time"] as? String else {return}
                                guard let type = jikoku["type"] as? Int else {print("Not an Int"); return }
                                if type == -2 {
                                    timeList.append("\n")
                                    timeList.append("-")
                                    timeList.append("\n")
                                }else {
                                    var time = (time)
                                    time.insert(":", at: time.index(time.startIndex, offsetBy: 2))
                                    timeList.append(time)
                                    timeList.append("\n")
                                }
                                nameCount = 0
                                for name in nameList {
                                    nameCount = nameCount + 1;
                                    if nameCount == 1 {
                                        let place = (name as! String)
                                        placeList.append(place)
                                        placeList.append("\n")
                                    }
                                }
                            }
                        }
                    }
                }
                placeListForAllRoute.append(placeList)
                timeListForAllRoute.append(timeList)
                
                /*
                resultCount = resultCount + 1;
                if resultCount == 1 {
                    return
                }*/
            }
            
        }
        catch {
            print(error)
        }
    }
    
    func savePlaceTime(){
        //UserDefaults.standard.removeObject(forKey: "Place")
        //UserDefaults.standard.removeObject(forKey: "Time")
        //UserDefaults.standard.removeObject(forKey: "CourseIndex")
        
        let clicked = UserDefaults.standard.string(forKey: "Clicked")
        let myarray = UserDefaults.standard.stringArray(forKey: "Place") ?? [String]()
        if myarray != [] {
            if clicked == "Clicked" {
            for data in myarray {
            self.routeListPlace.append(data)
            }
            }
            else {
                self.routeListPlace = myarray
            }
            print(myarray)
        }
        let myarrayTime = UserDefaults.standard.stringArray(forKey: "Time") ?? [String]()
        if myarrayTime != [] {
            if clicked == "Clicked" {
            for data in myarrayTime {
                self.routeListTime.append(data)
            }
            }
            else {
                self.routeListTime = myarrayTime
            }
            print(myarrayTime)
        }
        let myarrayCourseIndex = UserDefaults.standard.stringArray(forKey: "CourseIndex") ?? [String]()
        if myarrayCourseIndex != [] {
            if clicked == "Clicked" {
                for data in myarrayCourseIndex {
                    self.courseIndexList.append(data)
                }
            }
            else {
                self.courseIndexList = myarrayCourseIndex
            }
            print(myarrayCourseIndex)
        }
       
        UserDefaults.standard.set(routeListPlace, forKey: "Place")
        UserDefaults.standard.set(routeListTime, forKey: "Time")
        UserDefaults.standard.set(courseIndexList, forKey: "CourseIndex")
        UserDefaults.standard.removeObject(forKey: "Clicked")
    }
    func loadSpecificRoute() {
        
        loadedRouteListPlace = []
        loadedRouteListTime = []
        
        let lastSelectedCourse = UserDefaults.standard.integer(forKey: "LastSelectedCourse")
        let course = String(lastSelectedCourse)
        var index = courseIndexList.count - 1
        
        for data in stride(from: courseIndexList.count - 1, through: 0, by: -1) {
            if courseIndexList[data] == course {
                //print(data)
                if routeListTime != [] && routeListPlace != [] {
                self.loadedRouteListTime.append(routeListTime[index])
                self.loadedRouteListPlace.append(routeListPlace[index])
                }
            }
            index = index - 1
        }
        
    }
   
    @IBAction func addButtonClicked(_ sender: Any) {
        scrollView.isHidden = true
        pageControl.isHidden = true
        
        let alert = UIAlertController(title: "ADD", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Route", style: UIAlertAction.Style.default, handler: { action in
            print("Route is Selected")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RouteSelectionViewController") as!RouteSelectionViewController
            vc.sendDataFromRouteSelection = (self as DataSendFromRouteSelection)
            self.navigationController?.pushViewController(vc, animated: false)
        }))
        alert.addAction(UIAlertAction(title: "Event", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
