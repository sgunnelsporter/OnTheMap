//
//  UserModel.swift
//  OnTheMap
//
//  Created by Sarah Gunnels Porter on 6/27/20.
//  Copyright © 2020 Gunnels Porter. All rights reserved.
//

import Foundation


//MARK: User Info
struct UserSession {
    static var userId: String = ""
    static var firstName: String = ""
    static var lastName: String = ""
    static var nickname: String = ""
}

//MARK: Map Locations
struct MapPins {
    static var mapPins = [LocationResults]()
}
