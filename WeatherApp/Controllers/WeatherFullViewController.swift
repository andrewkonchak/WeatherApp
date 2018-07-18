//
//  WeatherFullViewController.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/18/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class WeatherFullViewController: UIViewController {
    
    
    @IBOutlet weak var cityImageLabel: UIImageView!
    @IBOutlet weak var cityDescLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var firstVisualEffect: UIVisualEffectView!
    @IBOutlet weak var secondVisualEffect: UIVisualEffectView!
    
    var weatherTableView = MainTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstVisualEffect.layer.cornerRadius = 15
        secondVisualEffect.layer.cornerRadius = 15
        fullCityWeather()
    }
    
    func fullCityWeather() {
        weatherTableView.weatherData.fetchArticles(cityName: weatherTableView.cityNameTextField?.text ?? "" , countryCode: weatherTableView.countryCodeTextField?.text ?? "") { weatherModel in
            guard let weatherModel = weatherModel else {
                // error
                return
            }
            
            self.cityTempLabel.text = String(Int(weatherModel.main.temp)) + self.weatherTableView.celcius
            self.cityNameLabel.text = weatherModel.name
            self.cityDescLabel.text = weatherModel.weather.first?.description

            self.weatherTableView.weatherModel.append(WeatherModel(name: weatherModel.name, weather: weatherModel.weather, main: weatherModel.main))
        }
    }
}

