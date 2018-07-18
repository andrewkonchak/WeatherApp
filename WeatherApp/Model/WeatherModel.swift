//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/11/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

struct WeatherModel: Decodable {
    
    struct Main: Decodable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Decodable {
    
    let description: String
    let main: String
    let icon: String
}


