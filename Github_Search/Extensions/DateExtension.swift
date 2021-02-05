//
//  DateExtension.swift
//  Github_Search
//
//  Created by Vladyslav on 05.02.2021.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
//        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
