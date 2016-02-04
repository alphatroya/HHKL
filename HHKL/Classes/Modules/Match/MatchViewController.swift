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
    var firstMatchLabel: UILabel?
    var secondMatchLabel: UILabel?
    var thirdMatchLabel: UILabel?

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

        stackView.addArrangedSubview(createMatchResultSection())

        var label = createMatchDetailedResultSection()
        firstMatchLabel = label
        stackView.addArrangedSubview(label)

        label = createMatchDetailedResultSection()
        secondMatchLabel = label
        stackView.addArrangedSubview(label)

        label = createMatchDetailedResultSection()
        thirdMatchLabel = label
        stackView.addArrangedSubview(label)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard let match = viewModel.match else {
            return
        }
        yellowGamerNameLabel?.text = match.yellow.name
        redGamerNameLabel?.text = match.red.name

        if let scoreArray = match.score where !scoreArray.isEmpty {
            let resultMatch = scoreArray.getResultOfMatch()
            scoreLabel?.text = "\(resultMatch.yellow) : \(resultMatch.red)"

            var resultGame = scoreArray[0]
            firstMatchLabel?.text = "\(resultGame.yellow) : \(resultGame.red)"
            if scoreArray.count > 1 {
                resultGame = scoreArray[1]
                secondMatchLabel?.text = "\(resultGame.yellow) : \(resultGame.red)"
                if scoreArray.count > 2 {
                    resultGame = scoreArray[2]
                    thirdMatchLabel?.text = "\(resultGame.yellow) : \(resultGame.red)"
                }
            }

        } else {
            scoreLabel?.text = "match-view-controller-vernus".localized()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }

    private func createMatchResultSection() -> UIView {
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
        return matchResultStackView
    }

    private func createMatchDetailedResultSection() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Center
        return label
    }

}
