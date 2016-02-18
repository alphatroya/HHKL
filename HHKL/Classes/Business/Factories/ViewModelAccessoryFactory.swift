//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import NetworkActivityIndicatorManager
import UIKit
import RxMoya

protocol ViewModelAccessoryFactoryProtocol {
    var requestManager: RxMoyaProvider<MatchesNetworkTarget> { get }
    var dayParser: DayParser { get }
}

class ViewModelAccessoryFactory: ViewModelAccessoryFactoryProtocol {

    var requestManager: RxMoyaProvider<MatchesNetworkTarget> {
        let networkActivityIndicatorManager = self.networkActivityIndicatorManager
        //TODO remove stub block
        let requestManager = RxMoyaProvider<MatchesNetworkTarget>(stubClosure: MoyaProvider.ImmediatelyStub, plugins: [NetworkActivityPlugin(networkActivityClosure: {
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
