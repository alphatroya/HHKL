//
// Created by Alexey Korolev on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

enum Error: ErrorType {
    case ClassWrongConfigured, CriticalError, ParserError
}

extension Error: Equatable {

}

func ==(a: Error, b: Error) -> Bool {
    switch (a, b) {
    case (.ClassWrongConfigured, .ClassWrongConfigured), (.CriticalError, .CriticalError), (.ParserError, .ParserError):
        return true
    default:
        return false
    }
}
