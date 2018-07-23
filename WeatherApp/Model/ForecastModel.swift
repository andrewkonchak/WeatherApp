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
    
    struct Weather: Decodable {
        let icon: String
    }
    
    struct Main: Decodable {
        let temp_min: Double
        let temp_max: Double
    }
    
    struct List: Decodable {
        let main: Main
        let dt: Double
        let weather: [Weather]
    }
}
