//
//  StationTableViewCell.swift
//  StibLifts
//
//  Created by michael moldawski on 1/11/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    var station: Station?
    {
        didSet
        {
            self.stationNameLabel.text = station?.name
            self.elevatorStatus.isOn = (station?.ascenseur)!
            if self.elevatorStatus.isOn == false
            {
                self.backgroundView?.backgroundColor = UIColor.red
            }
        }
        
    }
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var elevatorStatus: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
