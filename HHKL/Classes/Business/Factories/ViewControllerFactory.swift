//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

enum ViewControllerType {
    case MatchesViewController
    case MatchViewController(match: Match)
}

protocol ViewControllerFactoryProtocol {
    func instantiateViewControllerWith(type: ViewControllerType, flowController: FlowControllerProtocol) -> ParentViewController
}

class ViewControllerFactory: ViewControllerFactoryProtocol {

    let accessoryFactory: ViewControllerAccessoryFactoryProtocol
    let viewModelFactory: ViewModelFactoryProtocol

    init(accessoryFactory: ViewControllerAccessoryFactoryProtocol, viewModelFactory: ViewModelFactoryProtocol) {
        self.accessoryFactory = accessoryFactory
        self.viewModelFactory = viewModelFactory
    }

    func instantiateViewControllerWith(type: ViewControllerType, flowController: FlowControllerProtocol) -> ParentViewController {
        switch type {
        case .MatchesViewController:
            return matchesViewController(viewModelFactory.matchesViewModel(flowController))
        case .MatchViewController(let match):
            return matchViewController(viewModelFactory.matchViewModel(flowController, match: match))
        }
    }

    func matchesViewController(viewModel: MatchesViewModelProtocol) -> ParentViewController {
        return MatchesViewController(viewModel: viewModel)
    }

    func matchViewController(viewModel: MatchViewModelProtocol) -> ParentViewController {
        return MatchViewController(viewModel: viewModel)
    }


}