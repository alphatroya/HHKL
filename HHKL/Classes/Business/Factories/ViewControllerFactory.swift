//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

enum ViewControllerType {
    case MatchesViewController
}

protocol ViewControllerFactoryProtocol {
    func instantiateViewControllerWith(type: ViewControllerType) -> ParentViewController
}

class ViewControllerFactory: ViewControllerFactoryProtocol {

    let accessoryFactory: ViewControllerAccessoryFactoryProtocol
    let viewModelFactory: ViewModelFactoryProtocol

    init(accessoryFactory: ViewControllerAccessoryFactoryProtocol, viewModelFactory: ViewModelFactoryProtocol) {
        self.accessoryFactory = accessoryFactory
        self.viewModelFactory = viewModelFactory
    }

    func instantiateViewControllerWith(type: ViewControllerType) -> ParentViewController {
        switch type {
        case .MatchesViewController:
            return matchesViewController(viewModelFactory.matchesViewModel())
        }
    }

    func matchesViewController(viewModel: MatchesViewModelProtocol) -> ParentViewController {
        return MatchesViewController(viewModel: viewModel)
    }


}