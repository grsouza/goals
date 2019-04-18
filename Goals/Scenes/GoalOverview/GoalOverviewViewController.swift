//
//  GoalOverviewViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import RxSwift
import UIKit

final class GoalOverviewViewController: UIViewController {

    @IBOutlet private weak var progressView: ProgressView!
    @IBOutlet private weak var totalNeededLabel: UILabel!
    @IBOutlet private weak var totalPaidLabel: UILabel!
    @IBOutlet private weak var remainingLabel: UILabel!

    private var viewModel: GoalOverviewViewModelType!
    private let disposeBag = DisposeBag()

    static func instantiate(with goal: Goal) -> GoalOverviewViewController {
        let controller = Storyboard.GoalOverview.instantiate(GoalOverviewViewController.self)
        controller.viewModel = GoalOverviewViewModel(goalUID: goal.uid)
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.closeIcon, style: .done, target: self, action: #selector(dismissTapped(_:)))
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.viewDidAppear()
    }

    private func bindViewModel() {
        viewModel.output.goal
            .drive(onNext: { [weak self] goal in
                self?.navigationItem.title = goal.title
                self?.totalNeededLabel.text = Formatter.currency(from: goal.amount)
                self?.totalPaidLabel.text = Formatter.currency(from: goal.totalPaid)
                self?.remainingLabel.text = Formatter.currency(from: goal.remaining)

                let ratio = goal.totalPaid / goal.amount
                self?.progressView.animate(to: CGFloat(ratio))
            })
            .disposed(by: disposeBag)
    }

    @objc private func dismissTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}
