//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import SVProgressHUD

protocol WriteReviewViewControllerDelegate: AnyObject {
    func didPostReview()
}

class WriteReviewViewController: UIViewController {
    
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var textField: UITextField!
    weak var delegate: WriteReviewViewControllerDelegate?
    
    private var authInfo: AuthInfo!
    private var showId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationLook()
        setupSubmitButton()
        ratingView.delegate = self
    }
}

private extension WriteReviewViewController {
    
    func setupSubmitButton() {
        submitButton.layer.cornerRadius = 25
        submitButton.alpha = 0.5
        submitButton.isEnabled = false
    }
    
    @objc func didSelectClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupNavigationLook() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
        
        self.title = "Write a review"
    }
}

extension WriteReviewViewController: RatingViewDelegate {
    
    func didChangeRating(_ rating: Int) {
        submitButton.isEnabled = true
        submitButton.alpha = 1
        ratingView.rating = rating
    }
}

private extension WriteReviewViewController {
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let router = Router.postReview(
            review: CreateReview(
                rating: ratingView.rating,
                comment: textField.text ?? "",
                showId: showId), authInfo: authInfo)
        NetworkService
            .shared
            .service
            .request(router)
            .validate()
            .responseDecodable(of: ReviewResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(_):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self.delegate?.didPostReview()
                case .failure(_):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
                SVProgressHUD.dismiss(withDelay: 1)
            }
        
        didSelectClose(sender)
    }
}

extension WriteReviewViewController {
    
    func addAuthInfoAndShowId(authInfo: AuthInfo, showId: String) {
        self.authInfo = authInfo
        self.showId = showId
    }
}
