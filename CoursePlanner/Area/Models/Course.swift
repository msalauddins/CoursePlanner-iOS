//
//  Course.swift
//  CoursePlanner
//
//  Created by MD Salauddin on 13/9/18.
//  Copyright © 2018 Jorudan Co., Ltd. All rights reserved.
//

import Foundation

class Course: Decodable {
    let area_id: String
    let course_id: String
    let title: String
    let description: String
    let course_time: Int
    let legs: [Legs]
    let spots: [Spots]
    let transits: [Transits]
    let tags: [String]
}

class Legs: Decodable {
    let id: String
    let type: String
    let leg_time: Int
}

class Spots: Decodable {
    let id: String
    let latitude: Double
    let longitude: Double
    let name: String
    let image: String
}

class Transits: Decodable {
    let id: String
    let origin: Origin
    let destination: Destination
}

class Origin: Decodable {
    let name: String
    let type: String
    let latitude: Double
    let longitude: Double
}

class Destination: Decodable {
    let name: String
    let type: String
    let latitude: Double
    let longitude: Double
}
