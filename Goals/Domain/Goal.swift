//
//  Goal.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Goal: Equatable {
    let uid: String
    let title: String
    let amount: Double
    var payments: [Payment]

    var remaining: Double {
        return amount - totalPaid
    }

    var totalPaid: Double {
        return payments.reduce(0) { $0 + $1.amount }
    }

    var isCompleted: Bool {
        return remaining == 0
    }
}
