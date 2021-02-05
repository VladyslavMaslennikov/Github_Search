//
//  RepoViewModel.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices
import RealmSwift

class SearchViewModel {
    private let cellId = "RepositoryCell"
    
    private let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
    private let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
    private let group = DispatchGroup()
    
    private let apiService = APIService.shared
    private var pageCount = 1
    
    private var repositories = BehaviorRelay<[Repository]>(value: [])
    private let disposeBag = DisposeBag()
    
    private var realmNotificationToken: NotificationToken?
    
    private var loadingInProgress = true
    
    init() { }
    
    //MARK: - Queues
    private func performRequest(group: DispatchGroup, keyword: String, page: Int) {
        guard !keyword.isEmpty else { return }
        group.enter()
        self.apiService.fetchRepositories(for: keyword, page: self.pageCount) { result in
            defer {
//                Thread.sleep(forTimeInterval: 1)
                group.leave()
            }
            switch result {
            case (.success(let catalog)):
                self.repositories.accept(self.repositories.value + catalog.items)
                print("Repositories successfully retrieved from page #\(self.pageCount).\n")
                self.pageCount += 1
            case (.failure(let error)):
                print(error)
            }
        }
    }
    
    private func fetchResults(keyword: String) {
        DispatchQueue.global().async {
            self.loadingInProgress = true
            self.queue1.async(group: self.group) {
                self.performRequest(group: self.group, keyword: keyword, page: self.pageCount)
            }
            self.group.wait()
            self.queue2.async(group: self.group) {
                self.performRequest(group: self.group, keyword: keyword, page: self.pageCount)
            }
            self.group.notify(queue: DispatchQueue.main) {
                self.loadingInProgress = false
            }
        }
    }
    
    func searchForRepositories(in text: String) {
        fetchResults(keyword: text)
    }
    
    func reset() {
        self.pageCount = 1
        self.repositories.accept([])
    }
    
    //MARK: - TableView methods
    func registerCell(for tableView: UITableView) {
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func returnCellCount() -> Int {
        return repositories.value.count
    }
    
    func returnCell(in tableView: UITableView, for indexPath: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! RepositoryCell
        let repo = repositories.value[indexPath]
        cell.repositoryTitle.text = repo.name
        cell.numberOfStarsTitle.text = "\(repo.stargazers_count)"
        return cell
    }
    
    //MARK: - Bindings
    func bindTableView(_ tableView: UITableView) {
        repositories.subscribe { _ in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    func bindSearchBar(_ searchBar: UISearchBar) {
        searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance) // wait 0.8 for changes
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                self?.reset()
                self?.searchForRepositories(in: text)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Supporting methods
    func openBrowser(controller: UIViewController, index: Int) {
        let urlString = repositories.value[index].html_url
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            controller.present(vc, animated: true)
        }
    }
    
    func checkIfLoadingInProgress() -> Bool {
        return loadingInProgress
    }
    
    //MARK: - Realm methods
    func subscribeToDatabaseUpdates(tableView: UITableView) {
        realmNotificationToken = RealmManager.createTableViewUpdateToken(for: tableView)
    }
    
    func invalidateRealmToken() {
        realmNotificationToken?.invalidate()
    }
    
    func addRepositoryToHistory(indexPath: Int) {
        let repo = repositories.value[indexPath]
        let rmRepo = RmRepository(id: repo.id, name: repo.name)
        RealmManager.addRepositoryToDatabase(rmRepo)
    }
}

