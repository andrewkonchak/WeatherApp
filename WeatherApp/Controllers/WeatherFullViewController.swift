//
//  WeatherFullViewController.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/18/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit



class WeatherFullViewController: UIViewController {
    
    var weatherTableView = MainTableViewController()
    var weatherFromCell: WeatherModel?
    var forecastViewModel: ForecastViewModel?
    var weatherApiModel = WeatherAPI()

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityImageLabel: UIImageView!
    @IBOutlet weak var cityDescLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var secondVisualEffect: UIVisualEffectView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    private let mapper = ForecastViewModelMapper()
    
    private var dataSource: [ForecastViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        secondVisualEffect.layer.cornerRadius = 10
        fullCityWeather()
        forecastCityWeather()
    }
    
    func fullCityWeather() {
        
        cityNameLabel.text = weatherFromCell?.name
        cityTempLabel.text = String(Int(weatherFromCell?.main.temp ?? 0)) + weatherTableView.celcius
        cityDescLabel.text = weatherFromCell?.weather.first?.description
        tempMinLabel.text = String(Int(weatherFromCell?.main.temp_min ?? 0)) + weatherTableView.celcius
        tempMaxLabel.text = String(Int(weatherFromCell?.main.temp_max ?? 0)) + weatherTableView.celcius
        
        self.weatherTableView.weatherData.fetchIconData(code: (weatherFromCell?.weather.first?.icon) ?? "" , completionHandler: { data in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.cityImageLabel.image = image
                }
            }
        })
    }
}

extension WeatherFullViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fullViewCell") as! WeatherFullTableViewCell
        
       let viewModel = dataSource[indexPath.row]
        
        
        cell.tempMaxFullViewCell.text = String(Int(viewModel.maxTemp)) + weatherTableView.celcius
        cell.tempMinFullViewCell.text = String(Int(viewModel.minTemp)) + weatherTableView.celcius
        cell.daysFullViewCell.text = viewModel.dayName
        
        self.weatherApiModel.fetchIconData(code: viewModel.icon, completionHandler: { data in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.imageFullViewCell.image = image
                }
            }
        })
        return cell
    }
}

private extension WeatherFullViewController {
    
    func forecastCityWeather() {
        weatherApiModel.fetchDailyWeather(cityName: weatherTableView.userDefaults.object(forKey: "city") as? String ?? "", countryCode: weatherTableView.userDefaults.object(forKey: "code") as? String ?? "") { forecastModel in
            guard let forecastModel = forecastModel else {
                self.dataSource.removeAll()
                self.tableView.reloadData()
                return
            }
            self.dataSource = self.mapper.makeViewModels(from: forecastModel)
            self.tableView.reloadData()
        }
    }
}
