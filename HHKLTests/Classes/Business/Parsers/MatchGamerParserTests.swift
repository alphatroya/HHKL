//
// Created by Alexey Korolev on 18.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import Moya
import SwiftyJSON
@testable import HHKL

class MatchGamerSpec: QuickSpec {
    override func spec() {
        var parser: MatchGamerParser!
        let requestManager = RxMoyaProvider<MatchesNetworkTarget>(stubClosure: MoyaProvider.ImmediatelyStub)

        beforeEach {
            parser = MatchGamerParser()
        }
        afterEach {
            parser = nil
        }
        describe("with success request result") {
            context("single result") {
                var result: MatchGamer?
                beforeEach {
                    requestManager.request(.Days(0)).mapJSON()
                    .map {
                        return JSON($0)["days"][0]["matches"][0]["yellow"]
                    }.flatMap {
                        return parser.parseModel($0)
                    }.subscribeNext {
                        result = $0
                    }
                }
                it("should parse correct first object") {
                    expect(result!.alias).toEventually(equal("APN"))
                    expect(result!.id).toEventually(equal(4))
                    expect(result!.name).toEventually(equal("Алексей П"))
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
                    var result: [MatchGamer]?
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
                    var result: MatchGamer?
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