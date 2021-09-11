//
//  MyPageTableViewCell.swift
//  CoursePlanner
//
//  Created by Aney Paul on 1/21/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {

    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
