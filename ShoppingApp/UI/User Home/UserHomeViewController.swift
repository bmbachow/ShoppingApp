//
//  UserHomeViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/25/21.
//

import UIKit

class UserHomeViewController: UserTabViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let userNotSignedInViewController = UserNotSignedInViewController()
    
    private var shouldHideUserNotSignedInViewController: Bool {
        return self.user != nil
    }
    
    private var memberSinceString: String {
        guard let user = self.user else { return "Member since ?" }
        guard let registeredDate = user.registeredDate else { return "Member since ?" }
        return "Member since " + DateFormatter.standardDate.string(from: registeredDate)
    }
    
    lazy private var productDetailMainTableViewCell: UserHomeMainTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserHomeMainTableViewCell") as? UserHomeMainTableViewCell else {
            fatalError("Unable to dequeue UserHomeMainTableViewCell")
        }
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addChild(userNotSignedInViewController)
        self.view.addSubview(userNotSignedInViewController.view)
        self.tableView.register(UINib(nibName: "UserHomeMainTableViewCell", bundle: nil), forCellReuseIdentifier: "UserHomeMainTableViewCell")
        NSLayoutConstraint.activate([
            userNotSignedInViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            userNotSignedInViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            userNotSignedInViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            userNotSignedInViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNotSignedInViewController.view.isHidden = self.shouldHideUserNotSignedInViewController
    }
    
    override func userChanged() {
        guard self.tableView != nil else { return }
        super.userChanged()
        self.refreshData()
        self.userNotSignedInViewController.view.isHidden = self.shouldHideUserNotSignedInViewController
    }
    
    func refreshData() {
        self.productDetailMainTableViewCell.nameLabel.text = (user?.firstName ?? "") + " " + (user?.lastName ?? "")
        self.productDetailMainTableViewCell.memberSinceLabel.text = self.memberSinceString
        self.tableView.reloadData()
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.productDetailMainTableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
}
