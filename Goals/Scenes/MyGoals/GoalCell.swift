//
//  GoalCell.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class GoalCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var remainingLabel: UILabel!
    @IBOutlet private weak var progressBarOuterView: UIView!
    @IBOutlet private weak var progressBarInnerView: UIView!
    @IBOutlet private weak var progressBarInnerViewWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        progressBarOuterView.layer.cornerRadius = 4
        progressBarOuterView.layer.masksToBounds = true
        progressBarInnerView.layer.cornerRadius = 4
        progressBarInnerView.layer.masksToBounds = true
    }

    func setup(with item: GoalDisplayable) {
        if item.isCompleted {
            applyCompletedStyles()
        } else {
            unapplyCompletedStyles()
        }

        titleLabel.text = item.title
        totalLabel.text = "total \(Formatter.currency(from: item.totalAmount)!)"
        remainingLabel.text = "remaining \(Formatter.currency(from: item.remainingAmount)!)"

        let ratio = (item.totalAmount - item.remainingAmount) / item.totalAmount
        resizeProgressBar(by: ratio)
    }

    private func resizeProgressBar(by ratio: Double) {
        UIView.animate(withDuration: 0.3) {
            self.progressBarInnerViewWidthConstraint.constant = self.progressBarOuterView.frame.width * CGFloat(ratio)
            self.layoutIfNeeded()
        }
    }

    private func applyCompletedStyles() {
        contentView.alpha = 0.3
    }

    private func unapplyCompletedStyles() {
        contentView.alpha = 1.0
    }
}
