//
//  DateFormatter+Ext.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 01.07.2023.
//

import Foundation
extension Date {
    func dateFromString(_ createdAt: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = createdAt {
            return dateFormatter.date(from:date) ?? Date()
        } else {
            return nil
        }
    }
    
    func stringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter.string(from: self)
    }

}
