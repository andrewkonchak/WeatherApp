//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/20/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct ForecastModel: Decodable {
    
    let list: [List]
    
    struct Temp: Decodable {
        let min: Double
        let max: Double
    }
    
    struct List: Decodable {
        let temp: Temp
        let dt: Int
    }
}
