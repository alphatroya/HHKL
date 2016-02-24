//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import ATRNetworkActivityIndicatorManager
import UIKit
import Moya

protocol ViewModelAccessoryFactoryProtocol {
    var requestManager: RxMoyaProvider<MatchesNetworkTarget> { get }
    var dayParser: DayParser { get }
}

class ViewModelAccessoryFactory: ViewModelAccessoryFactoryProtocol {

    var requestManager: RxMoyaProvider<MatchesNetworkTarget> {
        let networkActivityIndicatorManager = self.networkActivityIndicatorManager
        let requestManager = RxMoyaProvider<MatchesNetworkTarget>(plugins: [NetworkActivityPlugin(networkActivityClosure: {
            activityType in
            switch activityType {
            case .Began:
                networkActivityIndicatorManager.addActivity()
            case .Ended:
                networkActivityIndicatorManager.removeActivity()
            }
        })])
        return requestManager
    }

    var dayParser: DayParser {
        return DayParser()
    }

    var networkActivityIndicatorManager: NetworkActivityIndicatorManager {
        return NetworkActivityIndicatorManager(withApplication: application)
    }

    var application: UIApplication {
        return UIApplication.sharedApplication()
    }


}
