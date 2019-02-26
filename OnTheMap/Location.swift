//
//  Location.swift
//  OnTheMap
//
//  Created by Khaled H on 26/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import Foundation

struct LocationsData {
    var studentLocations: [StudentLocation] = []
    
    func getSortedStudentLocations() ->[StudentLocation]{
        return studentLocations.sorted(by: { (loc1,loc2) -> Bool in
            guard let date1 = loc1.updatedAt?.toDate else{
                return false
            }
            guard let date2 = loc2.updatedAt?.toDate else{
                return true
            }
            return date1 > date2
        })
    }
}
