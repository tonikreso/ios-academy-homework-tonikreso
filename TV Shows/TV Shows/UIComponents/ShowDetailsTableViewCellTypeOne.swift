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
    

// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.isEnabled = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        numberOfReviewsLabel.text = nil
        reviewLabel.text = nil
        showImageView.image = nil
    }
}

// MARK: - Configure

extension ShowDetailsTableViewCellTypeOne {

    func configure(descriptionText: String, noOfReviews: Int, averageReview: Double) {
        descriptionLabel.text = descriptionText
        numberOfReviewsLabel.text = "\(noOfReviews) reviews, \(averageReview) average rating"
        reviewLabel.text = "Review"
        showImageView.image = UIImage(named: "splash-top-left")
        ratingView.setRoundedRating(averageReview)
    }
}
