//
//  String+Date.swift
//  OnTheMap
//
//  Created by Khaled H on 26/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import Foundation

extension String {
    var toDate: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }
}
