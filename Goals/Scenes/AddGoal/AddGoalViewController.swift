//
//  AddGoalViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import RxSwift
import UIKit

final class AddGoalViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var confirmButton: FloatingButton!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var goalTitleTextField: UITextField!
    @IBOutlet private weak var goalAmountTextField: UITextField!
    @IBOutlet private weak var confirmButtonBottomConstraint: NSLayoutConstraint!

    private let viewModel: AddGoalViewModelType = AddGoalViewModel()
    private let disposeBag = DisposeBag()
    private lazy var keyboardObserver = KeyboardObserver(delegate: self)
    
    static func instantiate() -> AddGoalViewController {
        return Storyboard.AddGoal.instantiate(AddGoalViewController.self)
    }

    // MARK: View's life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        goalTitleTextField.addTarget(self, action: #selector(titleTextFieldChanged(_:)), for: .editingChanged)
        goalAmountTextField.addTarget(self, action: #selector(amountTextFieldChanged(_:)), for: .editingChanged)

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver.start()
    }

    private func bindViewModel() {
        viewModel.output.goalCreated
            .drive(onNext: clearFields)
            .disposed(by: disposeBag)

//        viewModel.output.amountText
//            .drive(goalAmountTextField.rx.text)
//            .disposed(by: disposeBag)
    }

    private func clearFields() {
        goalTitleTextField.text = nil
        goalAmountTextField.text = nil
    }

    // MARK: Actions and Handlers
    @IBAction private func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction private func confirmButtonTapped(_ sender: UIButton) {
        viewModel.input.confirmTapped()
    }

    @objc private func titleTextFieldChanged(_ textField: UITextField) {
        viewModel.input.titleChanged(textField.text)
    }
    
    @objc private func amountTextFieldChanged(_ textField: UITextField) {
        viewModel.input.amountChanged(textField.text)
    }

    // MARK: View's setup
    private func setupView() {
        view.backgroundColor = Color.primaryGreen
        view.tintColor = .white
        goalTitleTextField.textColor = .white
        goalAmountTextField.textColor = .white
        confirmButton.backgroundColor = .white
        confirmButton.tintColor = .black
    }
}

// MARK: - Keyboard Observable
extension AddGoalViewController: KeyboardObservable {
    func keyboardWillShow(with rect: CGRect) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.confirmButtonBottomConstraint.constant = 32 + rect.height
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide(with rect: CGRect) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.confirmButtonBottomConstraint.constant = 32
            self.view.layoutIfNeeded()
        }
    }
}
