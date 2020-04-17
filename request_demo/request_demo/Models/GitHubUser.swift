//
//  GitHubUser.swift
//  Request_demo
//
//  Created by Clara Tang on 22/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import Foundation

struct GitHubUser: Codable {
    var name: String

    enum CodingKeys: String, CodingKey {
        case name = "login"
    }

    public init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
    }
}
