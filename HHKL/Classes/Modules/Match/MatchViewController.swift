//
// Created by Alexey Korolev on 02.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import Localize_Swift

class MatchViewController: ParentViewController {

    let viewModel: MatchViewModelProtocol

    init(viewModel: MatchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "match-view-controller-title".localized()
    }


}
