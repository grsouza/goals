//
//  Realm+Ext.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> ()) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension SortDescriptor {
    init(sortDescriptor: NSSortDescriptor) {
        self.init(keyPath: sortDescriptor.key ?? "", ascending: sortDescriptor.ascending)
    }
}

extension Reactive where Base: Realm {
    func save(_ entity: Object, update: Bool = true) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entity, update: update)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func save(_ entities: [Object], update: Bool = true) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entities, update: update)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func delete(_ entity: Object) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.delete(entity)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func delete(_ entities: Results<Object>) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.delete(entities)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
}
