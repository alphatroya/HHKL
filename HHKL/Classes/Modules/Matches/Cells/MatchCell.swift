//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import SnapKit
import Chameleon

class MatchCell: ParentTableViewCell {

    var yellowGamerImageView: UIImageView?
    var redGamerImageView: UIImageView?
    var yellowGamerLabel: UILabel?
    var redGamerLabel: UILabel?
    var scoreLabel: UILabel?

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let mainStackView = UIStackView()
        mainStackView.axis = .Horizontal
        mainStackView.alignment = .Center
        mainStackView.layoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)
        mainStackView.distribution = .FillEqually
        contentView.addSubview(mainStackView)
        mainStackView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }

        var stack = createPlayerSection()
        yellowGamerLabel = stack.label
        yellowGamerImageView = stack.imageView
        mainStackView.addArrangedSubview(stack.stackView)

        let scoreLabel = UILabel()
        scoreLabel.textAlignment = .Center
        scoreLabel.font = UIFont.systemFontOfSize(20)
        mainStackView.addArrangedSubview(scoreLabel)
        self.scoreLabel = scoreLabel

        stack = createPlayerSection()
        redGamerLabel = stack.label
        redGamerImageView = stack.imageView
        mainStackView.addArrangedSubview(stack.stackView)
    }

    private func createPlayerSection() -> (stackView:UIStackView, label:UILabel, imageView:UIImageView) {
        let stackView = UIStackView()
        stackView.distribution = .FillProportionally
        stackView.axis = .Vertical

        let view = UIView()

        let gamerAvatar = RoundImageView()
        gamerAvatar.backgroundColor = UIColor.randomFlatColor()
        view.addSubview(gamerAvatar)
        gamerAvatar.snp_makeConstraints {
            make in
            make.size.equalTo(CGSizeMake(50, 50))
            make.centerX.equalTo(0)
            make.top.bottom.equalTo(0)
        }
        stackView.addArrangedSubview(view)

        let gamerNameLabel = UILabel()
        gamerNameLabel.textAlignment = .Center
        gamerNameLabel.adjustsFontSizeToFitWidth = true
        stackView.addArrangedSubview(gamerNameLabel)

        return (stackView, gamerNameLabel, gamerAvatar)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        yellowGamerImageView?.backgroundColor = UIColor.randomFlatColor()
        yellowGamerImageView?.image = nil
        redGamerImageView?.backgroundColor = UIColor.randomFlatColor()
        redGamerImageView?.image = nil
        yellowGamerLabel?.text = nil
        redGamerLabel?.text = nil
        scoreLabel?.text = nil
    }

}

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.size.width / 2
    }
}
