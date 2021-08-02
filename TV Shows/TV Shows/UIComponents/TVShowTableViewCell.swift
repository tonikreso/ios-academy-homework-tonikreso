//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2021..
//

import Foundation
import UIKit
import Kingfisher

final class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var showImageView: UIImageView!

// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        showImageView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        showImageView.image = UIImage()
    }
}

// MARK: - Configure

extension TVShowTableViewCell {

    func configure(text: String, imageUrl: String) {
        titleLabel.text = text
        showImageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "ic-show-placeholder-vertical")
        )
    }
}
