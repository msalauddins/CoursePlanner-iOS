//
//  DebugViewController.swift
//  CoursePlanner
//
//  Created by Aney Paul on 1/8/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewForAPIURL: UITableView!
    var arrData = ["Production API","Development API","Test Data API"]
    var lastSelectedIndex : Int!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAPIURL") as! TableViewCellAPIURL
        cell.cellAPIURL.text = arrData[indexPath.row]
        lastSelectedIndex = UserDefaults.standard.integer(forKey: "Status")
        if lastSelectedIndex == indexPath.row {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        if tableView.cellForRow(at: indexPath as IndexPath) != nil {
            lastSelectedIndex = UserDefaults.standard.integer(forKey: "Status")
            self.removeStatuses(lastSelectedIndex)
            let indexPathLast = IndexPath(row: lastSelectedIndex, section: 0)
            tableView.cellForRow(at: indexPathLast)?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            UserDefaults.standard.set(indexPath.row, forKey: "Status")
            UserDefaults.standard.synchronize()
        }
        return indexPath
    }
    func removeStatuses(_ status: Int) {
        if status == 0 || status == 1 || status == 2 {
            UserDefaults.standard.removeObject(forKey: "Status")
            UserDefaults.standard.synchronize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Login", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        navigationItem.leftBarButtonItem = newBackButton
        
        self.tableViewForAPIURL.tableFooterView = UIView()
    }
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}
