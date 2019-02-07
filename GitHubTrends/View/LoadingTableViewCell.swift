//
//  LoadingTableViewCell.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-07.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell, ConfigurableTableViewCell {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activity.stopAnimating()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        activity.stopAnimating()
    }

    func configure(_ viewModel: CellViewModel) {
        activity.startAnimating()
    }
}
