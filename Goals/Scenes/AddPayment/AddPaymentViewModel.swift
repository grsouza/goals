//
//  AddPaymentViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol AddPaymentViewModelInput {
    func confirmTapped()
    func amountChanged(_ value: String?)
}

protocol AddPaymentViewModelOutput {
    var paymentCreated: Driver<Void> { get }
    var remainingMessage: Driver<String> { get }
    var isConfirmButtonEnabled: Driver<Bool> { get }
}

protocol AddPaymentViewModelType {
    var input: AddPaymentViewModelInput { get }
    var output: AddPaymentViewModelOutput { get }
}

final class AddPaymentViewModel: AddPaymentViewModelType, AddPaymentViewModelInput, AddPaymentViewModelOutput {

    let paymentCreated: SharedSequence<DriverSharingStrategy, Void>
    let remainingMessage: SharedSequence<DriverSharingStrategy, String>
    let isConfirmButtonEnabled: SharedSequence<DriverSharingStrategy, Bool>

    init(goal: Goal, paymentService: PaymentCreatable = PaymentService()) {

        let amount = amountProperty.asDriverOnErrorJustComplete().whenNil(return: "0")
            .map(Double.init)
            .whenNil(return: 0)

        let remainingValue = Driver.merge(
            Driver.of(goal.remaining),
            amount.map { amount in goal.remaining - amount }
        )

        remainingMessage = remainingValue
            .map { value in
                if let currency = Formatter.currency(from: value), value >= 0 {
                    return "remaining \(currency)"
                } else {
                    return "invalid amount"
                }
            }

        isConfirmButtonEnabled = remainingValue.map { $0 >= 0 }

        paymentCreated = confirmProperty.withLatestFrom(amount)
            .flatMap { amount in paymentService.create(with: amount, on: goal) }
            .asDriverOnErrorJustComplete()
            .mapToVoid()
    }

    private let confirmProperty = PublishSubject<Void>()
    func confirmTapped() {
        confirmProperty.onNext(())
    }

    private let amountProperty = PublishSubject<String?>()
    func amountChanged(_ value: String?) {
        amountProperty.onNext(value)
    }

    var input: AddPaymentViewModelInput { return self }
    var output: AddPaymentViewModelOutput { return self }
}
