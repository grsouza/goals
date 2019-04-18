//
//  GoalOverviewViewModelTest.swift
//  GoalsTests
//
//  Created by Guilherme Souza on 11/01/18.
//  Copyright © 2018 Guilherme Souza. All rights reserved.
//

import RxCocoa
import RxSwift
import RxTest
import XCTest

@testable import Goals

final class GoalOverviewViewModelTest: XCTestCase {

    private var vm: GoalOverviewViewModelType!
    private var disposeBag: DisposeBag!
    private var goalLoaded: TestableObserver<Goal>!

    override func setUp() {
        super.setUp()
        vm = GoalOverviewViewModel(
            goalUID: "12345",
            goalService: MockGoalService()
        )
        disposeBag = DisposeBag()

        let scheduler = TestScheduler(initialClock: 0)
        goalLoaded = scheduler.createObserver(Goal.self)

        vm.output.goal.drive(goalLoaded).disposed(by: disposeBag)
    }
    
    func test_shouldLoadGoal_whenViewAppear() {
        vm.input.viewDidAppear()

        let expected = [
            next(0, Goal(uid: "12345", title: "Buy an iPhone X", amount: 1000, payments: []))
        ]

        XCTAssertEqual(goalLoaded.events, expected)
    }
    
}
