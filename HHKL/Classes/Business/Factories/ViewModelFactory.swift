//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

protocol ViewModelFactoryProtocol {
    func matchesViewModel() -> MatchesViewModelProtocol
}

class ViewModelFactory: ViewModelFactoryProtocol {

    let accessoryFactory: ViewModelAccessoryFactoryProtocol

    init(accessoryFactory: ViewModelAccessoryFactoryProtocol) {
        self.accessoryFactory = accessoryFactory
    }

    func matchesViewModel() -> MatchesViewModelProtocol {
        return MatchesViewModel()
    }
}
