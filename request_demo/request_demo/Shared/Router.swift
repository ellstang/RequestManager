//
//  Router.swift
//  Request_demo
//
//  Created by Clara Tang on 22/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import Foundation

enum HTTPMethod {
    static let get  = "GET"
    static let post = "POST"
}

typealias RouterConfig = (httpMethod: String, parameters: [String: String], path: String)

enum Router {

    case getGitHubUsers(since: String)
    case getPostAtIndex(index: String)

    var config: RouterConfig {
        switch self {
        case .getGitHubUsers(let since):
            return RouterConfig(httpMethod: HTTPMethod.get,
                                parameters: ["since": since],
                                path: "/users")

        case .getPostAtIndex(let index):
            return RouterConfig(httpMethod: HTTPMethod.post,
                                parameters: ["index": index],
                                path: "/dummyPath")
        }
    }
}
