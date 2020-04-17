//
//  DirectMsgTableViewCell.swift
//  Request_demo
//
//  Created by Clara Tang on 22/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import UIKit

enum MessageDirection {
    case isFromMe
    case isFromOthers
}

class DirectMsgTableViewCell: UITableViewCell {

    @IBOutlet private weak var bubbleImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var bubbleImageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bubbleImageViewLeadingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
    }


    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

extension DirectMsgTableViewCell {
    private func prepareCell() {
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        messageLabel.textColor = .white
    }
}

extension DirectMsgTableViewCell {
    func updateCell(message: Message) {
        messageLabel.text = message.content
        messageLabel.sizeToFit()

        bubbleImageView.image = message.direction == .isFromMe ? Config.rightBubbleImg : Config.lefttBubbleImg
    }
}

extension DirectMsgTableViewCell {
    private enum Config {
        static let rightBubbleImg: UIImage? = UIImage(named: "right_bubble")
        static let lefttBubbleImg: UIImage? = UIImage(named: "left_bubble")

        static let messageLeadingOrTrailingPadding: CGFloat = 30.0
    }
}
