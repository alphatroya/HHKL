//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

protocol ViewModelFactoryProtocol {
    func matchesViewModel(flowController: FlowControllerProtocol) -> MatchesViewModelProtocol
}

class ViewModelFactory: ViewModelFactoryProtocol {

    let accessoryFactory: ViewModelAccessoryFactoryProtocol

    init(accessoryFactory: ViewModelAccessoryFactoryProtocol) {
        self.accessoryFactory = accessoryFactory
    }

    func matchesViewModel(flowController: FlowControllerProtocol) -> MatchesViewModelProtocol {
        return MatchesViewModel(flowController: flowController)
    }
}
