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
    func getGitHubUsers(since: Int, completion: @escaping (Result<[GitHubUser], GitHubRequestError>) -> Void) {
        let router: Router = .getGitHubUsers(since: String(since))
        fetchData(router: router) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data,
                        let users = try? self?.decoder.decode([GitHubUser].self, from: data) {
                        completion(.success(users))
                    } else {
                        completion(.success([GitHubUser]()))
                    }
                    
                case .failure(let error):
                    switch error {
                    case .clientError(let statusCode):
                        if statusCode == Config.exceedRateLimitCode {
                            completion(.failure(.exceedRateLimitError))
                        } else {
                            completion(.failure(.otherErrors))
                        }
                    default:
                        completion(.failure(.otherErrors))
                    }
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
//
//        fetchData(router: router) { [weak self] result in
//            switch result {
//            case .success(let data):
//                if let data = data,
//                    let message = try? self?.decoder.decode(String.self, from: data) {
//                    DispatchQueue.main.async {
//                        completion(.success(message))
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(.success(nil))
//                    }
//                }
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}

extension RequestManager {
    private func fetchData(router: Router, completion: @escaping (Result<Data?, BaseError>) -> Void) {

        guard let url = URL(string: Config.baseURLStr + router.config.path) else {
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
            
            let statusCode: Int = urlResponse.statusCode
            switch statusCode {
                case Config.successStatusCodeRange:
                    completion(.success(responseData))
                case Config.clientErrorCodeRange:
                    completion(.failure(.clientError(statusCode: statusCode)))
                case Config.serverErrorCodeRange:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.networkError(error: NSError())))
            }
        }

        task.resume()
    }
}

extension RequestManager {
    private enum Config {
        static let baseURLStr: String = "https://api.github.com"

        static let successStatusCodeRange: ClosedRange<Int> = 200...299
        static let clientErrorCodeRange: ClosedRange<Int> = 400...499
        static let serverErrorCodeRange: ClosedRange<Int> = 500...599
        static let exceedRateLimitCode: Int = 403
    }
}
