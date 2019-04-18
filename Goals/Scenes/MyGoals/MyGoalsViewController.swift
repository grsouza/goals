//
//  MyGoalsViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import IGListKit
import UIKit

final class GoalDisplayable: ListDiffable {
    let uid: String
    let title: String
    let totalAmount: Double
    let remainingAmount: Double
    let isCompleted: Bool

    let goal: Goal

    init(goal: Goal) {
        self.goal = goal
        
        uid = goal.uid
        title = goal.title
        totalAmount = goal.amount
        remainingAmount = goal.remaining
        isCompleted = goal.isCompleted
    }

    func diffIdentifier() -> NSObjectProtocol {
        return uid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? GoalDisplayable else { return false }
        return object.uid == uid &&
            object.title == title &&
            object.totalAmount == totalAmount &&
            object.remainingAmount == remainingAmount &&
            object.isCompleted == isCompleted
    }
}

protocol MyGoalsView: BaseView {
    func displayGoals(_ goals: [GoalDisplayable])
}

final class MyGoalsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: FloatingButton!

    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    private var items: [GoalDisplayable] = []

    var router: MyGoalsRoutingLogic!
    var interactor: MyGoalsBusinessLogic!

    private lazy var transition = CircularTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Goals"
        addButton.backgroundColor = Color.primaryGreen
        addButton.tintColor = .white

        let buttonMargin: CGFloat = 64
        collectionView.contentInset.bottom = buttonMargin + addButton.frame.height
        adapter.collectionView = collectionView
        adapter.dataSource = self

        interactor.loadGoals()
    }

    @IBAction private func addButtonTapped(_ sender: UIButton) {
        router.routeToAddGoal()
    }
}

extension MyGoalsViewController: MyGoalsView {
    func displayGoals(_ goals: [GoalDisplayable]) {
        items = goals
        adapter.performUpdates(animated: true)
    }
}

extension MyGoalsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = MyGoalsSectionController()
        sectionController.delegate = self
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension MyGoalsViewController: MyGoalsSectionControllerDelegate {
    func didSelectGoal(_ goal: Goal) {
        router.routeToSelectedGoal(goal)
    }
}

extension MyGoalsViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = addButton.center
        transition.circleColor = addButton.backgroundColor!
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = addButton.center
        return transition
    }
}
