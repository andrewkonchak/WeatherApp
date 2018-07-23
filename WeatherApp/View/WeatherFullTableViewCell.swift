//
//  WeatherFullTableViewCell.swift
//  WeatherApp
//
//  Created by Andrii Konchak on 7/19/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class WeatherFullTableViewCell: UITableViewCell {

    @IBOutlet weak var cellVisualEffect: UIVisualEffectView!
    @IBOutlet weak var daysFullViewCell: UILabel!
    @IBOutlet weak var imageFullViewCell: UIImageView!
    @IBOutlet weak var tempMinFullViewCell: UILabel!
    @IBOutlet weak var tempMaxFullViewCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellVisualEffect.layer.cornerRadius = 10
    }
    
    func configureCell(tempMin: String, tempMax: String, day: String, icon: String) {
        
        self.tempMinFullViewCell.text = tempMin
        self.tempMaxFullViewCell.text = tempMax
        self.daysFullViewCell.text = day
    }
}
