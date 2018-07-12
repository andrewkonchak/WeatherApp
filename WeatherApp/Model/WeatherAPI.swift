//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/11/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class WeatherAPI {
    
    let weatherMod = WeatherModel.self
    
    enum Constants {
        static let baseUrlString = "http://api.openweathermap.org/data/2.5/"
        static let appID = "dc75601c3a328075e92872fbbc36b16e"
    }
    
    typealias CompletionHandler = (WeatherModel?) -> Void
    
    
    func fetchArticles(cityName: String, countryCode: String, completionHandler: @escaping CompletionHandler) {
        let url = Constants.baseUrlString + "weather?appid=\(Constants.appID)&q=\(cityName),\(countryCode)&units=metric"
        guard let stringURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: stringURL) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    let weatherDescription = try JSONDecoder().decode(self.weatherMod, from: data)
                    print(weatherDescription.name, weatherDescription.weather)
                    completionHandler(weatherDescription)
                    
                } catch let jsonError {
                    print("Error srializing json: ", jsonError)
                    completionHandler(nil)
                    
                }
            }
            } .resume()
        }
    
    func fetchCurrentWeather(lat: Double, long: Double, completionHandler: @escaping CompletionHandler) {
        let url = Constants.baseUrlString + "weather?appid=\(Constants.appID)&lat=\(lat)&lon=\(long)&units=metric"
        guard let stringURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: stringURL) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    let weatherDescription = try JSONDecoder().decode(self.weatherMod, from: data)
                    print(weatherDescription.name, weatherDescription.weather)
                    completionHandler(weatherDescription)
                    
                } catch let jsonError {
                    print("Error srializing json: ", jsonError)
                    completionHandler(nil)
                    
                }
            }
            } .resume()
    }
    
    func fetchIconData(code: String, completionHandler: @escaping (Data?) -> Void) {
        let urlString = "http://openweathermap.org/img/w/\(code).png"
        guard let url = URL(string: urlString) else {
            completionHandler(nil)
            return
        }
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            completionHandler(data)
        }
    }
}
