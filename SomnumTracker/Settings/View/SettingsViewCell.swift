//
//  SettingsViewCell.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    let relativeFontConstant: CGFloat = 0.036
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.backgroundColor = .clear
    }

    func setup(icon: UIImage ,title: String, timeView: UIView? = nil, action: UIView, screenWidth: CGFloat) {
        iconImage.image = icon
        titleLabel.font = titleLabel.font.withSize(screenWidth * relativeFontConstant)
        titleLabel.text = title
        if let tView = timeView {
            pickerView.addSubview(tView)
        } 
        actionView.addSubview(action)
    }

}
