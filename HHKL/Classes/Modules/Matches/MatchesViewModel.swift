//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift

protocol MatchesViewModelProtocol: ViewModelProtocol {
    func performTransition()
}

class MatchesViewModel: MatchesViewModelProtocol {
    var flowController: FlowControllerProtocol

    required init(flowController: FlowControllerProtocol) {
        self.flowController = flowController
    }

    let dispatchBag = DisposeBag()
    func performTransition() {
        flowController.performTransitionToController(ViewControllerType.MatchesViewController).subscribe {
            print($0)
        }.addDisposableTo(dispatchBag)
    }


}
