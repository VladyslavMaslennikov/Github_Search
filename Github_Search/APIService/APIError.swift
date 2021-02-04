//
//  APIError.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//

import Foundation

enum ApiError: Error {
    case failedToGetData
    case failedToDecodeRepository
}
