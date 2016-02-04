//
// Created by Alexander Maslennikov on 27.01.16.
// Copyright (c) 2016 Heads and Hands. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import DZNEmptyDataSet
import Localize_Swift

class MatchesViewController: ParentViewController {
    let viewModel: MatchesViewModelProtocol
    let disposeBag = DisposeBag()

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(viewModel: MatchesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    let tableView = UITableView()
    let segmentedControl = UISegmentedControl(items: ["matches-view-controller-first-league".localized(), "matches-view-controller-second-league".localized()])

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = segmentedControl
        segmentedControl.tintColor = UIColor.hhkl_secondaryColor()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentedControlPressed", forControlEvents: .ValueChanged)
        title = "matches-view-controller-title".localized()

        view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MatchCell.self, forCellReuseIdentifier: String(MatchCell))
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }

    private var dataLoading = false
    private func reloadData() {
        guard !dataLoading else {
            return
        }
        dataLoading = true
        viewModel.reloadMatches(segmentedControl.selectedSegmentIndex + 1)
        .subscribe() {
            self.dataLoading = false
            self.tableView.reloadData()
            if case Event.Next(let x) = $0 {
                self.tableView.scrollToRowAtIndexPath(x.findFirstActiveDay(), atScrollPosition: .Top, animated: true)
            }
        }
        .addDisposableTo(self.disposeBag)
    }

    func segmentedControlPressed() {
        self.dataLoading = false
        reloadData()
    }
}

extension MatchesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCellsInSection(section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(MatchCell), forIndexPath: indexPath)
        if let
        matchCell = cell as? MatchCell,
        match = viewModel.matchForCellAtIndexPath(indexPath) {
            matchCell.yellowGamerLabel?.text = match.yellow.name
            matchCell.redGamerLabel?.text = match.red.name
            if let scoreArray = match.score where !scoreArray.isEmpty {
                let result = scoreArray.getResultOfMatch()
                matchCell.scoreLabel?.text = "\(result.yellow) : \(result.red)"
            } else {
                matchCell.scoreLabel?.text = "match-view-controller-vernus".localized()
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "matches-view-controller-day-prefix".localized() + " " + viewModel.titleForHeaderInSection(section)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        viewModel.openInformationAboutMatchAtIndexPath(indexPath)
    }

}

extension MatchesViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        return NSAttributedString(string: "matches-view-controller-empty-table-title".localized())
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        return NSAttributedString(string: "matches-view-controller-empty-table-description".localized())
    }

    func emptyDataSetDidTapView(scrollView: UIScrollView) {
        reloadData()
    }
}
