//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import CocoaLumberjack
import Moya

protocol MatchesViewModelProtocol: ViewModelProtocol {
    func numberOfCellsInSection(section: Int) -> Int

    func numberOfSections() -> Int

    func matchForCellAtIndexPath(indexPath: NSIndexPath) -> Match?

    func titleForHeaderInSection(section: Int) -> String

    func openInformationAboutMatchAtIndexPath(indexPath: NSIndexPath)

    func reloadMatches(league: Int) -> Observable<[Day]>
}

class MatchesViewModel: MatchesViewModelProtocol {
    var flowController: FlowControllerProtocol
    var dayParser: DayParser?
    var dataSource: [Day]?
    var disposeBag: DisposeBag = DisposeBag()
    var provider: RxMoyaProvider<MatchesNetworkTarget>?

    required init(flowController: FlowControllerProtocol) {
        self.flowController = flowController
    }

    func reloadMatches(league: Int) -> Observable<[Day]> {
        guard let
        provider = self.provider,
        dayParser = self.dayParser else {
            return Observable.error(Error.ClassWrongConfigured)
        }

        return provider.request(.Days(league))
        .mapJSON()
        .map {
            return JSON($0)["days"]
        }.flatMap {
            return dayParser.parseModelArray($0)
        }.map {
            self.dataSource = $0
            return $0
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

    func openInformationAboutMatchAtIndexPath(indexPath: NSIndexPath) {
        guard let dataSource = self.dataSource where indexPath.section < dataSource.count else {
            return
        }
        let day = dataSource[indexPath.section]
        guard let matches = day.matches else {
            return
        }
        let match = matches[indexPath.row]
        self.flowController.performTransitionToController(.MatchViewController(match: match)).subscribe {
            if case .Error(_) = $0 {
                DDLogWarn("error while performing transition")
            }
        }.addDisposableTo(disposeBag)
    }

}
