//
//  ParseResponses.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import Foundation

//MARK: Structures for Parse Responses
// Parse has been replaced with a Udacity API, but stuctures kept seperate for clarity
struct StudentLocationResponse: Codable{
    let createdAt: Date
    let firstName: String
    let lastName: String
    let latitude: Double // -90 to 90
    let longitude: Double // -180 to 180
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: Date
}


struct PostLocationResponse: Codable {
    let createdAt: Date
    let objectId: String
}

struct UpdateLocationRespons: Codable {
    let updatedAt: Date
}
