//
//  NewCourse.swift
//  CoursePlanner
//
//  Created by Aney Paul on 1/23/19.
//  Copyright © 2019 Jorudan Co., Ltd. All rights reserved.
//

import UIKit

class NewCourse: NSObject, NSCoding {
    var courseTitle: String = ""
    var startDate: String = ""
    var endDate: String = ""
    
    init(courseTitle: String, startDate: String, endDate: String){
        self.courseTitle = courseTitle
        self.startDate = startDate
        self.endDate = endDate
    }
    required init?(coder aDecoder: NSCoder) {
        self.courseTitle = aDecoder.decodeObject(forKey: "courseTitle") as? String ?? ""
        self.startDate = aDecoder.decodeObject(forKey: "startDate") as? String ?? ""
        self.endDate = aDecoder.decodeObject(forKey: "endDate") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(courseTitle, forKey: "courseTitle")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
    }
}
