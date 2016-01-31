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
