//
// Created by Alexey Korolev on 28.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import CocoaLumberjackSwift


//TODO write tests for check
protocol ParserProtocol {
    typealias model

    func parseModel(requestResult: Observable<JSON>) -> Observable<model>

    func parseModelArray(requestResult: Observable<JSON>) -> Observable<[model]>
}

extension ParserProtocol {
    func parseModelArray(requestResult: Observable<JSON>) -> Observable<[model]> {
        return requestResult.flatMap {
            json in
            return json.arrayValue.map {
                return self.parseModel(Observable.just($0))
            }.concat()
            .reduce([model](), accumulator: {
                return $0 + [$1]
            })
        }
    }
}

class DayParser: ParserProtocol {

    private let matchParser = MatchParser()

    func parseModel(requestResult: Observable<JSON>) -> Observable<Day> {
        return requestResult.flatMap {
            json in
            return Observable.zip(Observable.just(json), self.matchParser.parseModelArray(Observable.just(json["matches"]))) {
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

    func parseModel(requestResult: Observable<JSON>) -> Observable<Match> {

        return requestResult.flatMap {
            json in

            return Observable.zip(self.matchGamesParser.parseModel(Observable.just(json["yellow"])), self.matchGamesParser.parseModel(Observable.just(json["red"]))) {
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
                        return MatchScore(firstNumber: firstNumber, secondNumber: secondNumber)
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

    func parseModel(requestResult: Observable<JSON>) -> Observable<MatchGamer> {
        return requestResult.flatMap {
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
