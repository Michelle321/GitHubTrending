//
//  CellViewModel.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-07.
//  Copyright © 2019 Michelle. All rights reserved.
//

import Foundation

typealias CellReuseIndentifier = String
enum CellType: CellReuseIndentifier {
    case error = "ErrorTableViewCell"
    case loading = "LoadingTableViewCell"
    case projects = "ProjectsListTableViewCell"
}

protocol RowCellViewModelValue {}

struct CellViewModel {
    let cellType: CellType
    let cellValue: RowCellViewModelValue?
}
