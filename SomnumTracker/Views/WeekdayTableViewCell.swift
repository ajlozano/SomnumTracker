//
//  WeekdayTableViewCell.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 24/4/23.
//

import UIKit

class WeekdayTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var weekdayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weekdayLabel.textColor = .darkGray
        weekdayLabel.font = weekdayLabel.font.withSize(9)
    }
    
    func setup(weekday: String){
        weekdayLabel.text = weekday;
    }
}



