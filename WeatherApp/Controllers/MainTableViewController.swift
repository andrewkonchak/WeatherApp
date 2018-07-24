//
//  MainTableViewController.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/12/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit
import CoreLocation

class MainTableViewController: UITableViewController {
    
    enum Constants {
        static let defaultCoordinates = CLLocationCoordinate2D(latitude: 49.839683, longitude: 24.029717)
    }
    
    let locationManager = CLLocationManager()
    let celcius = "°"
    let userDefaults = UserDefaults.standard
    
    var weatherData = WeatherAPI()
    var weatherModel = [WeatherModel]()
    var cityTextField = ""
    var countryTextfield = ""
    var cityNameTextField: UITextField?
    var countryCodeTextField: UITextField?
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherLocations: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBAction func alertButtonItem(_ sender: UIBarButtonItem) {
        alertController()
    }
    
    @IBAction func tapGestureRecognizer(_ sender: Any) {
       //performSegue(withIdentifier: "currentWeatherFullView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.layer.cornerRadius = 15
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        addNewCityWeather()
        refreshCurrentWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherTableViewCell
        
        cell.weatherDescriptionCell.text = self.weatherModel[indexPath.row].weather.first?.description
        cell.weatherCityCell.text = self.weatherModel[indexPath.row].name
        cell.weatherTemperatureCell.text = String(Int(weatherModel[indexPath.row].main.temp)) + self.celcius
        self.weatherData.fetchIconData(code: weatherModel[indexPath.row].weather.first!.icon, completionHandler: { data in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.weatherIconCell.image =  image
                }
            }
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.weatherModel.remove(at: indexPath.row)
            self.userDefaults.removeObject(forKey: "city")
            self.userDefaults.removeObject(forKey: "code")
            tableView.reloadData()
            success(true)
        })
        deleteAction.image = UIImage(named: "close-circular-button-of-a-cross")
        deleteAction.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "weatherFullView", sender: weatherModel[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherFullView" {
            let weatherViewTo = segue.destination as! WeatherFullViewController
            weatherViewTo.weatherFromCell = sender as? WeatherModel
        }
//        else if segue.identifier == "currentWeatherFullView" {
//            let secondView = segue.destination as! WeatherFullViewController
//        }
    }
}


// MARK: - private
private extension MainTableViewController {
    
    func refreshCurrentWeather() {
        let coordinate = locationManager.location?.coordinate ?? Constants.defaultCoordinates
        weatherData.fetchCurrentWeather(lat: coordinate.latitude, long: coordinate.longitude) { weatherModel in
            guard let weatherModel = weatherModel else {
                // error
                return
            }
            self.weatherTemperature.text = String(Int(weatherModel.main.temp)) + self.celcius
            self.weatherLocations.text = weatherModel.name
            self.weatherDescription.text = weatherModel.weather.first?.description
            
            self.weatherData.fetchIconData(code: weatherModel.weather.first!.icon, completionHandler: { data in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.weatherIcon.image = image
                    }
                }
            })
        }
    }
    
    func addNewCityWeather() {
        weatherData.fetchCurrentWeather(cityName: userDefaults.object(forKey: "city") as? String ?? "", countryCode: userDefaults.object(forKey: "code") as? String ?? "") { weatherModel in
            guard let weatherModel = weatherModel else {
                // error
                return
            }
            
            self.weatherModel.append(WeatherModel(name: weatherModel.name, weather: weatherModel.weather, main: weatherModel.main))
            self.tableView.reloadData()
        }
    }
}

extension MainTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        // todo: update wheather in header
        print(location.coordinate.latitude, location.coordinate.longitude)
        refreshCurrentWeather()
    }
}

extension MainTableViewController {
    
    func alertController() {
        
        let alertController = UIAlertController(title: "Add New Country", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nameTextField)
        alertController.addTextField(configurationHandler: countryTextField)
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: self.saveHendler)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func nameTextField(textField: UITextField) {
        cityNameTextField = textField
        cityNameTextField?.placeholder = "City name example: New York"
    }
    
    func countryTextField(textField: UITextField) {
        countryCodeTextField = textField
        countryCodeTextField?.placeholder = "Country code example: us"
    }
    
    func saveHendler(alert: UIAlertAction) {
        userDefaults.set(cityNameTextField?.text, forKey: "city")
        userDefaults.set(countryCodeTextField?.text, forKey: "code")
        cityTextField = (cityNameTextField?.text) ?? ""
        countryTextfield = (countryCodeTextField?.text) ?? ""
        addNewCityWeather()
    }
}




