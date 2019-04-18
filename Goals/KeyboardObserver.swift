//
//  KeyboardObserver.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

protocol KeyboardObservable: AnyObject {
    func keyboardWillShow(with rect: CGRect)
    func keyboardWillHide(with rect: CGRect)
}

final class KeyboardObserver {
    private weak var delegate: KeyboardObservable!

    init(delegate: KeyboardObservable) {
        self.delegate = delegate
    }

    func start() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            delegate.keyboardWillShow(with: keyboardSize)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            delegate.keyboardWillHide(with: keyboardSize)
        }
    }
}
