//
//  Student.swift
//  OnTheMap
//
//  Created by Khaled H on 21/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var firstName: String?
    var lastName: String?
    var key: String?
}


struct StudentLocation: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
}

extension StudentLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}

enum SLParam: String {
    case createdAt
    case firstName
    case lastName
    case latitude
    case longitude
    case mapString
    case mediaURL
    case objectId
    case uniqueKey
    case updatedAt
}
