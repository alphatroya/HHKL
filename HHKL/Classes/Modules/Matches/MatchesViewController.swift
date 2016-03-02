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
        tableView.rowHeight = 90
        tableView.sectionHeaderHeight = 36
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }

    private var requestDisposable: Disposable?
    private func reloadData() {
        if let requestDisposable = self.requestDisposable {
            requestDisposable.dispose()
        }

        let disposable = viewModel.reloadMatches(segmentedControl.selectedSegmentIndex + 1)
        .subscribe() {
            self.tableView.reloadData()
            if case Event.Next(let x) = $0 {
                self.tableView.scrollToRowAtIndexPath(x.findLastActiveDay(), atScrollPosition: .Top, animated: true)
            }
        }
        disposable.addDisposableTo(self.disposeBag)
        self.requestDisposable = disposable
    }

    func segmentedControlPressed() {
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
            matchCell.yellowGamerImageView?.image = UIImage(named: "fake-avatar-gray-man")
            matchCell.yellowGamerLabel?.text = match.yellow.name
            matchCell.redGamerImageView?.image = UIImage(named: "fake-avatar-color-man")
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

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRectMake(0, 0, tableView.frame.width, tableView.sectionHeaderHeight))
        label.font = UIFont.hhkl_heavyItalic(18)
        label.textAlignment = .Center
        label.text = "matches-view-controller-day-prefix".localized() + " " + viewModel.titleForHeaderInSection(section)
        label.backgroundColor = UIColor.hhkl_secondaryColor().colorWithAlphaComponent(0.975)
        return label
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
