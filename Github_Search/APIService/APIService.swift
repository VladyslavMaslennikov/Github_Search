//
//  APIService.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let session: URLSession
    
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchRepositories(for text: String, page: Int, completion: @escaping ((Result<RepositoryCatalog, ApiError>) -> ())) {
        let urlBuilder = URLBuilder(text: text, page: page)
        guard let request = urlBuilder.buildURLRequest() else { return }
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.failedToGetData))
            }
            if let data = data {
                guard let catalog: RepositoryCatalog = APIDecoder.decodeRepository(data: data) else {
                    completion(.failure(.failedToDecodeRepository))
                    return }
                completion(.success(catalog))
            }
        }
        task.resume()
    }
}
