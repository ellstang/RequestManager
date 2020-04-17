//
//  MainViewController.swift
//  Request_demo
//
//  Created by Clara Tang on 21/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var gitHubUserTableView: UITableView!

    private var viewModel: MainVCViewModel = MainVCViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareViewModel()

        fetchData()
    }

}

extension MainViewController {
    private func prepareView() {
        gitHubUserTableView.delegate = self
        gitHubUserTableView.dataSource = self

        let cellNib: UINib = UINib(nibName: Config.nibName, bundle: nil)
        gitHubUserTableView.register(cellNib, forCellReuseIdentifier: Config.cellId)

        gitHubUserTableView.rowHeight = Config.cellHeight

        navigationItem.title = Config.title
    }

    private func prepareViewModel() {
        viewModel.refreshingStatusHandler = { isRefreshing in
            // implement loading animation
            if isRefreshing {

            } else {

            }
        }

        viewModel.updateGitHubUsersHandler = { [weak self] in
            self?.gitHubUserTableView.reloadData()
        }

        viewModel.networkErrorHandler = { [weak self] error in
            self?.displayErrorAlert(title: Config.alertTitle, message: Config.networkErrorMsg, actionTitle: Config.alertActionTitle)
        }

        viewModel.exceedRateLimitHandler = { [weak self] in
            self?.displayErrorAlert(title: Config.alertTitle, message: Config.exceedRateLimitErrorMsg, actionTitle: Config.alertActionTitle)
        }
    }

    private func fetchData() {
        viewModel.fetchUsers {}
    }

    private func displayErrorAlert(title: String, message: String, actionTitle: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: actionTitle, style: .default)
        alert.addAction(action)

        self.present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Config.storyboardName, bundle: nil)
        if let directMessageVC = storyboard.instantiateViewController(identifier: Config.viewControllerId) as? DirectMessageViewController {
            self.navigationController?.pushViewController(directMessageVC, animated: true)
        }
    }

}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.cellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gitHubUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()

        if let userCell = tableView.dequeueReusableCell(withIdentifier: Config.cellId, for: indexPath) as? GitHubUserTableViewCell {
            let user = viewModel.gitHubUsers[indexPath.row]
            userCell.setUpCell(user: user)
            cell = userCell
        }

        return cell
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fetchData()
    }
}

extension MainViewController {
    private enum Config {
        static let title: String = "GitHub DM"
        static let alertTitle: String = "Error"
        static let networkErrorMsg: String = "Connection error"
        static let exceedRateLimitErrorMsg: String = "Exceeded rate limit per hour. Please try again later"
        static let alertActionTitle: String = "confirm"

        static let nibName: String = "GitHubUserTableViewCell"
        static let cellId: String = "GitHubUserTableViewCell"
        static let storyboardName: String = "Main"
        static let viewControllerId: String = "DirectMessageViewController"

        static let cellHeight: CGFloat = 90.0
    }
}
