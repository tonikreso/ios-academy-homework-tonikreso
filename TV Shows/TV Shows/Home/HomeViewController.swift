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
    private var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getShows()
        // Do any additional setup after loading the view.
    }
}

//MARK: -UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
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

        cell.configure(with: items[indexPath.row])

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
                switch response.result {
                case .success(let showsResponse):
                    for show in showsResponse.shows {
                        self?.items.append(show.title)
                    }
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension

        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: -Public Utility
extension HomeViewController {
    
    func addAuthInfo(authInfo: AuthInfo) {
        self.authInfo = authInfo
    }
}

