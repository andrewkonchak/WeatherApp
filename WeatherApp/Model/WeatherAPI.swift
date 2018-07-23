//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/11/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class WeatherAPI {
    
    enum Constants {
        static let baseUrlString = "http://api.openweathermap.org/data/2.5"
        static let appID = "dc75601c3a328075e92872fbbc36b16e"
    }
    
    typealias WeatherCompletion = (WeatherModel?) -> Void
    typealias ForecastCompletion = (ForecastModel?) -> Void
    
    
    func fetchCurrentWeather(cityName: String, countryCode: String, completionHandler: @escaping WeatherCompletion) {
        let urlString = "\(Constants.baseUrlString)/weather"
        let parameters: [String: Any] = [
            "q": parameter(fromCityName: cityName, countryCode: countryCode)
        ]
        let url = constructURL(from: urlString, parameters: parameters)!
        request(url: url, completionHandler: completionHandler)
    }
    
    func fetchCurrentWeather(lat: Double, long: Double, completionHandler: @escaping WeatherCompletion) {
        let urlString = "\(Constants.baseUrlString)/weather"
        let url = constructURL(from: urlString, parameters: ["lat": lat, "lon": long])!
        request(url: url, completionHandler: completionHandler)
    }
    
    func fetchDailyWeather(cityName: String, countryCode: String, completionHandler: @escaping ForecastCompletion) {
        
        let urlString = "\(Constants.baseUrlString)/forecast"
        let parameters: [String: Any] = [
            "q": parameter(fromCityName: cityName, countryCode: countryCode),
        ]
        let url = constructURL(from: urlString, parameters: parameters)!
        request(url: url, completionHandler: completionHandler)
    }
    
    func constructURL(from string: String, parameters: [String: Any]) -> URL? {
        
        guard var components = URLComponents(string: string) else {
            return nil
        }
        
        var allParameters = standartParameters()
        for (key, value) in parameters {
            allParameters.updateValue("\(value)", forKey: key)
        }
        
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in allParameters {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
        return components.url
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

// MARK: - private helpers
private extension WeatherAPI {
    
    func request<T: Decodable>(url: URL, completionHandler: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let data = data else {
                    completionHandler(nil)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(result)
                    
                } catch {
                    completionHandler(nil)
                }
            }
            } .resume()
    }
    
    func standartParameters() -> [String: String] {
        return ["appid": Constants.appID, "units": "metric"]
    }
    
    func parameter(fromCityName cityName: String, countryCode: String) -> String {
        return "\(cityName),\(countryCode)"
    }
}
