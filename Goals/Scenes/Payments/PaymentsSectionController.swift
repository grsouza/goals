//
//  PaymentsSectionController.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import IGListKit

protocol PaymentsSectionControllerDelegate: class {
    func didSelect(_ payment: Payment)
}

final class PaymentsSectionController: ListSectionController {
    private var item: PaymentDisplayable!
    weak var delegate: PaymentsSectionControllerDelegate?

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height: CGFloat = 64
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(
            withIdentifier: "PaymentCell",
            for: self,
            at: index
            ) as? PaymentCell else {
                fatalError("Could not dequeue cell with identifier: 'GoalCell'")
        }
        cell.setup(with: item)
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? PaymentDisplayable
    }

    override func didSelectItem(at index: Int) {
        delegate?.didSelect(item.payment)
    }
}
