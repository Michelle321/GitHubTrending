//
//  RequestError.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case invalidQuery
    case invalidApiEndPoint
}

enum ResponseError: Error {
    case noData
    case parsingError
    case serverError
    case stubDataError
    case oldData
}

