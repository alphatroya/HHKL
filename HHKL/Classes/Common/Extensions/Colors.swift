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

    static func hhkl_yellowFlatColor() -> UIColor {
        return UIColor.flatYellowColor()
    }

    static func hhkl_redFlatColor() -> UIColor {
        return UIColor.flatRedColor()
    }

    static func hhkl_textColor() -> UIColor {
        return UIColor(contrastingBlackOrWhiteColorOn:UIColor.hhkl_mainColor(), isFlat: true)
    }
}
