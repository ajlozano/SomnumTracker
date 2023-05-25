//
//  CustomColors.swift
//  SomnumTracker
//
//  Created by Toni Lozano Fernández on 20/4/23.
//

import UIKit

extension UIColor {
    // Background logo color light : #DAE2E3
    // Background logo colo dark: #464649
    public static var customLight: UIColor {
        return UIColor(red: 218/255, green: 226/255, blue: 227/255, alpha: 1)
    }
    public static var customDark: UIColor {
        return UIColor(red: 70/255, green: 70/255, blue: 73/255, alpha: 1)
    }
    public static var customBlue: UIColor {
        return UIColor(red: 85/255, green: 133/255, blue: 198/255, alpha: 1)
    }
    public static var customBlueLessAlpha: UIColor {
        return UIColor(red: 85/255, green: 133/255, blue: 198/255, alpha: 0.5)
    }
    public static var customBlueLight: UIColor {
        return UIColor(red: 191/255, green: 212/255, blue: 233/255, alpha: 0.5)
    }
}
