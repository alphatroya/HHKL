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
    func findLastActiveDay() -> NSIndexPath {
        for (index, day) in self.reverse().enumerate() {
            if day.active {
                let section = Int(self.count.toIntMax()) - 1 - index
                return NSIndexPath(forRow: 0, inSection: section)
            }
        }
        return NSIndexPath(forRow: 0, inSection: 0)
    }
}