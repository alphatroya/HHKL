//
// Created by Alexey Korolev on 17.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxMoya

enum MatchesNetworkTarget {
    case Days(Int)
}

extension MatchesNetworkTarget: TargetType {
    var baseURL: NSURL {
        return NSURL(string: "http://hhkl.handh.ru:666/api/")!
    }
    var path: String {
        switch self {
        case .Days(let league):
            return "league/\(league)/matches/"
        }
    }
    var method: RxMoya.Method {
        switch self {
        case .Days(_):
            return .GET
        }
    }
    var parameters: [String:AnyObject]? {
        return nil
    }
    var sampleData: NSData {
        switch self {
        case .Days(_):
            let path = NSBundle.mainBundle().pathForResource("days", ofType: "json")
            return NSData(contentsOfFile: path!)!
        }
    }

}
