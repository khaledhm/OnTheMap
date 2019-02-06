//
//  Networking.swift
//  OnTheMap
//
//  Created by Khaled H on 06/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import Foundation


class API: NSObject {
    
    
    var session = URLSession.shared
    
    var sessionID: String? = nil
    var userKey = ""
    var userName = ""
    
    
    class func shared() -> API {
        struct Singleton {
            static var shared = API()
        }
        return Singleton.shared
    }
    
    // MARK: - GET
    
    func taskForGETMethod(
        _ method               : String,
        parameters             : [String:AnyObject],
        apiType                : String = "udacity",
        completionHandlerForGET: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: method, apiType: apiType))
        
        if apiType == "parse" {
            request.addValue(Constants.ParseParametersValues.APIKey, forHTTPHeaderField: Constants.ParseParameterKeys.APIKey)
            request.addValue(Constants.ParseParametersValues.ApplicationID, forHTTPHeaderField: Constants.ParseParameterKeys.ApplicationID)
        }
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {

                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == "udacity" {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForGET(newData, nil)
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: - POST
    
    func taskForPOSTMethod(
        _ method                 : String,
        parameters               : [String:AnyObject],
        requestHeaderParameters  : [String:AnyObject]? = nil,
        jsonBody                 : String,
        apiType                  : String = "udacity",
        completionHandlerForPOST : @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: method, apiType: apiType))
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        if let headersParam = requestHeaderParameters {
            for (key, value) in headersParam {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
              
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request did not return a valid response.")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your credentials and try again.")
            case 200 ..< 299:
                break
            default:
                sendError("Your request returned a status code other than 2xx!")
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == "udacity" {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForPOST(newData, nil)
            
        }
        task.resume()
        
        return task
    }
    
    // MARK: - PUT
    
    func taskForPUTMethod(
        _ method                 : String,
        parameters               : [String:AnyObject],
        requestHeaderParameters  : [String:AnyObject]? = nil,
        jsonBody                 : String,
        apiType                  : String = "udacity",
        completionHandlerForPUT  : @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: method, apiType: apiType))
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        if let headersParam = requestHeaderParameters {
            for (key, value) in headersParam {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
            
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request did not return a valid response.")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your credentials and try again.")
            case 200 ..< 299:
                break
            default:
                sendError("Your request returned a status code other than 2xx!")
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == "udacity" {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForPUT(newData, nil)
            
        }
        task.resume()
        return task
    }
    
    // MARK: - DELETE
    
    func taskForDeleteMethod(
        _ method                   : String,
        parameters                 : [String:AnyObject],
        apiType                    : String = "udacity",
        completionHandlerForDELETE : @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: method, apiType: apiType))
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {

                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDeleteMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request did not return a valid response.")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your credentials and try again.")
            case 200 ..< 299:
                break
            default:
                sendError("Your request returned a status code other than 2xx!")
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == "udacity" {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }

            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForDELETE(newData, nil)
            
        }
        task.resume()
        return task
    }
    
    // MARK: - Helpers

    
    // create a URL from parameters
    private func buildURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil, apiType: String = "udacity") -> URL {
        
        var components = URLComponents()
        components.scheme = apiType == "udacity" ? Constants.Udacity.APIScheme : Constants.Parse.APIScheme
        components.host = apiType == "udacity" ? Constants.Udacity.APIHost : Constants.Parse.APIHost
        components.path = (apiType == "udacity" ? Constants.Udacity.APIPath : Constants.Parse.APIPath) + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    
    /// Authenticate a user using the given credentials.
    ///
    /// - Parameters:
    ///   - userEmail: a user email
    ///   - andPassword: a user password
    ///   - completionHandlerForAuth: returns **true** in case it succeeds or **false** and the given error in case of failure.
    func authenticateWith(userEmail: String, andPassword: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(andPassword)\"}}"
        _ = taskForPOSTMethod(Constants.UdacityMethods.Authentication, parameters: [:], jsonBody: jsonBody, completionHandlerForPOST: { (data, error) in
            if let error = error {
                print(error)
                completionHandlerForAuth(false, error.localizedDescription)
            } else {
                
                let userSessionData = self.parseUserSession(data: data)
                if let sessionData = userSessionData.0 {
                    guard let account = sessionData.account, account.registered == true else {
                        completionHandlerForAuth(false, "Login Failed, user not registered.")
                        return
                    }
                    guard let userSession = sessionData.session else {
                        completionHandlerForAuth(false, "Login Failed, no session to the user credentials provided.")
                        return
                    }
                    self.userKey = account.key
                    self.sessionID = userSession.id
                    completionHandlerForAuth(true, nil)
                } else {
                    completionHandlerForAuth(false, userSessionData.1!.localizedDescription)
                    self.sessionID = nil
                }
            }
        })
    }
    
    /// Ends the current user session.
    ///
    /// - Parameter completionHandlerForLogout: returns **true** in case the logout function was executed properly or **false** and the given error.
    func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        _ = taskForDeleteMethod(Constants.UdacityMethods.Authentication, parameters: [:], completionHandlerForDELETE: { (data, error) in
            if let error = error {
                print(error)
                completionHandlerForLogout(false, error)
            } else {
                let sessionData = self.parseSession(data: data)
                if let _ = sessionData.0 {
                    self.userKey = ""
                    self.sessionID = ""
                    completionHandlerForLogout(true, nil)
                } else {
                    completionHandlerForLogout(false, sessionData.1!)
                }
            }
        })
    }
    
    /// Fetches the logged user info.
    ///
    /// - Parameter completionHandler: returns the users logged info or an error.
    func studentInfo(completionHandler: @escaping (_ result: StudentInfo?, _ error: NSError?) -> Void) {
        let url = Constants.UdacityMethods.Users + "/\(userKey)"
        _ = taskForGETMethod(url, parameters: [:], completionHandlerForGET: { (data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                let response = self.parseStudentInfo(data: data)
                if let info = response.0 {
                    completionHandler(info, nil)
                } else {
                    completionHandler(nil, response.1)
                }
            }
        })
    }
    
    /// Fetches the Location for the user logged in.
    ///
    /// - Parameter completionHandler: returns all Students Information.
    func studentsInformation(completionHandler: @escaping (_ result: [UserInfo]?, _ error: NSError?) -> Void) {
        let params = [Constants.ParseParameterKeys.Order: "-updatedAt" as AnyObject]
        _ = taskForGETMethod(Constants.ParseMethods.StudentLocation, parameters: params, apiType: "parse") { (data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                if let data = data {
                    self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: { (jsonDoc, error) in
                        var students = [UserInfo]()
                        if let results = jsonDoc?[Constants.ParseJSONResponseKeys.Results] as? [[String: AnyObject]] {
                            for doc in results {
                                students.append(UserInfo(doc))
                            }
                            completionHandler(students, nil)
                            return
                        }
                        let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                        completionHandler(students, NSError(domain: "studentsInformation", code: 1, userInfo: userInfo))
                    })
                }
            }
        }
    }
    
    /// Fetches the Location for the user logged in.
    ///
    /// - Parameter completionHandler: returns a student Location in case it was saved previously.
    func studentInformation(completionHandler: @escaping (_ result: UserInfo?, _ error: NSError?) -> Void) {
        let params = [Constants.ParseParameterKeys.Where: "{\"uniqueKey\":\"\(userKey)\"}" as AnyObject]
        _ = taskForGETMethod(Constants.ParseMethods.StudentLocation, parameters: params, apiType: "parse") { (data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                if let data = data {
                    self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: { (jsonDoc, error) in
                        if let results = jsonDoc?[Constants.ParseJSONResponseKeys.Results] as? [[String: AnyObject]] {
                            if let studentInformation = results.first {
                                completionHandler(StudentInformation(studentInformation), nil)
                                return
                            }
                            completionHandler(nil, nil)
                            return
                        }
                        let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                        completionHandler(nil, NSError(domain: "studentInformation", code: 1, userInfo: userInfo))
                    })
                }
            }
        }
    }
    
    /// Post a user location, it must be used only in case the given StudentLocation is being saved for the first time. For update operations use the
    /// **updateStudentLocation** method instead.
    ///
    /// - Parameters:
    ///   - info: the StudentInformation object with all the location details.
    ///   - completionHandler: returns **true** in case it succeeds or **false** and the given error in case of failure.
    func postStudentLocation(info: UserInfo, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let paramHeaders = [
            Constants.ParseParameterKeys.APIKey       : Constants.ParseParametersValues.APIKey,
            Constants.ParseParameterKeys.ApplicationID: Constants.ParseParametersValues.ApplicationID,
            ] as [String: AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(info.uniqueKey)\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString)\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
        
        _ = taskForPOSTMethod(Constants.ParseMethods.StudentLocation, parameters: [:], requestHeaderParameters: paramHeaders, jsonBody: jsonBody, apiType: .parse) { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                struct Response: Codable {
                    let createdAt: String?
                    let objectId: String?
                }
                
                var response: Response!
                do {
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        response = try jsonDecoder.decode(Response.self, from: data)
                        if let response = response, response.createdAt != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let msg = "Could not parse the data as JSON: \(error.localizedDescription)"
                    print(msg)
                    let userInfo = [NSLocalizedDescriptionKey : msg]
                    completionHandler(false, NSError(domain: "postStudentLocation", code: 1, userInfo: userInfo))
                }
                
            }
        }
    }
    
    /// Update a student location.
    ///
    /// - Parameters:
    ///   - info: the StudentInformation object with all the location details.
    ///   - completionHandler: returns **true** in case it succeeds or **false** and the given error in case of failure.
    func updateStudentLocation(info: UserInfo, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let paramHeaders = [
            Constants.ParseParameterKeys.APIKey       : Constants.ParseParametersValues.APIKey,
            Constants.ParseParameterKeys.ApplicationID: Constants.ParseParametersValues.ApplicationID,
            ] as [String: AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(info.uniqueKey)\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString)\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
        
        let url = Constants.ParseMethods.StudentLocation + "/" + (info.locationID ?? "")
        
        _ = taskForPUTMethod(url, parameters: [:], requestHeaderParameters: paramHeaders, jsonBody: jsonBody, apiType: .parse, completionHandlerForPUT: { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                struct Response: Codable {
                    let updatedAt: String?
                }
                
                var response: Response!
                do {
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        response = try jsonDecoder.decode(Response.self, from: data)
                        if let response = response, response.updatedAt != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let msg = "Could not parse the data as JSON: \(error.localizedDescription)"
                    print(msg)
                    let userInfo = [NSLocalizedDescriptionKey : msg]
                    completionHandler(false, NSError(domain: "updateStudentLocation", code: 1, userInfo: userInfo))
                }
                
            }
        })
    }
    
    // MARK: - Helpers
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func parseStudentInfo(data: Data?) -> (StudentInfo?, NSError?) {
        var response: (studentInfo: StudentInfo?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                response.studentInfo = try jsonDecoder.decode(StudentInfo.self, from: data)
            }
        } catch {
            print("Could not parse the data as JSON: \(error.localizedDescription)")
            let userInfo = [NSLocalizedDescriptionKey : error]
            response.error = NSError(domain: "parseStudentInfo", code: 1, userInfo: userInfo)
        }
        return response
    }
    
    func parseUserSession(data: Data?) -> (UserSession?, NSError?) {
        var studensLocation: (userSession: UserSession?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                studensLocation.userSession = try jsonDecoder.decode(UserSession.self, from: data)
            }
        } catch {
            print("Could not parse the data as JSON: \(error.localizedDescription)")
            let userInfo = [NSLocalizedDescriptionKey : error]
            studensLocation.error = NSError(domain: "parseUserSession", code: 1, userInfo: userInfo)
        }
        return studensLocation
    }
    
    func parseSession(data: Data?) -> (Session?, Error?) {
        var sessionData: (session: Session?, error: Error?) = (nil, nil)
        do {
            
            struct SessionData: Codable {
                let session: Session
            }
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                sessionData.session = try jsonDecoder.decode(SessionData.self, from: data).session
            }
        } catch {
            print(error)
            sessionData.error = error
        }
        return sessionData
    }
    
}
