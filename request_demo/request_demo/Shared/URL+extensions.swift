//
//  URL+extensions.swift
//  Request_demo
//
//  Created by Clara Tang on 22/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import Foundation

public extension URL {

    /// Returns an URL with designated queryItems
    /// - Parameter queryItems: queryItem key-value pairs
    func addQueryItems(with queryItems: [String: String]) -> URL? {
        var urlComponents = URLComponents(string: self.absoluteString)
        let urlQueryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value)}
        urlComponents?.queryItems = urlQueryItems

        return urlComponents?.url
    }
}
