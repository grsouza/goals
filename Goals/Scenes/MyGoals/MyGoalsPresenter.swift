//
//  MyGoalsPresenter.swift
//  Goals
//
//  Created by Guilherme Souza on 6/23/18.
//  Copyright © 2018 Guilherme Souza. All rights reserved.
//

import Foundation

protocol MyGoalsPresentationLogic: AnyObject {
    func presentGoals(_ goals: [Goal])
    func presentError(_ error: Error)
}

final class MyGoalsPresenter: MyGoalsPresentationLogic {

    weak var view: MyGoalsView!

    func presentGoals(_ goals: [Goal]) {
        let goals = arrange(goals)
            .map(GoalDisplayable.init)

        view.displayGoals(goals)
    }

    func presentError(_ error: Error) {
        view.displayError(error)
    }

    private func arrange(_ goals: [Goal]) -> [Goal] {
        let notCompletedGoals = goals.filter { !$0.isCompleted }
        let completedGoals = goals.filter { $0.isCompleted }

        return notCompletedGoals + completedGoals
    }
}
