//
//  Result.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
