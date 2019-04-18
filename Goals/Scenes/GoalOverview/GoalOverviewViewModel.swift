//
//  GoalOverviewViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol GoalOverviewViewModelInput {
    func viewDidAppear()
}

protocol GoalOverviewViewModelOutput {
    var goal: Driver<Goal> { get }
}

protocol GoalOverviewViewModelType {
    var input: GoalOverviewViewModelInput { get }
    var output: GoalOverviewViewModelOutput { get }
}

final class GoalOverviewViewModel: GoalOverviewViewModelType, GoalOverviewViewModelInput, GoalOverviewViewModelOutput {
    let goal: SharedSequence<DriverSharingStrategy, Goal>

    init(goalUID: String, goalService: GoalLoadable = GoalService()) {
        self.goal = viewDidAppearProperty.flatMap { _ in goalService.load(uid: goalUID) }
            .asDriverOnErrorJustComplete()
    }

    private let viewDidAppearProperty = PublishSubject<Void>()
    func viewDidAppear() {
        viewDidAppearProperty.onNext(())
    }

    var input: GoalOverviewViewModelInput { return self }
    var output: GoalOverviewViewModelOutput { return self }
}
