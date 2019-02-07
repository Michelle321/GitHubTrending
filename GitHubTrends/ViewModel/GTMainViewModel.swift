//
//  GithubProjectDataController.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit

class GTMainViewModel {

    private var currentRequestQuery: (String,String)?
    private var projectsModel: [Project] = []
    private var completionBlock: () -> Void
    private var isLoading = false
    private var errorMessage: String?

    private let defaultErrorMessage = "Sorry, we are not able to get the trending result now"

    init(with completionBlock: @escaping () -> Void) {
        self.completionBlock = completionBlock
    }

    lazy var loader = GTSRequestLoader(apiRequest: GTService(), shouldProcessResponse: { [weak self] (response) -> Bool in
        guard let self = self else { return false }
        return self.shouldProcessResponse(response)
    })

    func canPerformSegue() -> Bool {
        guard isLoading == false,
            projectsModel.count > 0 else { return false }
        return true
    }

    var viewModelsCount: Int {
        guard isLoading == false else { return 1 }
        return projectsModel.count > 0 ? projectsModel.count : 1
    }

    func viewModel(at index: Int) -> CellViewModel {
        guard isLoading == false else {
            return CellViewModel(cellType: .loading, cellValue: nil)
        }

        guard index >= 0 && index < projectsModel.count else {
            let errorModel = ErrorCellViewModel(textColor: UIColor.black, errorMessage: errorMessage ?? defaultErrorMessage)
            return CellViewModel(cellType: .error, cellValue: errorModel)
        }

        return CellViewModel(cellType: .projects, cellValue: projectsModel[index])
    }

    func fetchTrendingResult(for query: String, with trending: String = TrendingSince.daily.rawValue) {
        isLoading = true
        completionBlock()
        currentRequestQuery = (query, trending)
        loader.loadAPTRequest(requestData: (query, trending)) { [weak self] (projectsListResult) in
            guard let self = self else { return }
            self.isLoading = false
            switch projectsListResult {
                case .success(let projects):
                    self.projectsModel = projects.map{ Project.init($0) }
                    self.completionBlock()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.projectsModel = []
                    self.completionBlock()
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
