//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/23/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    
    let dayName: String
    let minTemp: Double
    let maxTemp: Double
    let icon: String
}


struct ForecastViewModelMapper {
    
    func makeViewModels(from response: ForecastModel) -> [ForecastViewModel] {
        typealias DayRecord = (minTemp: Double, maxTemp: Double)
        
        var groupedDays: [Date: DayRecord] = [:]
        let currentDayStart = Date().stardOfDay()
        
        for listModel in response.list {
            
            let key = Date(timeIntervalSince1970: listModel.dt).stardOfDay()
            guard key != currentDayStart else {
                continue
            }
            
            let maxTemp = listModel.main.temp_max
            let minTemp = listModel.main.temp_min
            let currentRecord = groupedDays[key] ?? (0, 0)
            var newRecord = currentRecord
            
            if maxTemp > newRecord.maxTemp {
                newRecord.maxTemp = maxTemp
            } else if minTemp > newRecord.minTemp {
                newRecord.minTemp = minTemp
            }
            groupedDays[key] = newRecord
        }
        
        for (startOfDay, record) in groupedDays {
            print(startOfDay.dayName(), record.minTemp, record.maxTemp)
        }
        
        let sortedGroups = groupedDays.sorted { a, b in a.key < b.key }
        return sortedGroups.map { return ForecastViewModel(dayName: $0.key.dayName(), minTemp: $0.value.minTemp, maxTemp: $0.value.maxTemp, icon: "50d") }
    }
}
