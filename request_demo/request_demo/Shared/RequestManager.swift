//
//  RequestManager.swift
//  Request_demo
//
//  Created by Clara Tang on 22/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import Foundation

final class RequestManager {

    static let shared: RequestManager = RequestManager()

    private init() {}

    private let decoder: JSONDecoder = JSONDecoder()


    /// Fetch GitHub users with start index
    /// - Parameters:
    ///   - since: since user at {index}
    ///   - completion: completion handler
    func getGitHubUsers(since: Int, completion: @escaping (Result<[GitHubUser], RequestError>) -> Void) {
        let router: Router = .getGitHubUsers(since: String(since))
        fetchData(router: router) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    if let users = try? self?.decoder.decode([GitHubUser].self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(users))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.success([GitHubUser]()))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    /// Fetch new post at certain index
    /// - Parameters:
    ///   - index: assigned index
    ///   - completion: completion handler
    func fetchNewPost(index: String, completion: @escaping (Result<String?, Error>) -> Void) {
        completion(.success(""))
        /*
         This is just a dummy post
        */
//        let router: Router = .getPostAtIndex(index: index)

//        fetchData(router: router) { [weak self] result in
//            switch result {
//            case .success(let data):
//                if let data = data {
//                    if let message = try? self?.decoder.decode(String.self, from: data) {
//                        DispatchQueue.main.async {
//                            completion(.success(message))
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            completion(.success(nil))
//                        }
//                    }
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}

extension RequestManager {
    private func fetchData(router: Router, completion: @escaping (Result<Data?, RequestError>) -> Void) {
        let baseURL: String = "https://api.github.com"

        guard let url = URL(string: baseURL + router.config.path) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = router.config.httpMethod
        request.url = request.url?.addQueryItems(with: router.config.parameters)

        let task = URLSession.shared.dataTask(with: request) { responseData, response, error in
            guard error == nil,
                let urlResponse = response as? HTTPURLResponse else  {
                completion(.failure(.networkError(error: error ?? NSError())))
                return
            }

            switch urlResponse.statusCode {
                case Config.successStatusCodeRange:
                    completion(.success(responseData))
                case Config.exceedRateLimitCode:
                    completion(.failure(.exceedRateLimitError))
                default:
                    completion(.failure(.networkError(error: NSError())))
            }
        }

        task.resume()
    }
}

extension RequestManager {
    private enum Config {
        static let successStatusCodeRange: ClosedRange<Int> = 200...299
        static let exceedRateLimitCode: Int = 403
    }
}
