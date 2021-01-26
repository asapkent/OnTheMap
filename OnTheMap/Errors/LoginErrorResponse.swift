//
//  LoginErrorResponse.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/20/21.
//

import Foundation

struct LoginErrorResponse: Codable {
    
    let status: Int
    let error: String
}
extension LoginErrorResponse: LocalizedError {
     var errorDescription: Int {
        return status
    }
}
