//
//  AddGoalViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol AddGoalViewModelInput {
    func confirmTapped()
    func titleChanged(_ value: String?)
    func amountChanged(_ value: String?)
}

protocol AddGoalViewModelOutput {
    var goalCreated: Driver<Void> { get }
//    var amountText: Driver<String?> { get }
}

protocol AddGoalViewModelType {
    var input: AddGoalViewModelInput { get }
    var output: AddGoalViewModelOutput { get }
}

final class AddGoalViewModel: AddGoalViewModelType, AddGoalViewModelInput, AddGoalViewModelOutput {
    let goalCreated: SharedSequence<DriverSharingStrategy, Void>
//    let amountText: SharedSequence<DriverSharingStrategy, String?>

    init(goalService: GoalCreatable = GoalService()) {
        let title = titleProperty.asDriverOnErrorJustComplete().skipNil()
        let amount = amountProperty.asDriverOnErrorJustComplete().skipNil().map(Double.init).skipNil()
        let titleAndAmount = Driver.combineLatest(title, amount).map(sanitize)

        let isValid = titleAndAmount.map(validate)

//        amountText = amount.map { value in
//            let numberFormatter = NumberFormatter()
//            numberFormatter.locale = Locale.current
//            numberFormatter.numberStyle = .currency
//            return numberFormatter.string(from: value as NSNumber)
//        }

        goalCreated = confirmProperty.withLatestFrom(isValid)
            .skipWhile { $0 == false }
            .withLatestFrom(titleAndAmount)
            .flatMap(goalService.create)
            .asDriverOnErrorJustComplete()
            .mapToVoid()
    }

    private let confirmProperty = PublishSubject<Void>()
    func confirmTapped() {
        confirmProperty.onNext(())
    }

    private let titleProperty = PublishSubject<String?>()
    func titleChanged(_ value: String?) {
        titleProperty.onNext(value)
    }

    private let amountProperty = PublishSubject<String?>()
    func amountChanged(_ value: String?) {
        amountProperty.onNext(value)
    }

    var input: AddGoalViewModelInput { return self }
    var output: AddGoalViewModelOutput { return self }
}

private func sanitize(title: String, amount: Double) -> (String, Double) {
    return (title.trimmingCharacters(in: .whitespacesAndNewlines), amount)
}

private func validate(title: String, amount: Double) -> Bool {
    return !(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || amount <= 0)
}
