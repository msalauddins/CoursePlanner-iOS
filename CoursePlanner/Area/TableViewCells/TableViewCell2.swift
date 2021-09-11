//
//  TableViewCell2.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 2/10/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {
    
    @IBOutlet weak var ttl: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
