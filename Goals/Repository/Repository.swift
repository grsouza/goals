//
//  Repository.swift
//  MyGoalsApp
//
//  Created by Guilherme Souza on 08/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxRealm
import RxSwift

private func abstractMethod() -> Never {
    fatalError("abstract method")
}

enum RepositoryError: Error {
    case notFound
}

class AbstractRespository<T> {
    func queryAll() -> Observable<[T]> {
        abstractMethod()
    }

    func query(by id: String) -> Observable<T> {
        abstractMethod()
    }

    func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
        abstractMethod()
    }

    func save(_ entity: T) -> Observable<Void> {
        abstractMethod()
    }

    func save(_ entities: [T]) -> Observable<Void> {
        abstractMethod()
    }

    func delete(by id: String) -> Observable<Void> {
        abstractMethod()
    }

    func delete(with predicate: NSPredicate) -> Observable<Void> {
        abstractMethod()
    }
}

final class Repository<T: RealmRepresentable>: AbstractRespository<T> where T == T.RealmType.DomainType, T.RealmType: Object {

    private let configuration: Realm.Configuration
    private let scheduler: RunLoopThreadScheduler

    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }

    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.configuration = configuration
        let name = "com.grsouza.Goals.Repository"
        scheduler = RunLoopThreadScheduler(threadName: name)
        print("File 📁 url: \(RLMRealmPathForFile("default.realm"))")
    }

    override func queryAll() -> Observable<[T]> {
        return Observable.deferred {
            let objects = self.realm.objects(T.RealmType.self)
            return Observable.array(from: objects)
                .mapToDomain()
        }
            .subscribeOn(scheduler)
    }

    override func query(by id: String) -> Observable<T> {
        return Observable.deferred {
            let object = self.realm.object(ofType: T.RealmType.self, forPrimaryKey: id)?.asDomain()
            return Observable.from(optional: object)
        }
            .subscribeOn(scheduler)
    }

    override func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
        return Observable.deferred {
            let objects = self.realm.objects(T.RealmType.self)
                .filter(predicate)
                .sorted(by: sortDescriptors.map(SortDescriptor.init))

            return Observable.array(from: objects)
                .mapToDomain()
        }
            .subscribeOn(scheduler)
    }

    override func save(_ entity: T) -> Observable<Void> {
        return Observable.deferred { self.realm.rx.save(entity.asRealm()) }
            .subscribeOn(scheduler)
    }

    override func save(_ entities: [T]) -> Observable<Void> {
        return Observable.deferred { self.realm.rx.save(entities.map { $0.asRealm() }) }
            .subscribeOn(scheduler)
    }

    override func delete(by id: String) -> Observable<Void> {
        return Observable.deferred {
            guard let object = self.realm.object(ofType: T.RealmType.self, forPrimaryKey: id) else {
                return Observable.error(RepositoryError.notFound)
            }
            return self.realm.rx.delete(object)
        }
            .subscribeOn(scheduler)
    }

    override func delete(with predicate: NSPredicate) -> Observable<Void> {
        return Observable.deferred {
            let objects = self.realm.objects(T.RealmType.self)
                .filter(predicate)
            return Observable.merge(objects.map(self.realm.rx.delete))
        }
        .subscribeOn(scheduler)
    }

}
