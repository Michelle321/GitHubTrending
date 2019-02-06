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

    private var currentSearchTerm = "swift"

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GTMainViewModel(with: { [weak self] (success, error) in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }else {
                print(error.debugDescription)
            }
        })

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = [TrendingSince.daily.rawValue,
                                                        TrendingSince.weekly.rawValue,
                                                        TrendingSince.monthly.rawValue]
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search language"

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
        guard let project = viewModel?.viewModel(at: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectsListTableViewCell.self),
                                                 for:indexPath) as? ProjectsListTableViewCell
                  else { return UITableViewCell() }

            cell.configure(project)
            return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetailofProject" {
            if let viewController = segue.destination as? DetailViewController {
                let selectedRow = tableView.indexPathForSelectedRow!.row
                viewController.project = viewModel?.viewModel(at: selectedRow)
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
