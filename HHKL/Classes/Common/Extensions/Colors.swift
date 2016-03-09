//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UIColor {

    static func hhkl_mainColor() -> UIColor {
        return UIColor.flatBlackColorDark()
    }

    static func hhkl_secondaryColor() -> UIColor {
        return UIColor.flatWhiteColor()
    }

    static func hhkl_tertiaryColor() -> UIColor {
        return UIColor.flatWhiteColorDark()
    }

    static func hhkl_yellowFlatColor() -> UIColor {
        return UIColor(red: 252/255, green: 186/255, blue: 4/255, alpha: 1.0)
    }

    static func hhkl_redFlatColor() -> UIColor {
        return UIColor(red: 186/255, green: 45/255, blue: 11/255, alpha: 1.0)
    }

    static func hhkl_textColor() -> UIColor {
        return UIColor(contrastingBlackOrWhiteColorOn:UIColor.hhkl_mainColor(), isFlat: true)
    }
}
