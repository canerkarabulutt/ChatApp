//
//  NewMessageViewController.swift
//  ChatApp
//
//  Created by Caner Karabulut on 13.11.2023.
//

import UIKit

protocol NewMessageViewControllerProtocol: AnyObject {
    func goToChatView(user: UserModel)
}

private let reuseIdentifier = "NewMessage"

class NewMessageViewController: UIViewController {
    //MARK: - Properties
    
    weak var delegate: NewMessageViewControllerProtocol?
    
    private let tableView = UITableView()
    private var users = [UserModel]()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
            }
        }
    }

//MARK: - Helpers
extension NewMessageViewController {
    private func style() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.goToChatView(user: users[indexPath.row])
    }
}
