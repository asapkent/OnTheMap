//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/19/21.
//

import Foundation

struct StudentLocation: Codable {
    var uniqueKey: String?
    var firstName: String?
    var lastName:  String?
    var mapString: String?
    var mediaURL:  String?
    var latitude:  Float?
    var longitude: Float?
}
