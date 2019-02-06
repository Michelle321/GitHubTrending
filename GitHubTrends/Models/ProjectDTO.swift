//
//  Project.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

struct ProjectDTO: Decodable {
    let name: String
    let description: String
    let starsCount: Int
    let forksCount: Int
    let locationUrl: String
    let user: [User]

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case starsCount = "stars"
        case forksCount = "forks"
        case locationUrl = "url"
        case user = "builtBy"
    }
}
