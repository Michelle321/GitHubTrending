//
//  GithubTrendingService.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

struct GTService: GTSRequest {
    
    func makeRequest(from query:(String, String)) throws -> URLRequest {
        guard query.1.count > 0 else {
            throw RequestError.invalidQuery
        }

        guard var components = URLComponents(string: GTSConstant.apiEndPoint) else {
            throw RequestError.invalidApiEndPoint
        }
        components.queryItems = [URLQueryItem(name: "language", value: query.0),
                                 URLQueryItem(name: "since", value: String(query.1))]

        guard let url = components.url else {
            throw RequestError.invalidQuery
        }

        return URLRequest(url: url)
    }

    func parseResponse(data: Data) throws -> [ProjectDTO] {
        return try JSONDecoder().decode([ProjectDTO].self, from: data)
    }
}
