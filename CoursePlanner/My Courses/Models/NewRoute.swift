//
//  NewRoute.swift
//  CoursePlanner
//
//  Created by Aney Paul on 2/12/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class NewRoute: NSObject,NSCoding {
    var source: String = ""
    var destination: String = ""
    
    init(source: String, destination: String){
        self.source = source
        self.destination = destination
    }
    required init?(coder aDecoder: NSCoder) {
        self.source = aDecoder.decodeObject(forKey: "source") as? String ?? ""
        self.destination = aDecoder.decodeObject(forKey: "destination") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(source, forKey: "source")
        aCoder.encode(destination, forKey: "destination")
}
}
