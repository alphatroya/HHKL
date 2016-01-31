//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

protocol ViewModelProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()

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