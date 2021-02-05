//
//  HistoryViewModel.swift
//  Github_Search
//
//  Created by Vladyslav on 04.02.2021.
//

import UIKit
import RealmSwift

class HistoryVM {
    private let cellId = "RepositoryCell"
    private var token: NotificationToken?
    private var repositories = RealmManager.getRepositories()
    init() {}
    
    func registerCell(for tableView: UITableView) {
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func returnCell(in tableView: UITableView, for indexPath: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! RepositoryCell
        let repo = repositories[indexPath]
        cell.repositoryTitle.text = repo.name
        cell.numberOfStarsTitle.text = repo.dateSeen.convertToString()
        cell.starImage.isHidden = true
        return cell
    }
    
    func returnCellCount() -> Int {
        return repositories.count
    }
    
    func subscribeToDBUpdates(for tableView: UITableView) {
        token = RealmManager.createTableViewUpdateToken(for: tableView)
    }
    
    func invalidateRealmToken() {
        token?.invalidate()
    }
}
