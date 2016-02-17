//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift

protocol ViewModelProtocol {
    func viewDidLoad()

    func viewWillAppear()

    func viewDidAppear()

    var disposeBag: DisposeBag { get }

    var flowController: FlowControllerProtocol { get }
    init(flowController: FlowControllerProtocol)
}

extension ViewModelProtocol {
    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

    func viewDidAppear() {
    }
}