//
//  ContactsViewCell.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 22/5/23.
//

import UIKit

class ContactsViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var linkLabel: UILabel!
    var linkPath: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.backgroundColor = .clear
    }

    func setup(linkTitle: String, path: String) {
        linkLabel.text = linkTitle
        linkPath = path
    }
}
