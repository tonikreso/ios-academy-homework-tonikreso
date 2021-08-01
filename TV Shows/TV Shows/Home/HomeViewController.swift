//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 21.07.2021..
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var authInfo: AuthInfo!
    private var items: [Show] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getShows()
        // Do any additional setup after loading the view.
    }
}

//MARK: -UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

        cell.configure(with: items[indexPath.row].title)

        return cell
    }
}

//MARK: -Private Utility

private extension HomeViewController {
    
    func getShows() {
        let router = Router.getShows(authInfo: authInfo)
        NetworkService
            .shared
            .service
            .request(router)
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let showsResponse):
                    self.items = showsResponse.shows
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.errorDescription as Any)
                }
            }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func navigateToShowDetailsViewController(row: Int) {
        let storyboard = UIStoryboard.init(name: "ShowDetails", bundle: nil)
        let showDetailsVC = storyboard.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
        showDetailsVC.addShowAndAuthInfo(show: items[row], authInfo: authInfo)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        self.navigationController?.show(showDetailsVC, sender: self)
    }
}

//MARK: -Public Utility
extension HomeViewController {
    
    func addAuthInfo(authInfo: AuthInfo) {
        self.authInfo = authInfo
    }
}

