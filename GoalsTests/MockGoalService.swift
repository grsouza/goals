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

struct MockGoalService: GoalCreatable {
    func create(with title: String, amount: Double) -> Observable<Goal> {
        let goal = Goal(
            uid: "12345",
            title: title,
            amount: amount
        )
        return Observable.just(goal)
    }
}
