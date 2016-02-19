//
// Created by Alexey Korolev on 18.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import ATRSlideSelectorView

class MatchSectionResultViewCell: ParentTableViewCell {
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    let sliderView = ATRSlideSelectorView(frame: CGRect.zero)
    let yellowCountLabel = UILabel()
    let redCountLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .None
        self.textLabel?.font = UIFont.systemFontOfSize(18)
        self.textLabel?.textAlignment = .Center

        sliderView.leftViewBackgroundColor = UIColor.hhkl_yellowFlatColor()
        sliderView.clipsToBounds = true
        sliderView.layer.cornerRadius = 5.0
        sliderView.rightViewBackgroundColor = UIColor.hhkl_redFlatColor()
        sliderView.step = 19
        contentView.addSubview(sliderView)
        sliderView.snp_makeConstraints {
            make in
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
            make.right.equalTo(-30)
            make.left.equalTo(30)
        }

        contentView.addSubview(yellowCountLabel)
        yellowCountLabel.textAlignment = .Center
        yellowCountLabel.snp_makeConstraints {
            make in
            make.centerY.equalTo(sliderView)
            make.left.equalTo(5)
            make.right.equalTo(sliderView.snp_left).offset(-5)
        }
        contentView.addSubview(redCountLabel)
        redCountLabel.textAlignment = .Center
        redCountLabel.snp_makeConstraints {
            make in
            make.centerY.equalTo(sliderView)
            make.right.equalTo(-5)
            make.left.equalTo(sliderView.snp_right).offset(5)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        yellowCountLabel.text = "0"
        redCountLabel.text = "0"
    }

}
