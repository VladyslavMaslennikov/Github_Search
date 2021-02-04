//
//  URLBuilder.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import Foundation

struct URLBuilder {
    private let text: String
    private let page: Int
    private var queryItems: [URLQueryItem] = []
    private var urlRequest: URLRequest?
    
    init(text: String, page: Int) {
        self.text = text
        self.page = page
        self.queryItems = self.createQueryItems()
    }
    
    private func createQueryItems() -> [URLQueryItem] {
        let queryParameters = [
            "q": text,
            "page": "\(page)",
            "per_page": "15",
            "sort": "stars",
            "order": "desc"
        ]
        let queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return queryItems
    }
    
    func buildURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/search/repositories"
        urlComponents.queryItems = self.queryItems
        
        guard let url = urlComponents.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
}
