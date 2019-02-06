//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Khaled H on 06/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import Foundation


struct UserInfo {
    
    
    let firstName: String
    let lastName: String
    
    let latitude: Double
    let longitude: Double
    
    let locationID: String?
    let uniqueKey: String
    
    let mapString: String
    let mediaURL: String
    
    
    init(_ dictionary: [String: AnyObject]) {
        
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        
        self.locationID = dictionary["objectId"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        
    }
    
    var labelName: String {
        
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !lastName.isEmpty {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "No name available"
        }
        return name
    }
    
}
