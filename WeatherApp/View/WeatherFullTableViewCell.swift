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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(tempMin: Int, tempMax:Int, day: String) {
        self.daysFullViewCell.text = day
        self.tempMinFullViewCell.text = String(tempMin)
        self.tempMaxFullViewCell.text = String(tempMax)
    }
    

}
