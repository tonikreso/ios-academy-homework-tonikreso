//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 21.07.2021..
//

import UIKit
import SVProgressHUD

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var authInfo: AuthInfo!
    private var items: [Show] = []
    private var notificationToken: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getShows()
        setupProfileDetailsItem()
        subscribeToLogoutNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(notificationToken!)
    }
}

//MARK: -UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToShowDetailsViewController(row: indexPath.row)
    }
}

//MARK: -UITableViewDatasource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TVShowTableViewCell.self),
            for: indexPath
        ) as! TVShowTableViewCell

        cell.configure(text: items[indexPath.row].title, imageUrl: items[indexPath.row].imageUrl)

        return cell
    }
}

//MARK: -Private Utility

private extension HomeViewController {
    
    func getShows() {
        SVProgressHUD.show()
        let router = Router.getShows(authInfo: authInfo)
        NetworkService
            .shared
            .service
            .request(router)
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                SVProgressHUD.dismiss(withDelay: 1)
                switch response.result {
                case .success(let showsResponse):
                    self.items = showsResponse.shows
                    self.tableView.reloadData()
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(_):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }
    
    func setupTableView() {
        //tableView.estimatedRowHeight = 110
        //tableView.rowHeight = UITableView.automaticDimension

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func navigateToShowDetailsViewController(row: Int) {
        let storyboard = UIStoryboard.init(name: "ShowDetails", bundle: nil)
        let showDetailsVC = storyboard.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
        showDetailsVC.addShowAndAuthInfo(show: items[row], authInfo: authInfo)
        self.navigationController?.navigationBar.tintColor = .primary
        self.navigationController?.show(showDetailsVC, sender: self)
    }
    
    @objc func profileDetailsActionHandler() {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        profileVC.addAuthInfo(authInfo: authInfo)
        let navigationController = UINavigationController(rootViewController:
        profileVC)
        navigationController.navigationBar.tintColor = .primary
        present(navigationController, animated: true)
    }
    
    func setupProfileDetailsItem() {
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler)
        )
        profileDetailsItem.tintColor = .primary
        navigationItem.rightBarButtonItem = profileDetailsItem
    }
    
    func subscribeToLogoutNotification() {
        notificationToken = NotificationCenter .default
        .addObserver(
            forName: Notification.Name(rawValue: "Logout"),
            object: nil,
            queue: nil,
            using: { [weak self] _ in
                guard let self = self else { return }
                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.navigationController?.setViewControllers([loginViewController], animated:
               true)
            }
        )
    }
    
}

//MARK: -Public Utility
extension HomeViewController {
    
    func addAuthInfo(authInfo: AuthInfo) {
        self.authInfo = authInfo
    }
}

