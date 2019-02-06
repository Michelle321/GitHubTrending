//
//  GitHubTrendingServiceTests.swift
//  GitHubTrendsTests
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import XCTest
@testable import GitHubTrends

class GTServiceTests: XCTestCase {

    let service = GTService()

    struct Constants {
        static let mockQuery = "swift"
        static let trendingSince = TrendingSince.daily.rawValue
    }

    func testMakingURLRequest() throws {
        let urlRequest = try service.makeRequest(from: (Constants.mockQuery, Constants.trendingSince))
        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "github-trending-api.now.sh")
        XCTAssertEqual(urlRequest.url?.query, "language=swift&since=daily")
    }

    func testParsingResponse() {
        let bundle = Bundle(for: type(of: self))

        guard let path = bundle.path(forResource: "SwiftProjectsList", ofType: ".json") else {
            XCTFail("test response json file can not find")
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let dto = try service.parseResponse(data: data)
            XCTAssertEqual(dto.count, 25)
            XCTAssertEqual(dto[0].name, "LegibleError")
            XCTAssertEqual(dto[0].user[0].userName, "mxcl")
        } catch {
            XCTFail("test response json file can not open or format error")
        }
    }
}
