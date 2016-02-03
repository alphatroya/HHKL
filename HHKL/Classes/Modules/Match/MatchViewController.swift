//
// Created by Alexey Korolev on 02.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import Localize_Swift
import SnapKit

class MatchViewController: ParentViewController, MatchResultViewProtocol {

    let viewModel: MatchViewModelProtocol

    init(viewModel: MatchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    var yellowGamerNameLabel: UILabel?
    var redGamerNameLabel: UILabel?
    var scoreLabel: UILabel?

    let scrollView = UIScrollView()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "match-view-controller-title".localized()
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(scrollView)
        scrollView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }

        stackView.axis = .Vertical
        stackView.layoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)
        view.addSubview(stackView)
        stackView.snp_makeConstraints {
            $0.right.equalTo(0)
            $0.top.equalTo(0)
            $0.left.equalTo(0)
        }

        let matchResultStackView = UIStackView()
        matchResultStackView.distribution = .FillEqually

        var stack = createPlayerSection()
        stack.imageView.backgroundColor = UIColor.hhkl_yellowFlatColor()
        self.yellowGamerNameLabel = stack.label
        matchResultStackView.addArrangedSubview(stack.stackView)

        let scoreLabel = createScoreLabel()
        matchResultStackView.addArrangedSubview(scoreLabel)
        self.scoreLabel = scoreLabel

        stack = createPlayerSection()
        stack.imageView.backgroundColor = UIColor.hhkl_redFlatColor()
        self.redGamerNameLabel = stack.label
        matchResultStackView.addArrangedSubview(stack.stackView)

        stackView.addArrangedSubview(matchResultStackView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard let match = viewModel.match else {
            return
        }
        yellowGamerNameLabel?.text = match.yellow.name
        redGamerNameLabel?.text = match.red.name

        if let scoreArray = match.score where !scoreArray.isEmpty {
            let result = scoreArray.getResultOfMatch()
            scoreLabel?.text = "\(result.yellow) : \(result.red)"
        } else {
            scoreLabel?.text = "match-view-controller-vernus".localized()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }


}
