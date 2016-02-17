//
// Created by Alexey Korolev on 02.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift

protocol MatchViewModelProtocol: ViewModelProtocol {
    var match: Match? { get set }
}

class MatchViewModel: MatchViewModelProtocol {
    var match: Match?
    var flowController: FlowControllerProtocol
    var disposeBag: DisposeBag = DisposeBag()

    required init(flowController: FlowControllerProtocol) {
        self.flowController = flowController
    }

}
