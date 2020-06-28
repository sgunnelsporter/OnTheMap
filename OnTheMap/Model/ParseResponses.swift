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
struct StudentLocationResponse: Codable {
    let results: [LocationResults]
}
struct LocationResults: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double // -180 to 180
    let latitude: Double // -90 to 90
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

struct PostLocationResponse: Codable {
    let createdAt: Date
    let objectId: String
}

struct UpdateLocationRespons: Codable {
    let updatedAt: Date
}
