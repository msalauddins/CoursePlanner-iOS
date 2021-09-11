//
//  TableViewRouteDetailCell.swift
//  CoursePlanner
//
//  Created by Aney Paul on 2/14/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class TableViewRouteDetailCell: UITableViewCell {
   
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var place: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
