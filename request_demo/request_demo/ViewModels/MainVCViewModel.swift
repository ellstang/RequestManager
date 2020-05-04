//
//  MainVCViewModel.swift
//  Request_demo
//
//  Created by Clara Tang on 22/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import Foundation

final class MainVCViewModel {

    var refreshingStatusHandler: ((Bool) -> Void)?
    var updateGitHubUsersHandler: (() -> Void)?
    var networkErrorHandler: ((Error) -> Void)?
    var exceedRateLimitHandler: (() -> Void)?

    private(set) var isRefreshing: Bool = false {
        didSet {
            refreshingStatusHandler?(isRefreshing)
        }
    }

    private(set) var gitHubUsers: [GitHubUser] = [] {
        didSet {
            updateGitHubUsersHandler?()
        }
    }

    func fetchUsers(completion: @escaping () -> Void) {
        self.isRefreshing = true

        RequestManager.shared.getGitHubUsers(since: gitHubUsers.count) { [weak self] result in
            guard let `self` = self else { return }
            self.isRefreshing = false
            
            switch result {
            case .success(let users):
                self.gitHubUsers += users
            case .failure(let error):
                switch error {
                case .exceedRateLimitError:
                    self.exceedRateLimitHandler?()
                case .otherErrors:
                    self.networkErrorHandler?(error)
                }
            }
        }
    }
}

