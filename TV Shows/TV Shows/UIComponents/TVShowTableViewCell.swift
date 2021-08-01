//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2021..
//

import Foundation
import UIKit

final class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!

// MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

// MARK: - Configure

extension TVShowTableViewCell {

    func configure(with text: String) {
        titleLabel.text = text
    }
}
