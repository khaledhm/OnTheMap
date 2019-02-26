//
//  Constant.swift
//  OnTheMap
//
//  Created by Khaled H on 06/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import Foundation


struct Constants {
    
    
    private static let MAIN = "https://parse.udacity.com"
    static let SESSION = "https://onthemap-api.udacity.com/v1/session"
    static let PUBLIC_USER = "https://onthemap-api.udacity.com/v1/users"
    static let STUDENT_LOCATION = MAIN + "/parse/classes/StudentLocation"
    
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    // MARK: - Commons
    
    struct HTTPHeaderField {
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    struct HTTPHeaderFieldValue {
        static let json = "application/json"
    }
    
    
    // MARK: - Parse API
    
    
    struct ParseJSONResponseKeys {
        static let Results = "results"
    }
    
    struct ParseParameterKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let Where = "where"
        static let Order = "order"
        static let Limit = "limit"
        static let Skip = "skip"
    }
    
    struct ParseParametersValues {
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
}


