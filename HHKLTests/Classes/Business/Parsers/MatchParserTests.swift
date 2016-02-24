//
// Created by Alexey Korolev on 18.02.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Quick
import Nimble
import Moya
import RxSwift
import SwiftyJSON
@testable import HHKL

class MatchParserSpec: QuickSpec {
    override func spec() {
        var parser: MatchParser!
        let requestManager = RxMoyaProvider<MatchesNetworkTarget>(stubClosure: MoyaProvider.ImmediatelyStub)

        beforeEach {
            parser = MatchParser()
        }
        afterEach {
            parser = nil
        }
        describe("with success request result") {
            context("array result") {
                var result: [Match]?
                beforeEach {
                    requestManager.request(.Days(0)).mapJSON()
                    .map {
                        return JSON($0)["days"][0]["matches"]
                    }.flatMap {
                        return parser.parseModelArray($0)
                    }.subscribeNext {
                        result = $0
                    }
                }
                it("should parse correct count of days") {
                    expect(result!.count).toEventually(equal(4))
                }
                it("should parse correct first object") {
                    let firstMatch = result![0]
                    expect(firstMatch.status.rawValue).toEventually(equal(3))
                    expect(firstMatch.score!.count).toEventually(equal(2))
                    expect(firstMatch.score!.first!.yellow).toEventually(equal(7))
                    expect(firstMatch.score!.first!.red).toEventually(equal(10))
                    expect(firstMatch.id).toEventually(equal(3))
                }
            }
            context("single result") {
                var result: Match?
                beforeEach {
                    requestManager.request(.Days(0)).mapJSON()
                    .map {
                        return JSON($0)["days"][0]["matches"][0]
                    }.flatMap {
                        return parser.parseModel($0)
                    }.subscribeNext {
                        result = $0
                    }
                }
                it("should parse correct first object") {
                    expect(result!.status.rawValue).toEventually(equal(3))
                    expect(result!.score!.count).toEventually(equal(2))
                    expect(result!.score!.first!.yellow).toEventually(equal(7))
                    expect(result!.score!.first!.red).toEventually(equal(10))
                    expect(result!.id).toEventually(equal(3))
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
            it("should return error after parse") {
                var error: ErrorType?
                var result: [Match]?
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
    }
}