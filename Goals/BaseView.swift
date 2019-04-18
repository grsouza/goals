//
//  BaseView.swift
//  Goals
//
//  Created by Guilherme Souza on 6/23/18.
//  Copyright © 2018 Guilherme Souza. All rights reserved.
//

import UIKit

protocol BaseView: AnyObject {
    func displayError(_ error: Error)
}

extension BaseView where Self: UIViewController {
    func displayError(_ error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
}
