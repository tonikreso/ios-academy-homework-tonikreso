//
//  ShowDetailsTableViewCellTypeTwo.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import Foundation
import UIKit

final class ShowDetailsTableViewCellTypeTwo: UITableViewCell {
    
    @IBOutlet private weak var reviewLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var ratingView: RatingView!

// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.isEnabled = false
        ratingView.configure(withStyle: .small)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reviewLabel.text = nil
        usernameLabel.text = nil
        profileImageView.image = nil
    }
}

// MARK: - Configure

extension ShowDetailsTableViewCellTypeTwo {

    func configure(reviewText: String, username: String, rating: Int) {
        reviewLabel.text = reviewText
        usernameLabel.text = username
        profileImageView.image = UIImage(named: "ic-profile-placeholder")
        ratingView.setRoundedRating(Double(rating))
    }
}
