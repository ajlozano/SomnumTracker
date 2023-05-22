//
//  SettingsViewCell.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.backgroundColor = .clear
        titleLabel.textColor = .black
        actionView.backgroundColor = .clear
    }

    func setup(icon: UIImage ,title: String, action: UIView) {
        iconImage.image = icon
        titleLabel.text = title
        actionView.addSubview(action)
    }

}
