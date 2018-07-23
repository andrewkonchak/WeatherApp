//
//  WeatherDateFormatter.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/23/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

extension Date {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    func dayName() -> String {
        return Date.dateFormatter.string(from: self)
    }
    
    func dayNumber() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func stardOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
}
