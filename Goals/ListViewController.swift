//
//  ListViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 08/01/18.
//  Copyright © 2018 Guilherme Souza. All rights reserved.
//

import IGListKit
import UIKit

class ListViewController<Item: ListDiffable>: UIViewController, UIScrollViewDelegate, ListAdapterDataSource {

    private let collectionView = UICollectionView()
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)

    var items: [Item] = [] {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.collectionView = collectionView
        adapter.scrollViewDelegate = self
        adapter.dataSource = self

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }

    override func loadView() {
        view = collectionView
    }

    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.height
        let contentSizeHeight = scrollView.contentSize.height
        let offset = scrollView.contentOffset.y
        let reachedBottom = (offset + height == contentSizeHeight)

        if reachedBottom {
            scrollViewDidReachBottom(scrollView)
        }
    }

    // Methods to override
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {}
    func scrollViewDidReachBottom(_ scrollView: UIScrollView) {}

    // MARK: ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}
