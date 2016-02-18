//
// Created by Alexey Korolev on 18.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Quick
import Nimble
import RxMoya
import RxSwift
import SwiftyJSON
@testable import HHKL

class DayParserSpec: QuickSpec {
    override func spec() {

        var parser: DayParser!
        let requestManager = RxMoyaProvider<MatchesNetworkTarget>(stubClosure: MoyaProvider.ImmediatelyStub)

        beforeEach {
            parser = DayParser()
        }
        afterEach {
            parser = nil
        }
        describe("with success request result") {
            context("array result") {
                var result: [Day]?
                beforeEach {
                    requestManager.request(.Days(0)).mapJSON()
                    .map {
                        return JSON($0)["days"]
                    }.flatMap {
                        return parser.parseModelArray($0)
                    }.subscribeNext {
                        result = $0
                    }
                }
                it("should parse correct count of days") {
                    expect(result!.count).toEventually(equal(28))
                }
                it("should parse correct first object") {
                    let firstDay = result![0]
                    expect(firstDay.matches!.count).toEventually(equal(4))
                    expect(firstDay.active).toEventually(beTrue())
                    expect(firstDay.name).toEventually(equal(1))
                }
            }
            context("single result") {
                var result: Day?
                beforeEach {
                    requestManager.request(.Days(0)).mapJSON()
                    .map {
                        return JSON($0)["days"][1]
                    }.flatMap {
                        return parser.parseModel($0)
                    }.subscribeNext {
                        result = $0
                    }
                }
                it("should parse correct first object") {
                    expect(result!.matches!.count).toEventually(equal(4))
                    expect(result!.active).toEventually(beTrue())
                    expect(result!.name).toEventually(equal(2))
                }
            }

        }
        describe("with wrong request result") {
            var errorObservable: Observable<JSON>?
            beforeEach {
                errorObservable = Observable.just("{\"hello\": \"world\"}").map {
                    return JSON($0)
                }
            }
            afterEach {
                errorObservable = nil
            }
            context("parsing array") {
                it("should return error after parse") {
                    var error: ErrorType?
                    var result: [Day]?
                    var isParserError: Bool?
                    errorObservable!.flatMap {
                        return parser.parseModelArray($0)
                    }.subscribe {
                        switch $0 {
                        case .Next(let e):
                            result = e
                        case .Error(let err):
                            error = err
                            if let appError = err as? HHKL.Error {
                                isParserError = (appError == HHKL.Error.ParserError)
                            }
                        default:
                            return
                        }
                    }
                    expect(error).toEventuallyNot(beNil())
                    expect(isParserError!).toEventually(beTrue())
                    expect(result).toEventually(beNil())
                }
            }
            context("parsing single result") {
                it("should return error after parse") {
                    var error: ErrorType?
                    var result: Day?
                    var isParserError: Bool?
                    errorObservable!.flatMap {
                        return parser.parseModel($0)
                    }.subscribe {
                        switch $0 {
                        case .Next(let e):
                            result = e
                        case .Error(let err):
                            error = err
                            if let appError = err as? HHKL.Error {
                                isParserError = (appError == HHKL.Error.ParserError)
                            }
                        default:
                            return
                        }
                    }
                    expect(error).toEventuallyNot(beNil())
                    expect(isParserError!).toEventually(beTrue())
                    expect(result).toEventually(beNil())
                }
            }
        }
    }
}