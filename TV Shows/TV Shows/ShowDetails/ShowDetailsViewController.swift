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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getReviews()
        addReviewButton.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
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
            
            cell.configure(descriptionText: show.description ?? "Description missing", noOfReviews: show.noOfReviews, averageReview: show.averageRating ?? 0)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShowDetailsTableViewCellTypeTwo.self),
                for: indexPath
            ) as! ShowDetailsTableViewCellTypeTwo
            
            let review = reviews[indexPath.row - 1]
            
            cell.configure(reviewText: review.comment, username: review.user.email, rating: review.rating)
            
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
                switch response.result {
                case .success(let reviewsResponse):
                    self?.reviews = reviewsResponse.reviews
                    self?.tableView.reloadData()
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
        navigationController.title = "Write a review"
        navigationController.navigationBar.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        present(navigationController, animated: true)
    }
}

extension ShowDetailsViewController: WriteReviewViewControllerDelegate {
    func didPostReview() {
        getReviews()
    }
}


