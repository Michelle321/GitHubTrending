//
//  GithubProjectDataController.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

class GTMainViewModel {

    private var currentRequestQuery: (String,String)?

    private var viewModels: [Project] = []
    private var completionBlock: (Bool, Error?) -> Void

    init(with completionBlock: @escaping (Bool, Error?) -> Void) {
        self.completionBlock = completionBlock
    }

    lazy var loader = GTSRequestLoader(apiRequest: GTService(), shouldProcessResponse: { [weak self] (response) -> Bool in
        guard let self = self else { return false }
        return self.shouldProcessResponse(response)
    })

    var viewModelsCount: Int {
        return viewModels.count
    }

    func viewModel(at index: Int) -> Project? {
        guard index >= 0 && index < viewModelsCount else { return nil }
        return viewModels[index]
    }

    func fetchTrendingResult(for query: String, with trending: String = TrendingSince.daily.rawValue) {
        currentRequestQuery = (query, trending)
        loader.loadAPTRequest(requestData: (query, trending)) { [weak self] (projectsListResult) in
            guard let self = self else { return }
            switch projectsListResult {
                case .success(let projects):
                    self.viewModels = projects.map{ Project.init($0) }
                    self.completionBlock(true, nil)
                case .failure(let error):
                    self.completionBlock(false, error)
            }
        }
    }

    func shouldProcessResponse(_ response: URLResponse?) -> Bool {
        guard let url = response?.url,
              let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = urlComponent.queryItems,
              let currentQuery = currentRequestQuery
            else { return false }

        var queryIsSame = false
        var trendingIsSame = false

        for query in queryItems {
            if query.name == "language" {
                if let queryValue = query.value, currentQuery.0 == queryValue {
                    queryIsSame = true
                }
            }

            if query.name == "since" {
                if let queryValue = query.value, currentQuery.1 == queryValue {
                    trendingIsSame = true
                }
            }
        }
        return queryIsSame && trendingIsSame
    }
}
