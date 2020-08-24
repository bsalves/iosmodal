//
//  ApiManager.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation

enum ApiError: String, Error {
    case unknowReason
    case serviceFailure
    case emptyData
    case invalidKey
    case disconnected = "The Internet connection appears to be offline."
}

enum ApiKey: String {
    case repositoryList = "repositories"
    case repositorySearch = "search/repositories"
    case repositoryDetails = "repos/"
}

class ApiManager {

    private init() { /* makes constructor private */ }

    static let shared = ApiManager()

    func fetch(resource: ApiKey, path: String, success: @escaping (Data) -> Void, failure: @escaping (ApiError) -> Void) {
        do {
            let url = try self.prepareUrl(resource, withPath: path)
            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                if (error != nil) {
                    failure(ApiError(rawValue: error?.localizedDescription ?? "") ?? ApiError.serviceFailure)
                    return
                }
                guard let data = data else {
                    failure(.emptyData)
                    return
                }
                success(data)
            }
            task.resume()
        } catch let error as ApiError {
            failure(error)
        } catch {
            failure(ApiError.unknowReason)
        }
    }

    func fetch(resource: ApiKey, query: [URLQueryItem]?, success: @escaping (Data) -> Void, failure: @escaping (ApiError) -> Void) {
        do {
            var urlComponent = try self.prepareUrl(resource)
            urlComponent.queryItems = query
            guard let url = urlComponent.url else {
                failure(.unknowReason)
                return
            }

            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                if (error != nil) {
                    failure(ApiError(rawValue: error?.localizedDescription ?? "") ?? ApiError.serviceFailure)
                    return
                }
                guard let data = data else {
                    failure(.emptyData)
                    return
                }
                success(data)
            }
            task.resume()
        } catch let error as ApiError {
            failure(error)
        } catch {
            failure(ApiError.unknowReason)
        }
    }

    private func prepareUrl(_ key: ApiKey, withPath: String) throws -> URL {
        let baseUrl = "https://api.github.com/"
        if let url = URL(string: baseUrl + key.rawValue + withPath) {
            return url
        } else {
            throw ApiError.invalidKey
        }
    }

    private func prepareUrl(_ key: ApiKey) throws -> URLComponents {
        let baseUrl = "https://api.github.com/"
        if let url = URLComponents(string: baseUrl + key.rawValue) {
            return url
        } else {
            throw ApiError.invalidKey
        }
    }
}
