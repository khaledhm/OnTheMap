//
//  APIsRequests.swift
//  OnTheMap
//
//  Created by Khaled H on 25/02/2019.
//  Copyright © 2019 Khaled H. All rights reserved.
//

import Foundation
import UIKit



class APIs {
    
    private static var student = StudentInformation()
    private static var sessionID: String = ""
    
    //Udacity
    static func postRequest(username: String, password: String, completion: @escaping (String?)->Void){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    print("hereeeeeeeeeeeeee")
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        
                        self.student.key = accountDict["key"] as? String
                        self.sessionID = (sessionDict["id"] as? String)!
                        getStudentInfo(completion: { (firstName, LastName) in
                            self.student.firstName = firstName
                            self.student.lastName = LastName
                        })
                        print("*****************************")
                        print(student.key)
                        
                        
                    } else { //Err in parsing data
                        errString = "Couldn't parse response"
                    }
                } else { //Err in given login credintials
                    errString = "Provided login credintials didn't match our records"
                }
            } else { //Request failed to sent
                errString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    
    static func getStudentInfo(completion: @escaping (String?,String?)->Void) {
        guard let studnetID = student.key,
            let url = URL(string: "\(Constants.PUBLIC_USER)/\(studnetID)") else{
                completion(nil,nil)
                return
        }
        
        var request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request){ data, response, error in
            var firstName:String?,lastName : String?,nickname:String = ""
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 400{
                let newData = data?.subdata(in: 5 ..< data!.count)
                if let json = try? JSONSerialization.jsonObject(with: newData!, options: [.allowFragments]),
                    let dict = json as? [String:Any]
                {
                    
                    nickname = dict["nickname"] as? String ?? ""
                    firstName = dict["first_name"] as? String ?? nickname
                    lastName = dict["last_name"] as? String ?? nickname
                    
                    student.firstName = firstName
                    student.lastName = lastName
                    
                }
            }
            DispatchQueue.main.async {
                completion(firstName, lastName)
            }
        }
        task.resume()
    }
    
    
    static func deleteSession(compeletion: @escaping (String?)->Void){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            DispatchQueue.main.async {
                compeletion(nil)
            }
        }
        task.resume()
        print("Deletion finished!!!!!!")
    }
    
    
    
    class Parser {
        
        static func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (LocationsData?)->Void) {
            guard let url = URL(string: "\(Constants.STUDENT_LOCATION)?\(Constants.ParseParameterKeys.Limit)=\(limit)&\(Constants.ParseParameterKeys.Skip)=\(skip)&\(Constants.ParseParameterKeys.Order)=-\(orderBy.rawValue)") else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = Constants.HTTPMethod.get.rawValue
            request.addValue(Constants.ParseParametersValues.ApplicationID, forHTTPHeaderField: Constants.ParseParameterKeys.ApplicationID)
            request.addValue(Constants.ParseParametersValues.APIKey, forHTTPHeaderField: Constants.ParseParameterKeys.APIKey)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                
                var studentLocations: [StudentLocation] = []
                if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                    if statusCode >= 200 && statusCode < 300 { //Response is ok
                        
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                            let dict = json as? [String:Any],
                            let results = dict["results"] as? [Any] {
                            
                            for location in results {
                                let data = try! JSONSerialization.data(withJSONObject: location)
                                let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                                studentLocations.append(studentLocation)
                            }
                            
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(LocationsData(studentLocations: studentLocations))
                }
                
            }
            task.resume()
        }
        
        static func postLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
            
            guard let accountId = student.key, let url = URL(string: "\(Constants.STUDENT_LOCATION)") else{
                print(student.key)
                print(Constants.STUDENT_LOCATION)
                completion("invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = Constants.HTTPMethod.post.rawValue
            request.addValue(Constants.ParseParametersValues.ApplicationID, forHTTPHeaderField: Constants.ParseParameterKeys.ApplicationID)
            request.addValue(Constants.ParseParametersValues.APIKey, forHTTPHeaderField: Constants.ParseParameterKeys.APIKey)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let firstName = student.firstName,let lastName = student.lastName,let mapString = location.mapString,let mediaURL = location.mediaURL,let latitude = location.latitude,let longitude = location.longitude else {
                completion("invalid Attributes")
                return
            }
            request.httpBody = "{\"uniqueKey\":\"\(accountId)\",\"firstName\":\"\(firstName)\",\"lastName\":\"\(lastName)\",\"mapString\":\"\(mapString)\",\"mediaURL\":\"\(mediaURL)\",\"latitude\":\(latitude),\"longitude\":\(longitude)}".data(using: .utf8)
            
            
            let session = URLSession.shared
            let task = session.dataTask(with: request){ data, response, error in
                
                
                var errString: String?
                if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                    if statusCode >= 400{
                        errString = "couldn't post your location"
                    }
                }else{
                    errString = "check your internet connection"
                }
                DispatchQueue.main.async {
                    completion(errString)
                }
            }
            task.resume()
        }
}



    
    
//    //load studnets locations
//    private func loadStudentLocations() {
//        
//        var locationsData: LocationsData!{
//            let object = UIApplication.shared.delegate
//            let appDelegate = object as! AppDelegate
//            return appDelegate.locationsData
//        }
//        
//        Parser.getStudentLocations { (data) in
//            
//            guard let data = data else {
//                showAlert(title: "Error", message: "No internet connection found")
//                return
//            }
//            guard data.studentLocations.count > 0 else {
//                showAlert(title: "Error", message: "No pins found")
//                return
//            }
//            locationsData = data
//        }
//    }
    
}


