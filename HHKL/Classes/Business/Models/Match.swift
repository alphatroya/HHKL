//
// Created by Alexey Korolev on 28.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

struct Match {
    var id: Int
    var yellow: MatchGamer
    var red: MatchGamer
    var status: MatchStatus
    var score: [MatchScore]?
}

extension CollectionType where Generator.Element == MatchScore {
    func getResultOfMatch() -> (yellow: Int, red: Int) {
        var yellow = 0, red = 0
        for matchResult in self {
            if matchResult.firstNumber > matchResult.secondNumber {
                yellow += 1
            } else {
                red += 1
            }
        }

        return (yellow: yellow, red: red)
    }
}

struct MatchScore {
    let firstNumber: Int
    let secondNumber: Int
}

enum MatchStatus: Int {
    case Idle, Running, Completed, Approved
}

struct MatchGamer {
    let id: Int
    let name: String
    let alias: String
}
