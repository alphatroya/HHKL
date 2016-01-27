//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation

protocol MatchesViewModelProtocol {

    func screenWillAppear()
}

class MatchesViewModel: MatchesViewModelProtocol {

    func screenWillAppear() {
        print("WillAppear-bazinga!")
    }
}
