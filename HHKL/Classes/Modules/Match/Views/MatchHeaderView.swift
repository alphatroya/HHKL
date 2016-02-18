//
// Created by Alexey Korolev on 18.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import SnapKit

class MatchHeaderView: UIView, MatchResultViewProtocol {
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    private let stackView = UIStackView()
    private(set) var yellowNameLabel: UILabel!
    private(set) var yellowAvatarImageView: UIImageView!
    private(set) var redNameLabel: UILabel!
    private(set) var redAvatarImageView: UIImageView!
    private(set) var scoreLabel: UILabel!

    init() {
        super.init(frame: CGRect.null)

        self.stackView.axis = .Horizontal
        self.stackView.alignment = .Center
        self.stackView.layoutMarginsRelativeArrangement = true
        self.stackView.layoutMargins = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)
        self.stackView.distribution = .FillEqually
        self.addSubview(self.stackView)
        self.stackView.snp_makeConstraints{
            $0.edges.equalTo(0)
        }

        var (stackView, label, imageView) = createPlayerSection()
        yellowNameLabel = label
        yellowAvatarImageView = imageView
        self.stackView.addArrangedSubview(stackView)

        let scoreLabel = createScoreLabel()
        self.stackView.addArrangedSubview(scoreLabel)
        self.scoreLabel = scoreLabel

        (stackView, label, imageView) = createPlayerSection()
        redNameLabel = label
        redAvatarImageView = imageView
        self.stackView.addArrangedSubview(stackView)

        self.yellowAvatarImageView.backgroundColor = UIColor.hhkl_yellowFlatColor()
        self.redAvatarImageView.backgroundColor = UIColor.hhkl_redFlatColor()
    }
}
