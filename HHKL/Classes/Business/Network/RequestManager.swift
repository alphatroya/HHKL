//
// Created by Alexey Korolev on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import NetworkActivityIndicatorManager

protocol RequestManagerProtocol {
    func makeRequestWithType(type: RequestManagerRequestType, path: String, parameters: Dictionary<String, AnyObject>?) -> Observable<Dictionary<String, AnyObject>>
}

enum RequestManagerRequestType {
    case GET
}

class RequestManager: RequestManagerProtocol {
    var host: String?
    var networkActivityIndicatorManager: NetworkActivityIndicatorManager?

    func makeRequestWithType(type: RequestManagerRequestType, path: String, parameters: Dictionary<String, AnyObject>?) -> Observable<Dictionary<String, AnyObject>> {
        return Observable.create {
            observer in

            guard let host = self.host else {
                observer.on(Event.Error(Error.ClassWrongConfigured))
                return NopDisposable.instance
            }

            var method: Alamofire.Method?
            switch type {
            case .GET:
                method = .GET
            }

            guard let methodUnwrapped = method else {
                observer.on(Event.Error(Error.CriticalError))
                return NopDisposable.instance
            }

            self.networkActivityIndicatorManager?.addActivity()
            let request = Alamofire.request(methodUnwrapped, host + path, parameters: parameters).responseJSON {
                response in
                self.networkActivityIndicatorManager?.removeActivity()
                if let json = response.result.value as? [String:AnyObject] {
                    observer.on(Event.Next(json))
                    observer.on(Event.Completed)
                } else {
                    observer.on(Event.Error(response.result.error!))
                }
            }
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
}