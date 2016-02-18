//
// Created by Alexey Korolev on 28.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import CocoaLumberjackSwift


protocol ParserProtocol {
    typealias model

    func parseModel(requestResult: JSON) -> Observable<model>

    func parseModelArray(requestResult: JSON) -> Observable<[model]>
}

extension ParserProtocol {
    func parseModelArray(requestResult: JSON) -> Observable<[model]> {
        guard let array = requestResult.array else {
            return Observable<[model]>.error(Error.ParserError)
        }

        return Observable.just(array).flatMap {
            json in
            return array.map {
                return self.parseModel($0)
            }.concat()
            .reduce([model](), accumulator: {
                return $0 + [$1]
            })
        }
    }
}

class DayParser: ParserProtocol {

    private let matchParser = MatchParser()

    func parseModel(requestResult: JSON) -> Observable<Day> {
        return Observable.just(requestResult).flatMap {
            json in
            return Observable.zip(Observable.just(json), self.matchParser.parseModelArray(json["matches"])) {
                return ($0, $1)
            }
        }.flatMap {
            (json, matches) in
            return Observable.create {
                observer in
                guard let
                name = json["name"].int,
                active = json["active"].bool else {
                    observer.on(Event.Error(Error.ParserError))
                    return NopDisposable.instance
                }

                let day = Day(name: name, active: active, matches: matches)
                observer.on(Event.Next(day))
                observer.on(Event.Completed)

                return NopDisposable.instance
            }
        }
    }

}

class MatchParser: ParserProtocol {

    let matchGamesParser = MatchGamerParser()

    func parseModel(requestResult: JSON) -> Observable<Match> {

        return Observable.just(requestResult).flatMap {
            json in

            return Observable.zip(self.matchGamesParser.parseModel(json["yellow"]), self.matchGamesParser.parseModel(json["red"])) {
                return ($0, $1, json)
            }

        }.flatMap {
            (yellow, red, json) in
            return Observable.create {
                observer in

                guard let
                id = json["id"].int,
                statusInt = json["status"].int,
                status = MatchStatus(rawValue: statusInt) else {
                    observer.on(Event.Error(Error.ParserError))
                    return NopDisposable.instance
                }

                var score: [MatchScore]?
                if let scoreArray = json["score"].array {
                    score = scoreArray.map {
                        values in
                        let firstNumber = values[0].intValue
                        let secondNumber = values[1].intValue
                        return MatchScore(yellow: firstNumber, red: secondNumber)
                    }
                }

                let match = Match(id: id, yellow: yellow, red: red, status: status, score: score)
                observer.on(Event.Next(match))
                observer.on(Event.Completed)
                return NopDisposable.instance
            }
        }
    }
}

class MatchGamerParser: ParserProtocol {

    func parseModel(requestResult: JSON) -> Observable<MatchGamer> {
        return Observable.just(requestResult).flatMap {
            json in
            return Observable.create {
                observer in
                guard let
                id = json["id"].int,
                name = json["name"].string,
                alias = json["alias"].string else {
                    observer.on(Event.Error(Error.ParserError))
                    return NopDisposable.instance
                }
                observer.on(Event.Next(MatchGamer(id: id, name: name, alias: alias)))
                observer.on(Event.Completed)
                return NopDisposable.instance
            }
        }
    }

}
