//
//  RequestErrors.swift
//  Request_demo
//
//  Created by Clara Tang on 24/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import Foundation

enum BaseError: Error {
    case networkError(error: Error)
    case serverError
    case clientError(statusCode: Int)
}

enum GitHubRequestError: Error {
    case exceedRateLimitError
    case otherErrors
}
