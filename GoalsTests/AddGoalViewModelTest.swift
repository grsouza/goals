//
//  AddGoalViewModelTest.swift
//  GoalsTests
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import RxCocoa
import RxSwift
import RxTest
import XCTest

@testable import Goals

final class AddGoalViewModelTest: XCTestCase {

    private var vm: AddGoalViewModelType!
    private var mockGoalService: MockGoalService!
    private var disposeBag: DisposeBag!
    private var goalCreated: TestableObserver<Void>!

    override func setUp() {
        super.setUp()
        mockGoalService = MockGoalService()
        vm = AddGoalViewModel(goalService: mockGoalService)
        disposeBag = DisposeBag()

        let scheduler = TestScheduler(initialClock: 0)
        goalCreated = scheduler.createObserver(Void.self)

        vm.output.goalCreated.drive(goalCreated).disposed(by: disposeBag)
    }

    func test_whenInputsAreInvalid_shouldNotCreateGoal() {
        vm.input.titleChanged("")
        vm.input.amountChanged("")
        vm.input.confirmTapped()

        let expected: [Recorded<Event<Void>>] = []
        XCTAssertEqual(goalCreated.events.count, expected.count) // asserting events.count because Void is not equatable.
    }

    func test_whenInputsAreValid_shouldCreateGoal() {
        vm.input.titleChanged("Buy an iPhone X")
        vm.input.amountChanged("1000")
        vm.input.confirmTapped()

        let expected = [
            next(0, ())
        ]
        XCTAssertEqual(goalCreated.events.count, expected.count) // asserting events.count because Void is not equatable.
    }

    func test_whenInputsHaveTrash_shouldSanitizeThemBeforeGoalCreation() {
        vm.input.titleChanged("\n\n   Buy an iPhone X    \n")
        vm.input.amountChanged("1000")
        vm.input.confirmTapped()

        let expected = Goal(
            uid: "12345",
            title: "Buy an iPhone X",
            amount: 1000,
            payments: []
        )
        XCTAssertEqual(mockGoalService.goalCreated, expected)
    }
}
