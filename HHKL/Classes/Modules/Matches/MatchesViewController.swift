//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit

class MatchesViewController: ParentViewController {
    let viewModel: MatchesViewModelProtocol

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(viewModel: MatchesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.screenWillAppear()
    }
}
