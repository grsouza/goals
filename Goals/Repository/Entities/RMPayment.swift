//
//  RMPayment.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RealmSwift

final class RMPayment: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var goalUID: String = ""

    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension RMPayment: DomainConvertibleType {
    func asDomain() -> Payment {
        return Payment(
            uid: uid,
            date: date,
            amount: amount,
            goalUID: goalUID
        )
    }
}

extension Payment: RealmRepresentable {
    func asRealm() -> RMPayment {
        return RMPayment.build { object in
            object.uid = uid
            object.date = date
            object.amount = amount
            object.goalUID = goalUID
        }
    }
}
