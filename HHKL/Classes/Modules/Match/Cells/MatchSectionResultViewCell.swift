//
// Created by Alexey Korolev on 18.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit

class MatchSectionResultViewCell: ParentTableViewCell {
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .None
        self.textLabel?.font = UIFont.systemFontOfSize(18)
        self.textLabel?.textAlignment = .Center
    }
}
