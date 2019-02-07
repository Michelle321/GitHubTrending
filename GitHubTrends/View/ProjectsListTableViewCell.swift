//
//  ProjectsListTableViewCell.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-06.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit

class ProjectsListTableViewCell: UITableViewCell, ConfigurableTableViewCell {
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(_ viewModel: CellViewModel) {
        guard let project = viewModel.cellValue as? Project else { return }

        projectTitleLabel.text = project.name
        numberOfStarsLabel.text = String(project.starsCount)
        descriptionLabel.text = project.description
    }
}
