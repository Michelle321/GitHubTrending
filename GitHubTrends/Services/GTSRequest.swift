//
//  GitHubRequest.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

protocol GTSRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType

    func makeRequest(from: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

class GTSRequestLoader<T: GTSRequest> {

    typealias ResponseActionDetermine = (URLResponse?)->Bool
    let apiRequest: T
    let urlSession: URLSession
    let shouldProcessResponse: ResponseActionDetermine

    init(apiRequest: T, urlSession: URLSession = .shared, shouldProcessResponse: @escaping ResponseActionDetermine) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
        self.shouldProcessResponse = shouldProcessResponse
    }

    func loadAPTRequest(requestData: T.RequestDataType, completionHandler: @escaping (Result<T.ResponseDataType>) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if self.shouldProcessResponse(response) {
                    guard let responseData = data, responseData.count > 0 else {
                        completionHandler(Result.failure(error ?? ResponseError.noData))
                        return
                    }
                    do {
                        let parsedResponse = try self.apiRequest.parseResponse(data: responseData)
                        completionHandler(Result.success(parsedResponse))
                    }catch {
                        completionHandler(Result.failure(ResponseError.parsingError))
                    }
                }else {
                    completionHandler(Result.failure(ResponseError.oldData))
                }
            }.resume()
        }catch {
            return completionHandler(Result.failure(error))
        }
    }
}
