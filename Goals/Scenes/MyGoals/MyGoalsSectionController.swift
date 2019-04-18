//
//  MyGoalsSectionController.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import IGListKit

protocol MyGoalsSectionControllerDelegate: class {
    func didSelectGoal(_ goal: Goal)
}

final class MyGoalsSectionController: ListSectionController {

    private var item: GoalDisplayable!
    weak var delegate: MyGoalsSectionControllerDelegate?

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(
            withIdentifier: "GoalCell",
            for: self,
            at: index
            ) as? GoalCell else {
                fatalError("Could not dequeue cell with identifier: 'GoalCell'")
        }
        cell.setup(with: item)
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? GoalDisplayable
    }

    override func didSelectItem(at index: Int) {
        delegate?.didSelectGoal(item.goal)
    }
}
