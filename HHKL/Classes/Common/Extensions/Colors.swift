//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import Chameleon

extension UIColor {

    static func hhkl_mainColor() -> UIColor {
        return UIColor.flatYellowColor()
    }

    static func hhkl_secondaryColor() -> UIColor {
        let colorArray = NSArray(ofColorsWithColorScheme: ColorScheme.Triadic, with: UIColor.hhkl_mainColor(), flatScheme: true)
        return colorArray.firstObject! as! UIColor
    }

    static func hhkl_yellowFlatColor() -> UIColor {
        return UIColor.flatYellowColor()
    }

    static func hhkl_redFlatColor() -> UIColor {
        return UIColor.flatRedColor()
    }
}
