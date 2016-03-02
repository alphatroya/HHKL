//
// Created by Alexander Maslennikov on 02.03.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import FontBlaster

class Fonts {

    static func configure() {
        FontBlaster.debugEnabled = true
        FontBlaster.blast()
    }
}

extension UIFont {

    static func hhkl_regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: size)!
    }

    static func hhkl_bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size)!
    }

    static func hhkl_heavyItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-HeavyItalic", size: size)!
    }

    static func hhkl_black(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Black", size: size)!
    }
}
