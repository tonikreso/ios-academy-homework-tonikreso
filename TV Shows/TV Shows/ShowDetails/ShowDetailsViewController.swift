//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    @IBOutlet private weak var addReviewButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    private var reviews: [Review] = []
    private var show: Show!
    private var authInfo: AuthInfo!
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildRefreshControl()
        setupTableView()
        getReviews()
        addReviewButton.layer.cornerRadius = 25
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    
}

extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowDetailsTableViewCellTypeOne.self),
                for: indexPath
            ) as! ShowDetailsTableViewCellTypeOne
            
            cell.configure(descriptionText: show.description ?? "Description missing", noOfReviews: show.noOfReviews, averageReview: show.averageRating ?? 0, imageUrl: show.imageUrl)
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowDetailsTableViewCellTypeTwo.self),
                for: indexPath
            ) as! ShowDetailsTableViewCellTypeTwo
            
            let review = reviews[indexPath.row - 1]
            
            cell.configure(reviewText: review.comment, username: review.user.email, rating: review.rating, imageUrl: review.user.imageUrl ?? "")
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension ShowDetailsViewController {
    
    func addShowAndAuthInfo(show: Show, authInfo: AuthInfo) {
        self.show = show
        self.authInfo = authInfo
    }
}

private extension ShowDetailsViewController {
    
    func getReviews() {
        let router = Router.getReviews(showId: self.show.id, authInfo: authInfo)
        NetworkService
            .shared
            .service
            .request(router)
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let reviewsResponse):
                    self.reviews = reviewsResponse.reviews
                    self.tableView.reloadData()
                case .failure(_):
                    break
                    //print(error.errorDescription as Any)
                }
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = refreshControl
    }
    
    func buildRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshReviews), for: .valueChanged)
    }
    
    @objc func refreshReviews(_ sender: AnyObject) {
        self.getReviews()
    }
}


//MARK: -IBActions
private extension ShowDetailsViewController {
    
    @IBAction func writeReviewButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "WriteReview", bundle: nil)
        let writeReviewVC = storyboard.instantiateViewController(withIdentifier: "WriteReviewVC") as! WriteReviewViewController
        writeReviewVC.addAuthInfoAndShowId(authInfo: authInfo, showId: show.id)
        writeReviewVC.delegate = self
        let navigationController = UINavigationController(rootViewController:
        writeReviewVC)
        navigationController.navigationBar.tintColor = .primary
        present(navigationController, animated: true)
    }
}

extension ShowDetailsViewController: WriteReviewViewControllerDelegate {
    func didPostReview() {
        getReviews()
    }
}


