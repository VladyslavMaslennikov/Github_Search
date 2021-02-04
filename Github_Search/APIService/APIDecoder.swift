//
//  APIDecoder.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import Foundation

struct APIDecoder {
    static func decodeRepository<T>(data: Data) -> T? where T: Decodable {
        guard let repo = try? JSONDecoder().decode(T.self, from: data) else {
            print("Unable to decode repository catalog.\nRequest limit might have reached."); return nil
        }
        return repo
    }
}
