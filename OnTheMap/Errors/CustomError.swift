//
//  CustomError.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/19/21.
//

import Foundation

struct CustomError {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
