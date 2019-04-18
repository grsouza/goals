//
//  MockGoalService.swift
//  GoalsTests
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

@testable import Goals

final class MockGoalService: GoalCreatable, GoalLoadable {
    var goalCreated: Goal!

    private let goals: [Goal] = [
        Goal(uid: "12345", title: "Buy an iPhone X", amount: 1000, payments: []),
        Goal(uid: "124", title: "Buy a House", amount: 10_342_900, payments: [])
    ]

    func create(with title: String, amount: Double) -> Observable<Goal> {
        let goal = Goal(
            uid: "12345",
            title: title,
            amount: amount,
            payments: []
        )
        goalCreated = goal
        return Observable.just(goal)
    }

    func load(uid: String) -> Observable<Goal> {
        let goal = goals.first(where: { $0.uid == uid })
        return Observable.from(optional: goal)
    }

    func all() -> Observable<[Goal]> {
        return Observable.from(optional: goals)
    }
}
