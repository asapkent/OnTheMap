//
//  DemandLocationResponse.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/19/21.
//

import Foundation

struct DemandLocationResponse: Codable {
    struct PostLocationResponse: Codable {
        let createdAt: String?
        let objectId: String?
    }
}
