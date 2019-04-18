//
//  PaymentsViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol PaymentsViewModelInput {
    func viewDidAppear()
    func pullToRefresh()
    func addPaymentTapped()

    func delete(_ payment: Payment)
}

protocol PaymentsViewModelOutput {
    var goal: Driver<Goal> { get }
    var payments: Driver<[PaymentDisplayable]> { get }
    var isLoading: Driver<Bool> { get }
    var showAddPaymentWithGoal: Driver<Goal> { get }
    var paymentDeleted: Driver<Void> { get }
    var isAddPaymentEnabled: Driver<Bool> { get }
}

protocol PaymentsViewModelType {
    var input: PaymentsViewModelInput { get }
    var output: PaymentsViewModelOutput { get }
}

final class PaymentsViewModel: PaymentsViewModelType, PaymentsViewModelInput, PaymentsViewModelOutput {

    let payments: SharedSequence<DriverSharingStrategy, [PaymentDisplayable]>
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    let showAddPaymentWithGoal: SharedSequence<DriverSharingStrategy, Goal>
    let paymentDeleted: SharedSequence<DriverSharingStrategy, Void>
    let isAddPaymentEnabled: SharedSequence<DriverSharingStrategy, Bool>
    let goal: SharedSequence<DriverSharingStrategy, Goal>

    init(
        goalUID: String,
        goalService: GoalLoadable = GoalService(),
        paymentService: PaymentLoadable & PaymentDeletable = PaymentService()
        ) {
        paymentDeleted = paymentToDelete.flatMap(paymentService.delete)
            .asDriverOnErrorJustComplete()
            .mapToVoid()

        goal = Driver.merge(paymentDeleted, viewDidAppearProperty.asDriverOnErrorJustComplete())
            .flatMap { _ in
                goalService.load(uid: goalUID)
                    .asDriverOnErrorJustComplete()
            }

        let activityTracker = ActivityTracker()
        isLoading = activityTracker.asDriver()

        showAddPaymentWithGoal = addPaymentTappedProperty.withLatestFrom(goal)
            .asDriverOnErrorJustComplete()
        
        payments = Observable.merge(viewDidAppearProperty, pullToRefreshProperty)
            .flatMap { _ in
                return paymentService.all(from: goalUID)
                    .trackActivity(activityTracker)
            }
            .map { $0.map(PaymentDisplayable.init) }
            .asDriver(onErrorJustReturn: [])

        isAddPaymentEnabled = goal.map { !$0.isCompleted }
    }

    private let viewDidAppearProperty = PublishSubject<Void>()
    func viewDidAppear() {
        viewDidAppearProperty.onNext(())
    }

    private let pullToRefreshProperty = PublishSubject<Void>()
    func pullToRefresh() {
        pullToRefreshProperty.onNext(())
    }

    private let addPaymentTappedProperty = PublishSubject<Void>()
    func addPaymentTapped() {
        addPaymentTappedProperty.onNext(())
    }

    private let paymentToDelete = PublishSubject<Payment>()
    func delete(_ payment: Payment) {
        paymentToDelete.onNext(payment)
    }

    var input: PaymentsViewModelInput { return self }
    var output: PaymentsViewModelOutput { return self }
}
