//
//  SearchViewController.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Controller properties
    private let searchBar = UISearchBar()
    private var viewModel = ViewModel()
    private let activityIndicator = ActivityIndicator()

    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        activityIndicator.addIndicator(to: self)
        
    }
}

//MARK: - SearchBar Setup
extension SearchViewController: UISearchBarDelegate {
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for repositories..."
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        viewModel.bindSearchBar(searchBar)
    }
}

//MARK: - TableView Delegate & DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.returnCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.returnCell(in: tableView, for: indexPath.row)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        viewModel.registerCell(for: tableView)
        viewModel.bindTableView(tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.addRepositoryToHistory(indexPath: indexPath.row)
        viewModel.openBrowser(controller: self, index: indexPath.row)
    }
}

//MARK: - ScrollView pull down to refresh
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        activityIndicator.triggerUpdateBySwipe(for: scrollView) { [weak self] in
            guard let text = self?.searchBar.text else { return }
            viewModel.searchForRepositories(in: text)
        }
    }
}
