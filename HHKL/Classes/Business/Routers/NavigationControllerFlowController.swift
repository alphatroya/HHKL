//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import RxSwift

class NavigationControllerFlowController: UINavigationController, FlowControllerProtocol {

    var viewControllerFactory: ViewControllerFactoryProtocol
    var parentFlowController: FlowControllerProtocol?

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    required init(viewControllerFactory: ViewControllerFactoryProtocol, rootViewControllerType: ViewControllerType) {
        self.viewControllerFactory = viewControllerFactory
        super.init(nibName: nil, bundle: nil)

        let viewController = viewControllerFactory.instantiateViewControllerWith(rootViewControllerType, flowController: self)
        self.setViewControllers([viewController], animated: false)
    }

    func performTransitionToController(viewControllerType: ViewControllerType) -> FlowControllerResultObservable {
        return Observable.create {
            observer in
            let viewController = self.viewControllerFactory.instantiateViewControllerWith(viewControllerType, flowController: self)
            self.pushViewController(viewController, animated: true, completion: {
                observer.on(Event.Next(viewController))
                observer.on(Event.Completed)
            })
            return NopDisposable.instance
        }
    }

    func performBackTransition(animated: Bool) -> FlowControllerResultObservable {
        return Observable.create {
            observer in
            self.popViewControllerAnimated(animated, completion: {
                observer.on(Event.Next(nil))
                observer.on(Event.Completed)
            })
            return NopDisposable.instance
        }
    }

    func presentChildFlowController(flowController: FlowControllerProtocol) -> FlowControllerResultObservable {
        return Observable.just(UIViewController())
    }

    func dismissPresentedChildFlowController(animated: Bool) -> FlowControllerResultObservable {
        return Observable.just(UIViewController())
    }

}

extension UINavigationController {

    func pushViewController(viewController: UIViewController,
                            animated: Bool, completion: Void -> Void) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    func popViewControllerAnimated(animated: Bool, completion: Void -> Void) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewControllerAnimated(animated)
        CATransaction.commit()
    }

}
