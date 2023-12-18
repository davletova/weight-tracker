//
//  Date+FormatDate.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 18.12.2023.
//

import Foundation

extension Date {
    func formatDayMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLL"
        let stringDate = dateFormatter.string(from: self)
        return stringDate
    }
    
    func formatFullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        return dateFormatter.string(from: self)
    }
}
