//
// Created by Alexey Korolev on 28.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

struct Day {
    let name: Int
    let active: Bool
    let matches: [Match]?
}

extension CollectionType where Generator.Element == Day {
    func findFirstActiveDay() -> NSIndexPath {
        for (index, day) in self.enumerate() {
            if !day.active {
                return NSIndexPath(forRow: 0, inSection: index)
            }
        }
        return NSIndexPath(forRow: 0, inSection: 0)
    }
}