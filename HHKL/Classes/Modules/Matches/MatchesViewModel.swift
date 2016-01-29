//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol MatchesViewModelProtocol: ViewModelProtocol {
    func numberOfCellsInSection(section: Int) -> Int

    func numberOfSections() -> Int

    func matchForCellAtIndexPath(indexPath: NSIndexPath) -> Match?

    func titleForHeaderInSection(section: Int) -> String

    func reloadMatches() -> Observable<Bool>
}

class MatchesViewModel: MatchesViewModelProtocol {
    var flowController: FlowControllerProtocol
    var requestManager: RequestManagerProtocol?
    var dayParser: DayParser?
    var dataSource: [Day]?

    required init(flowController: FlowControllerProtocol) {
        self.flowController = flowController
    }

    func reloadMatches() -> Observable<Bool> {
        guard let
        requestManager = self.requestManager,
        dayParser = self.dayParser else {
            return Observable.error(Error.ClassWrongConfigured)
        }

        // TODO create router
        let requestDataObservable = requestManager.makeRequestWithType(.GET, path: "league/1/matches/", parameters: nil).map {
            return JSON($0)["days"]
        }
        return dayParser.parseModelArray(requestDataObservable).map {
            self.dataSource = $0
        }.flatMap {
            return Observable.just(true)
        }
    }


    func titleForHeaderInSection(section: Int) -> String {
        guard let dataSource = self.dataSource else {
            return ""
        }
        return "\(dataSource[section].name)"
    }

    func matchForCellAtIndexPath(indexPath: NSIndexPath) -> Match? {
        guard let dataSource = self.dataSource else {
            return nil
        }
        let day = dataSource[indexPath.section]
        guard let matches = day.matches else {
            return nil
        }
        return matches[indexPath.row]
    }

    func numberOfSections() -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.count
    }

    func numberOfCellsInSection(section: Int) -> Int {
        guard let dataSource = self.dataSource where section < dataSource.count else {
            return 0
        }
        let day = dataSource[section]
        guard let matches = day.matches else {
            return 0
        }
        return matches.count
    }


}
