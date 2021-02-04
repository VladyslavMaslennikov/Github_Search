//
//  RepoModel.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import Foundation

struct RepositoryCatalog: Decodable {
    let items: [Repository]
}

struct Repository: Decodable, Equatable {
   let name: String
   let id: Int
   let html_url: String
   let stargazers_count: Int
}
