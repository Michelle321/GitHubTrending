//
//  MainViewController.swift
//  GitHubTrends
//
//  Created by Yunjuan Li on 2019-02-04.
//  Copyright © 2019 Michelle. All rights reserved.
//

import UIKit

enum TrendingSince: String {
    case daily
    case weekly
    case monthly
}

class MainViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel: GTMainViewModel?

    private var currentSearchTerm = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellTypes: [.loading, .error])

        viewModel = GTMainViewModel(with: { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = [TrendingSince.daily.rawValue,
                                                        TrendingSince.weekly.rawValue,
                                                        TrendingSince.monthly.rawValue]
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search trending language"

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }

        definesPresentationContext = true
        self.tableView.tableFooterView = UIView()
        searchController.searchBar.text = currentSearchTerm
        viewModel?.fetchTrendingResult(for: currentSearchTerm)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.viewModelsCount ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.viewModel(at: indexPath.row) else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellType.rawValue, for:indexPath)

        if let cell = cell as? ConfigurableTableViewCell {
            cell.configure(cellViewModel)
        }

        return cell
    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "viewDetailofProject" && viewModel?.canPerformSegue() == true {
            return true
        }
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetailofProject" {
            if let viewController = segue.destination as? DetailViewController {
                let selectedRow = tableView.indexPathForSelectedRow!.row
                guard let projectModel = viewModel?.viewModel(at: selectedRow).cellValue as? Project else { return }
                viewController.project = projectModel
            }
        }
    }

}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if let searchTerm = searchController.searchBar.text {
            let scope = searchBar.scopeButtonTitles![selectedScope]
            viewModel?.fetchTrendingResult(for: searchTerm, with: scope)
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text {
            if searchTerm == currentSearchTerm {
                return
            }
            currentSearchTerm = searchTerm
            let scope = searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
            viewModel?.fetchTrendingResult(for: searchTerm, with: scope)
        }
    }
}
