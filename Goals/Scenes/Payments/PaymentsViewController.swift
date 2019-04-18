//
//  PaymentsViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import IGListKit
import RxSwift
import UIKit

final class PaymentDisplayable: ListDiffable {
    let uid: String
    let date: Date
    let amount: Double

    let payment: Payment

    init(payment: Payment) {
        self.payment = payment
        uid = payment.uid
        date = payment.date
        amount = payment.amount
    }

    func diffIdentifier() -> NSObjectProtocol {
        return uid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? PaymentDisplayable else { return false }
        return object.date == date &&
            object.amount == amount
    }
}

final class PaymentsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: FloatingButton!

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
//        control.tintColor = .white
        control.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        return control
    }()

    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    private var items: [PaymentDisplayable] = []

    private var viewModel: PaymentsViewModelType!
    private let disposeBag = DisposeBag()
    private lazy var transition = CircularTransition()

    static func instantiate(with goal: Goal) -> PaymentsViewController {
        let controller = Storyboard.Payments.instantiate(PaymentsViewController.self)
        controller.viewModel = PaymentsViewModel(goalUID: goal.uid)
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.closeIcon, style: .done, target: self, action: #selector(dismissTapped(_:)))
        addButton.backgroundColor = Color.primaryGreen
        addButton.tintColor = .white

        let buttonMargin: CGFloat = 64
        collectionView.contentInset.bottom = buttonMargin + addButton.frame.height
        collectionView.refreshControl = refreshControl
        adapter.collectionView = collectionView
        adapter.dataSource = self

        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.viewDidAppear()
    }

    private func bindViewModel() {
        viewModel.output.payments
            .drive(onNext: { [weak self] payments in
                self?.items = payments
                self?.adapter.performUpdates(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.output.showAddPaymentWithGoal
            .drive(onNext: { [weak self] goal in
                let addPaymentViewController = AddPaymentViewController.instantiate(with: goal, delegate: self)
                addPaymentViewController.modalPresentationStyle = .custom
                addPaymentViewController.transitioningDelegate = self
                self?.present(addPaymentViewController, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.output.paymentDeleted
            .drive()
            .disposed(by: disposeBag)

        viewModel.output.isAddPaymentEnabled
            .drive(addButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.output.goal
            .drive(onNext: { [weak self] goal in
                self?.navigationItem.title = goal.title
            })
            .disposed(by: disposeBag)
    }

    @IBAction private func addButtonTapped(_ sender: UIButton) {
        viewModel.input.addPaymentTapped()
    }

    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.input.pullToRefresh()
    }

    @objc private func dismissTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}

extension PaymentsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = PaymentsSectionController()
        sectionController.delegate = self
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension PaymentsViewController: PaymentsSectionControllerDelegate {
    func didSelect(_ payment: Payment) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
//
//        }

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.input.delete(payment)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

//        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}

extension PaymentsViewController: AddPaymentViewControllerDelegate {
    func willDismissAddPaymentViewController() {
        viewModel.input.viewDidAppear()
    }
}

extension PaymentsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
