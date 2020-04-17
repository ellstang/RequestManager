//
//  GitHubUserTableViewCell.swift
//  Request_demo
//
//  Created by Clara Tang on 22/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import UIKit

class GitHubUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    // MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension GitHubUserTableViewCell {
    func setUpCell(user: GitHubUser) {
        self.userImageView.contentMode = .scaleAspectFit
        self.userImageView.image = UIImage(named: "icon")
        self.userNameLabel.text = "@" + user.name
    }
}

extension GitHubUserTableViewCell {
    private func prepareCell() {

        self.userNameLabel.textColor = .darkText
        self.userNameLabel.font = UIFont.systemFont(ofSize: 18.0,
                                                    weight: .medium)
    }
}
