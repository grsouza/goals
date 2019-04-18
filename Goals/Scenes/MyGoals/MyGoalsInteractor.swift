//
//  MyGoalsInteractor.swift
//  Goals
//
//  Created by Guilherme Souza on 6/23/18.
//  Copyright © 2018 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

protocol MyGoalsBusinessLogic: AnyObject {
    func loadGoals()
}

final class MyGoalsInteractor: MyGoalsBusinessLogic {

    var presenter: MyGoalsPresentationLogic!

    private let goalsService: GoalLoadable
    private let disposeBag = DisposeBag()

    init(goalsService: GoalLoadable) {
        self.goalsService = goalsService
    }

    func loadGoals() {
        goalsService.all()
            .observeOn(MainScheduler.instance)
            .subscribe { [unowned self] event in
                switch event {
                case .next(let goals): self.presenter.presentGoals(goals)
                case .error(let error): self.presenter.presentError(error)
                case .completed: ()
                }
            }
            .disposed(by: disposeBag)
    }
}
