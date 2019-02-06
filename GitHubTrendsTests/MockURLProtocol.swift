//
//  MockURLProtocol.swift
//  GitHubTrendsTests
//
//  Created by Yunjuan Li on 2019-02-06.
//  Copyright © 2019 Michelle. All rights reserved.
//

import XCTest

class MockURLProtocol: URLProtocol {

    lazy var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data)) = {
        request in
        guard let data = self.getStubData() else {
            XCTFail("can not get stub data from testing")
            throw NSError.init(domain: "can not get stub data from testing", code: 1001, userInfo: nil)
        }
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (response, data)
    }

    override class func canInit(with request: URLRequest) -> Bool{
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        do {
            let (reponse, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: reponse, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        //nothing to test here
    }

    func getStubData() -> Data? {
        let bundle = Bundle(for: type(of: self))

        guard let path = bundle.path(forResource: "SwiftProjectsList", ofType: ".json") else {
            XCTFail("test response json file can not find")
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return data
        } catch {
            XCTFail("test response json file can not open or format error")
        }
        return nil
    }

}
