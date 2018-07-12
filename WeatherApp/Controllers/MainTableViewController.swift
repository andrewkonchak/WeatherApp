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
        static let defaultCoordinates = CLLocationCoordinate2D(latitude: 47.4925, longitude: 19.0513)
    }

    var weatherData = WeatherAPI()
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherLocations: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    let locationManager = CLLocationManager()
    
    @IBAction func alertButtonItem(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add New Country", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Country name 'Lviv'"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Country code 'ua'"
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        refreshCurrentWeather()

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
            self.weatherTemperature.text = String(Int(weatherModel.main.temp))
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



