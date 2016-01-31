//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

protocol ViewModelAccessoryFactoryProtocol {
    var requestManager: RequestManagerProtocol { get }
    var dayParser: DayParser { get }
}

class ViewModelAccessoryFactory: ViewModelAccessoryFactoryProtocol {

    var requestManager: RequestManagerProtocol {
        let requestManager = RequestManager()
        requestManager.host = "http://hhkl.handh.ru:666/api/"
        return requestManager
    }

    var dayParser: DayParser {
        return DayParser()
    }


}
