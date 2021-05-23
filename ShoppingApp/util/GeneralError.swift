//
//  GeneralError.swift
//  QuizApp
//
//  Created by Robert Olieman on 5/18/21.
//

import Foundation

struct GeneralError: Error, LocalizedError {
    private let details: String
    public var errorDescription: String? {
        "Error: \(self.details)"
    }
    init(details: String) {
        self.details = details
    }
}


