//
//  RouteSelectionViewController.swift
//  CoursePlanner
//
//  Created by Aney Paul on 1/30/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

protocol DataSendFromRouteSelection {
    func sendDataFromRouteSelection(data:Int)
}

class RouteSelectionViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var sendDataFromRouteSelection: DataSendFromRouteSelection? = nil
    
    var myPage : [NewRoute] = []
    var firstJsonFile : String = "haneda-to-narita"
    var secondJsonFile : String = "shinagawa-to-koshigoe"
    var thirdJsonFile : String = "shinjuku-to-shin-osaka"
    var fourthJsonFile : String = "tokyo-to-taura"
    
    var lastSelectedIndex : Int!
    var source: String = ""
    var destination: String = ""
    @IBOutlet weak var routeSelectionTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRouteNo") as! RouteSelectionTableViewCell
        cell.routeNo.text = (myPage[ indexPath.row ].source) + " to " + (myPage[ indexPath.row ].destination)
        return cell
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Route"
        self.routeSelectionTableView.tableFooterView = UIView()
        
        loadDataFromJson(firstJsonFile)
        loadDataFromJson(secondJsonFile)
        loadDataFromJson(thirdJsonFile)
        loadDataFromJson(fourthJsonFile)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set("Clicked", forKey: "Clicked")
        let routeIndex = indexPath.row + 1
        if sendDataFromRouteSelection != nil{
            print("Data found")
            sendDataFromRouteSelection?.sendDataFromRouteSelection(data: routeIndex)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            print("Not Found")
        }
    }
    
    func loadDataFromJson(_ fileName : String){
        var resultCount = 0
        var pathCount = 0
        var nodeCount = 0
        var nameCount = 0
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let jsonObject = json as? [String:Any] else {return}
            guard let resultArray = jsonObject["results"] as? [Any] else {return}
            for data in resultArray {
                guard let userDict = data as? [String:Any] else {return}
                //guard let route = userDict["route_no"] as? Int else {print("Not an Int"); return }
                //print(route)
                guard let pathList = userDict["paths"] as? [Any] else {return}
                for paths in pathList {
                    pathCount = pathCount + 1
                    if pathCount == 1 {
                        guard let origin = paths as? [String:Any] else {return}
                        guard let nodeList = origin["nodes"] as? [Any] else {return}
                        for node in nodeList {
                            nodeCount = nodeCount + 1
                            if nodeCount == 1 {
                                guard let nodes = node as? [String:Any] else {return}
                                guard let nameList = nodes["name"] as? [Any] else {return}

                                for name in nameList {
                                    nameCount = nameCount + 1;
                                    if nameCount == 1 {
                                        source = (name as! String)
                                        
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
                        
                        if nodeCount == nodeList.count {
                            guard let nodes = node as? [String:Any] else {return}
                            guard let nameList = nodes["name"] as? [Any] else {return}
                            nameCount = 0
                            for name in nameList {
                                nameCount = nameCount + 1;
                                if nameCount == 1 {
                                    destination = (name as! String)
                    
                                }
                            }
                        }
                        
                    }
                    }
                }
                let newRoute = NewRoute(source: source, destination: destination)
                self.myPage.append(newRoute)
                
                resultCount = resultCount + 1;
                if resultCount == 1 {
                    return
                }
            }
        }
        catch {
            print(error)
        }
    }
}
