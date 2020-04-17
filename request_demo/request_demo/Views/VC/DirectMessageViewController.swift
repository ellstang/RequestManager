//
//  DirectMessageViewController.swift
//  Request_demo
//
//  Created by Clara Tang on 23/03/2020.
//  Copyright © 2020 ChiaLingTang. All rights reserved.
//

import UIKit

class DirectMessageViewController: UIViewController {

    // cache cell heights to inhence scrolling
    // [IndexPath.row : cellHeight]
    private var cellHeightCacheDict: [Int: CGFloat] = [:]
    private var lastSentText: String = ""

    var messages: [Message] = []
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var inputBackgroundView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var enterInputButton: UIButton!
    @IBOutlet weak var inputBackgroundviewBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    @IBAction func sendInputText(_ sender: UIButton) {
        if !inputTextView.text.isEmpty {
            messages.append(Message(content: inputTextView.text,
                                    direction: .isFromMe))
            messageTableView.reloadData()
            lastSentText = inputTextView.text
            inputTextView.text = ""
            inputTextView.resignFirstResponder()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                RequestManager.shared.fetchNewPost(index: String(self?.messages.count ?? 0)) { response in
                    switch response {
                    case .success:
                        let doubledText: String = (self?.lastSentText ?? "") + (self?.lastSentText ?? "")
                        self?.messages.append(Message(content: doubledText, direction: .isFromOthers))
                        self?.messageTableView.reloadData()
                    case .failure:()
                    }
                }
            }
        }
    }
}

extension DirectMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeight: CGFloat = cellHeightCacheDict[indexPath.row] {
            return cellHeight
        } else {
            let autoHeight: CGFloat = UITableView.automaticDimension
            cellHeightCacheDict[indexPath.row] = autoHeight
            return autoHeight
        }
    }
}

extension DirectMessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        if let directMessageCell = tableView.dequeueReusableCell(withIdentifier: Config.cellId, for: indexPath) as? DirectMsgTableViewCell {
            let message: Message = messages[indexPath.row]
            directMessageCell.updateCell(message: message)
            cell = directMessageCell
        }
        
        return cell
    }

}

extension DirectMessageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(x: 0, y: -Config.keyboardPadding, width: self.view.frame.width, height: self.view.frame.height)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
}

extension DirectMessageViewController {
    private func prepareView() {
        messageTableView.delegate = self
        messageTableView.dataSource = self

        let nib: UINib = UINib(nibName: Config.cellId, bundle: nil)
        messageTableView.register(nib,
                                  forCellReuseIdentifier: Config.cellId)
        // set a default height
        messageTableView.estimatedRowHeight = Config.cellHeight
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.allowsSelection = false

        inputTextView.delegate = self
        inputTextView.layer.cornerRadius = 4.0
        inputTextView.clipsToBounds = true

        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismissKeyboard))
        messageTableView.addGestureRecognizer(viewTapGesture)

        addKeyboardObserver()
    }

    @objc private func tapToDismissKeyboard() {
        view.endEditing(true)
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.4

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            self.view.frame = CGRect(x: 0, y: -Config.keyboardPadding, width: self.view.frame.width, height: self.view.frame.height)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.4

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }

}

extension DirectMessageViewController {
    private enum Config {
        static let cellId: String = "DirectMsgTableViewCell"

        static let cellHeight: CGFloat = 60.0
        static let keyboardPadding: CGFloat = 340.0
    }
}
