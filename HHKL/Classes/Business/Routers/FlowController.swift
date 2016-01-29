//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import RxSwift


typealias FlowControllerResultObservable = Observable<UIViewController?>

protocol FlowControllerProtocol: class {

    var viewControllerFactory: ViewControllerFactoryProtocol { get }

    init(viewControllerFactory: ViewControllerFactoryProtocol, rootViewControllerType: ViewControllerType)

    weak var parentFlowController: FlowControllerProtocol? { get set }

    func performTransitionToController(viewControllerType: ViewControllerType) -> FlowControllerResultObservable

    func performBackTransition(animated: Bool) -> FlowControllerResultObservable

    func presentChildFlowController(flowController: FlowControllerProtocol) -> FlowControllerResultObservable

    func dismissPresentedChildFlowController(animated: Bool) -> FlowControllerResultObservable

}