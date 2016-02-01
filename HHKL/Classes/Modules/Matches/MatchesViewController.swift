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
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        tableView.dataSource = self
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
        viewModel.reloadMatches()
        .subscribe() {
            self.dataLoading = false
            self.tableView.reloadData()
            if case .Error(_) = $0 {
                //TODO error handling
            }
        }
        .addDisposableTo(self.disposeBag)
    }
}

extension MatchesViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCellsInSection(section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(MatchCell), forIndexPath: indexPath) as! MatchCell
//        if let match = viewModel.matchForCellAtIndexPath(indexPath) {
//            cell.
//        }
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section)
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
