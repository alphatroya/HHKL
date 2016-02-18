//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

protocol ViewModelFactoryProtocol {
    func matchesViewModel(flowController: FlowControllerProtocol) -> MatchesViewModelProtocol

    func matchViewModel(flowController: FlowControllerProtocol, match: Match) -> MatchViewModelProtocol
}

class ViewModelFactory: ViewModelFactoryProtocol {

    let accessoryFactory: ViewModelAccessoryFactoryProtocol

    init(accessoryFactory: ViewModelAccessoryFactoryProtocol) {
        self.accessoryFactory = accessoryFactory
    }

    func matchesViewModel(flowController: FlowControllerProtocol) -> MatchesViewModelProtocol {
        let viewModel = MatchesViewModel(flowController: flowController)
        viewModel.provider = accessoryFactory.requestManager
        viewModel.dayParser = accessoryFactory.dayParser
        return viewModel
    }

    func matchViewModel(flowController: FlowControllerProtocol, match: Match) -> MatchViewModelProtocol {
        let viewModel = MatchViewModel(flowController: flowController)
        viewModel.match = match
        return viewModel
    }

}
