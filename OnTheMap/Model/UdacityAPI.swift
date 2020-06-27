//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import Foundation

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
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginDetails = Udacity(username: username, password: password)
        let body = LogInStruct.init(udacity: loginDetails)
        var request = URLRequest(url: UdacityAPI.Endpoint.loginInformationEndpoint.url!)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonBody = try! JSONEncoder().encode(body)
        request.httpBody = jsonBody
        print(jsonBody)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            // handle user end error
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            if let responseObject = try? JSONDecoder().decode(ErrorInPostResponse.self, from: newData!) {
                DispatchQueue.main.async {
                    completion(false, responseObject)
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
                        completion(false, error)
                    }
                }
            }
            
        }
        task.resume()
           //do {
                //request.httpBody = try JSONEncoder().encode(body)
          // } catch {
          //     print(error)
          // }
        
           // start task and send request
           /*let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if error != nil {
                print(error?.localizedDescription)
                 DispatchQueue.main.async { completion(false, error)}
             } else {
                do {
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range) /* subset response data! */
                    let responseObject = try JSONDecoder().decode(PostSessionResponse.self, from: newData!)
                    
                    print("Data looked at as Post session")
                    DispatchQueue.main.async {
                        UserSession.userId = responseObject.account.key
                        completion(true, nil)
                    }
                } catch {
                    print("what the hell0!!")
                    DispatchQueue.main.async { completion(false, error)}
                }
            }
            }
            task.resume()*/
    }
    
    
    class func getRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isForLogin: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        let url = isForLogin ? URL(string: UdacityAPI.Endpoint.getUserInformationEndpoint.rawValue + "\(UserSession.userId)") : Endpoint.getMapPointsURL.url
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}

