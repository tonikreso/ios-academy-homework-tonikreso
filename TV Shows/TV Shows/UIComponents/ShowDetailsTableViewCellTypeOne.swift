//
//  ShowDetailsTableViewCellTypeOne.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import Foundation
import UIKit

final class ShowDetailsTableViewCellTypeOne: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var ratingViewHeightConstraint: NSLayoutConstraint!
    

// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.isEnabled = false
        showImageView.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        numberOfReviewsLabel.text = nil
        reviewLabel.text = nil
    }
}

// MARK: - Configure

extension ShowDetailsTableViewCellTypeOne {

    func configure(descriptionText: String, noOfReviews: Int, averageReview: Double, imageUrl: String) {
        descriptionLabel.text = descriptionText
        if noOfReviews == 0 {
            numberOfReviewsLabel.text = "No reviews yet"
            numberOfReviewsLabel.textAlignment = .center
        } else {
            numberOfReviewsLabel.text = "\(noOfReviews) reviews, \(averageReview) average rating"
            numberOfReviewsLabel.textAlignment = .natural
            ratingViewHeightConstraint.constant = 50
        }
        
        reviewLabel.text = "Review"
        showImageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "ic-show-placeholder-rectangle")
        )
        ratingView.setRoundedRating(averageReview)
    }
}
