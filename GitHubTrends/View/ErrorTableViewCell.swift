//
//  ErrorTableViewCell.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-07.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit

class ErrorTableViewCell: UITableViewCell, ConfigurableTableViewCell {

    @IBOutlet weak var errorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        errorLabel.text = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        errorLabel.text = nil
    }

    func configure(_ viewModel: CellViewModel) {
        guard let errorModel = viewModel.cellValue as? ErrorCellViewModel else { return }
        errorLabel.text = errorModel.errorMessage
        errorLabel.textColor = errorModel.textColor
    }
    
}
