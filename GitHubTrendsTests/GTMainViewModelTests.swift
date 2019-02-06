//
//  GitHubTrendsTests.swift
//  GitHubTrendsTests
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import XCTest
@testable import GitHubTrends

class GTMainViewModelTests: XCTestCase {

    typealias ResponseDeterminer = (URLResponse?) -> Bool

    func createRequestLoaderWithDeterminer(_ determiner: @escaping ResponseDeterminer) -> GTSRequestLoader<GTService> {
        let request = GTService()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        return GTSRequestLoader(apiRequest: request, urlSession: urlSession, shouldProcessResponse: determiner)
    }

    func testSuccessFetchProjectResult(){

        var viewModel: GTMainViewModel?

        let exp = expectation(description: "fetch 25 projects response")
        let complicationBlock: (Bool, Error?) -> Void = { (success, error) in
            guard let vm = viewModel else {
                XCTFail("Can not initialize viewModel")
                return
            }
            XCTAssertTrue(success)
            XCTAssertEqual(vm.viewModelsCount, 25)
            XCTAssertEqual(vm.viewModel(at: 0)?.name, "LegibleError")
            exp.fulfill()
        }

        viewModel = GTMainViewModel(with: complicationBlock)
        viewModel?.loader = createRequestLoaderWithDeterminer({ (response) -> Bool in
            return true
        })

        viewModel?.fetchTrendingResult(for: "swift")
        waitForExpectations(timeout: 5.0, handler: nil)
       
    }

    func testShouldNotProcessProjectResult(){

        var viewModel: GTMainViewModel?

        let exp = expectation(description: "fetch 25 projects response but no process viewModel")
        let complicationBlock: (Bool, Error?) -> Void = { (success, error) in
            guard let vm = viewModel else {
                XCTFail("Can not initialize viewModel")
                return
            }
            XCTAssertFalse(success)
            XCTAssertEqual(vm.viewModelsCount, 0)
            exp.fulfill()
        }

        viewModel = GTMainViewModel(with: complicationBlock)
        viewModel?.loader = createRequestLoaderWithDeterminer({ (response) -> Bool in
            return false
        })

        viewModel?.fetchTrendingResult(for: "swift")
        waitForExpectations(timeout: 5.0, handler: nil)

    }

}
