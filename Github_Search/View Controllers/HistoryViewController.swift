//
//  HistoryViewController.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = HistoryVM()
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.subscribeToDBUpdates(for: tableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.invalidateRealmToken()
    }
}

//MARK: - TableView Setup
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        viewModel.registerCell(for: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.returnCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.returnCell(in: tableView, for: indexPath.row)
    }
}
