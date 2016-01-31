//
// Created by Alexey Korolev on 29.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import SnapKit
import Chameleon


//TODO all code there is for tests and will be changed
class MatchCell: ParentTableViewCell {

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

        mainStackView.addArrangedSubview(createRedPlayerSection(0))

        let label3 = UILabel()
        label3.textAlignment = .Center
        label3.text = "1 : 100"
        label3.font = UIFont.systemFontOfSize(20)
        mainStackView.addArrangedSubview(label3)

        mainStackView.addArrangedSubview(createRedPlayerSection(3))
    }

    private func createRedPlayerSection(int: Int) -> UIStackView {
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
        gamerNameLabel.text = int > 0 ? "gthrtr2343243423423jhrt" : "fdgfdgg"
        stackView.addArrangedSubview(gamerNameLabel)

        return stackView
    }

}

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.size.width / 2
    }
}
