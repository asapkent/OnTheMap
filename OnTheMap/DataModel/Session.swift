//
//  Session.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/19/21.
//

import Foundation

struct Session: Codable {

    let account: account
    let session: session

}

struct account: Codable {
    let registered: Bool
    let key: String
}

struct session: Codable {
    let id: String
    let expiration: String
}
