//
//  RealmDatabase.swift
//  Github_Search
//
//  Created by Vladyslav on 04.02.2021.
//

import UIKit
import RealmSwift

@objcMembers class RmRepository: Object {
    dynamic var name: String = ""
    dynamic var id: Int = 0
    dynamic var dateSeen: Date = Date.distantPast
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
        self.dateSeen = Date()
    }
}

public struct RealmProvider {
    private let configuration: Realm.Configuration

    private init() {
        let documentsUrl = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask,
              appropriateFor: nil, create: false)
            .appendingPathComponent("github_search.realm")
        
        var configuration: Realm.Configuration = .defaultConfiguration
        configuration.fileURL = documentsUrl
        configuration.deleteRealmIfMigrationNeeded = true
        configuration.schemaVersion = 1
        configuration.objectTypes = [
            RmRepository.self
        ]
        self.configuration = configuration
    }

    var realm: Realm {
        return try! Realm(configuration: configuration)
    }
    
    public static var appRealm: RealmProvider = {
        let realmProvider = RealmProvider()
        return realmProvider
    }()
}

class RealmManager {
    static func getRepositories() -> Results<RmRepository> {
        let realm = RealmProvider.appRealm.realm
        return realm.objects(RmRepository.self).sorted(byKeyPath: "dateSeen", ascending: false)
    }
    
    static func addRepositoryToDatabase(_ repo: RmRepository) {
        let realm = RealmProvider.appRealm.realm
        let history = realm.objects(RmRepository.self)
        let duplicates = history.filter({ $0.id == repo.id })
        //1. check whether repo is already saved
        if !duplicates.isEmpty {
            return
        }
        //2. remove last repo from history if there are 20 repos
        if history.count == 20 {
            if let lastRepo = history.sorted(byKeyPath: "dateSeen", ascending: false).last {
                removeRepositoryFromDatabase(lastRepo)
            }
        }
        //3. add new repo to history
        try! realm.write {
            realm.add(repo)
        }
    }
    
    static func removeRepositoryFromDatabase(_ repo: RmRepository) {
        let realm = RealmProvider.appRealm.realm
        try! realm.write {
            realm.delete(repo)
        }
    }
    
    static func createTableViewUpdateToken(for tableView: UITableView) -> NotificationToken {
        let realm = RealmProvider.appRealm.realm
        let reloadTableView = {
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        let barcodes = realm.objects(RmRepository.self)
        return barcodes.observe { results in
            switch results {
            case .update(_, _, _, _):
                reloadTableView()
            case .initial(_):
                reloadTableView()
            default: break
            }
        }
    }
    
    static func checkWhetherRepositoryInDatabseExists(id: Int) -> Bool {
        let realm = RealmProvider.appRealm.realm
        let repoExists = realm.objects(RmRepository.self).filter({ $0.id == id })
        return repoExists.isEmpty ? true : false
    }
}
