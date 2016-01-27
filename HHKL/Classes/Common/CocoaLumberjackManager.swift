//
// Created by Alexey Korolev on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import ATRLogFormatter
import CocoaLumberjack

class CocoaLumberjackManager {

    func configureLogging() {
        DDLog.addLogger(DDTTYLogger.sharedInstance())
        DDLog.addLogger(DDASLLogger.sharedInstance())

        let formatter = ATRLogFormatter()
        formatter.classNameAlignment = .Center
        formatter.enableLineNumberPrinting = true
        DDASLLogger.sharedInstance().logFormatter = formatter
        DDTTYLogger.sharedInstance().logFormatter = formatter
        DDTTYLogger.sharedInstance().colorsEnabled = true
    }
}