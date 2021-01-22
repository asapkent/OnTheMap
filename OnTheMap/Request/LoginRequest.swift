//
//  Request.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/20/21.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}
