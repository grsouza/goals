//
//  AddGoalViewModelTest.swift
//  GoalsTests
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import Goals

final class AddGoalViewModelTest: XCTestCase {

    private var vm: AddGoalViewModelType!
    private var disposeBag: DisposeBag!
    private var goalCreated: TestableObserver<Void>!

    override func setUp() {
        super.setUp()
        vm = AddGoalViewModel(goalService: MockGoalService())
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
}
