//
//  MessageViewController.swift
//  ChatApp
//
//  Created by Caner Karabulut on 13.11.2023.
//

import UIKit

private let reuseIdentifier = "MessageCell"

protocol MessageViewControllerProtocol: AnyObject {
    func showChatViewController(_ messageViewController: MessageViewController, user: UserModel)
}

class MessageViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: MessageViewControllerProtocol?
    
    private var endUsers = [EndUser]()
    private let tableView = UITableView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEndUsers()
        style()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEndUsers()
    }
    //MARK: - Service
    private func fetchEndUsers() {
        UserService.fetchEndUsers { endUsers in
            self.endUsers = endUsers
            self.tableView.reloadData()
        }
    }
}
//MARK: - Helpers
extension MessageViewController {
    private func style() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
//MARK: - UITableViewDelegate & Datasource
extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.endUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.endUser = endUsers[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.showChatViewController(self, user: endUsers[indexPath.row].user)
    }
}
