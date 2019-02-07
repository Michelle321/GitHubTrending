//
//  ConfigurableTableViewCell.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-07.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit

protocol ConfigurableTableViewCell {
    func configure(_ viewModel: CellViewModel)
}

extension UITableView {
    func register(cellTypes: [CellType]) {
        for cellType in cellTypes {
            let reuseableIndentifier = cellType.rawValue
            self.register(UINib(nibName: reuseableIndentifier, bundle: nil), forCellReuseIdentifier: reuseableIndentifier)
        }
    }
}
