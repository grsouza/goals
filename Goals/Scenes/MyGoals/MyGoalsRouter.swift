//
//  MyGoalsRouter.swift
//  Goals
//
//  Created by Guilherme Souza on 6/23/18.
//  Copyright © 2018 Guilherme Souza. All rights reserved.
//

import UIKit

protocol MyGoalsRoutingLogic: class {
    func routeToAddGoal()
    func routeToSelectedGoal(_ goal: Goal)
}


final class MyGoalsModule {

    private weak var viewController: UIViewController?

    static func build() -> UIViewController {
        let module = MyGoalsModule()
        let interactor = MyGoalsInteractor(goalsService: GoalService())
        let presenter = MyGoalsPresenter()

        let viewController = Storyboard.MyGoals.instantiate(MyGoalsViewController.self)
        viewController.router = module
        viewController.interactor = interactor

        interactor.presenter = presenter
        presenter.view = viewController

        module.viewController = viewController

        return viewController
    }
}

extension MyGoalsModule: MyGoalsRoutingLogic {

    func routeToAddGoal() {
        let addGoalViewController = AddGoalViewController.instantiate()
        addGoalViewController.modalPresentationStyle = .custom
        guard let transitionDelegate = viewController as? UIViewControllerTransitioningDelegate else {
            fatalError("viewController should implement UIViewControllerTransitioningDelegate")
        }

        addGoalViewController.transitioningDelegate = transitionDelegate
        viewController?.present(addGoalViewController, animated: true)
    }

    func routeToSelectedGoal(_ goal: Goal) {
        let vc1 = UINavigationController(rootViewController: GoalOverviewViewController.instantiate(with: goal))
        vc1.tabBarItem = UITabBarItem(title: "Overview", image: Image.overviewIcon, selectedImage: Image.overviewSelectedIcon)
        let vc2 = UINavigationController(rootViewController: PaymentsViewController.instantiate(with: goal))
        vc2.tabBarItem = UITabBarItem(title: "Payments", image: Image.creditCardIcon, tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([vc1, vc2], animated: false)

        viewController?.present(tabBarController, animated: true)
    }
}
