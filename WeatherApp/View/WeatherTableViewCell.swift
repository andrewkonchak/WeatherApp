//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/16/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherCityCell: UILabel!
    @IBOutlet weak var weatherDescriptionCell: UILabel!
    @IBOutlet weak var weatherTemperatureCell: UILabel!
    @IBOutlet weak var weatherIconCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            weatherView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
