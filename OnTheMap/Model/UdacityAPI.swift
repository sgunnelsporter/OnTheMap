//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: API URL Endpoints
class UdacityAPI {
    
    enum Endpoint : String {
        case loginInformationEndpoint = "https://onthemap-api.udacity.com/v1/session"
        case getUserInformationEndpoint = "https://onthemap-api.udacity.com/v1/users/"
        case parseMapInformationEndpoint = "https://onthemap-api.udacity.com/v1/StudentLocation"
        case getMapPointsURL = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
        
        var url : URL? {
            return URL(string: self.rawValue)
        }
    
    }
 
    //MARK: Logging In Network Calls
    class func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let loginDetails = Udacity(username: username, password: password)
        let body = LogInStruct.init(udacity: loginDetails)
        var request = URLRequest(url: UdacityAPI.Endpoint.loginInformationEndpoint.url!)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            // handle user end error
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          //print(String(data: newData!, encoding: .utf8)!)
            if let responseObject = try? JSONDecoder().decode(ErrorInPostResponse.self, from: newData!) {
                DispatchQueue.main.async {
                    let message = responseObject.error
                    completion(false, message)
                }
            } else {
                do {
                    let responseData = try JSONDecoder().decode(PostSessionResponse.self, from: newData!)
                    DispatchQueue.main.async {
                        UserSession.userId = responseData.account.key
                        completion(true, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error.localizedDescription)
                    }
                }
            }
            
        }
        task.resume()
    }
    
    
    class func getUserInformationRequest(completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: UdacityAPI.Endpoint.getUserInformationEndpoint.rawValue + "\(UserSession.userId)")
        
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                completion(false, error)
            }
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          //print(String(data: newData!, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(GetUserInformationResponse.self, from: newData!)
                UserSession.firstName = responseObject.firstName
                UserSession.lastName = responseObject.lastName
                UserSession.nickname = responseObject.nickname
                DispatchQueue.main.async { completion(true, nil) }
            } catch {
                DispatchQueue.main.async { completion(false, error)}
            }
        }
        task.resume()
    }
    
    //MARK: Logout Network Call
    class func deleteSessionRequest() {
        let url = Endpoint.loginInformationEndpoint.url
        var request = URLRequest(url: url!)
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
          if error != nil {
            print(error?.localizedDescription ?? "")
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    //MARK: Map Pin Data Network Calls
    class func getMapDataRequest(completion: @escaping ([LocationResults], Error?) -> Void) {
        let url = Endpoint.getMapPointsURL.url
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let fullResponseObject = try decoder.decode(StudentLocationResponse.self, from: data)
                let responseArray = fullResponseObject.results
                DispatchQueue.main.async {
                    completion(responseArray, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    class func postNewStudenLocation(newLatitude: Double, newLongitude: Double, locationString: String, locationMediaURL: String, completion: @escaping ([LocationResults], Error?) -> Void) {
        let postRequestBody = StudentLocation(uniqueKey: UserSession.userId, firstName: UserSession.firstName, lastName: UserSession.lastName, mapString: locationString, mediaURL: locationMediaURL, latitude: newLatitude, longitude: newLongitude)
        
        var request = URLRequest(url: self.Endpoint.parseMapInformationEndpoint.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(postRequestBody)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
              if error != nil {
                print(error?.localizedDescription ?? "")
                  return
              }
            }
            task.resume()
        } catch {
            print("Issue encoding Request Body")
        }
    }
}

