//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import SnapKit

class MatchesViewController: ParentViewController {
    let viewModel: MatchesViewModelProtocol

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(viewModel: MatchesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        view.addSubview(button)
        button.snp_makeConstraints {
            make in
            make.size.equalTo(CGSizeMake(40, 40))
            make.center.equalTo(0)
        }
        button.addTarget(self, action: "performTransition", forControlEvents: .TouchUpInside)
    }

    func performTransition() {
        viewModel.performTransition()
    }
}
