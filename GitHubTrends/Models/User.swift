//
//  User.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

struct User: Decodable{
    let avatarUrl: String
    let userName: String

    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar"
        case userName = "username"
    }
}
