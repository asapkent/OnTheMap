//
//  LocationResponseUpdated.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/19/21.
//

import Foundation

struct LocationResponseUpdated: Codable {
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updatedAt"
    }
}
