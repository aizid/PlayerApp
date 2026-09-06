//
//  LocalDataSource.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import RealmSwift
import RxSwift

public final class LocalDataSource: NSObject {
  private let realm: Realm?
  public init(realm: Realm?) {
    self.realm = realm
  }
  
  static let sharedInstance: (Realm?) -> LocalDataSource = { realmDatabase in
    return LocalDataSource(realm: realmDatabase)
  }
}

extension LocalDataSource {
  public func addingEntity<T: Object>(from entity: [T]) -> Observable<Bool> {
    return Observable<Bool>.create { observe in
      autoreleasepool {
        if let realm = self.realm {
          do {
            try realm.safeWrite {
              entity.forEach {
                realm.add($0, update: .all)
              }
              observe.onNext(true)
              observe.onCompleted()
            }
          } catch let error {
            observe.onError(error)
          }
        } else {
          observe.onError(DatabaseError.invalidInstance)
        }
      }
      
      return Disposables.create()
    }
  }
  
  public func getEntity<T: Object>() -> Observable<[T]> {
    return Observable<[T]>.create { observe in
      autoreleasepool {
        if let realm = self.realm {
          let arObjectEntity: Results<T> = { realm.objects(T.self)}()
          let arObject = arObjectEntity.toArray(ofType: T.self)
          observe.onNext(arObject)
          observe.onCompleted()
        } else {
          observe.onError(DatabaseError.invalidInstance)
        }
      }
      
      return Disposables.create()
    }
  }
    
    public func deleteEntity<T: Object>(from entity: T) -> RxSwift.Observable<Bool> {
        return RxSwift.Observable<Bool>.create { observe in
            autoreleasepool {
                if let realm = self.realm {
                    do {
                        try realm.safeWrite {
                            realm.delete(realm.objects(T.self))
                            observe.onNext(true)
                            observe.onCompleted()
                        }
                    } catch let error {
                        observe.onError(error)
                    }
                } else {
                    observe.onError(DatabaseError.invalidInstance)
                }
            }

            return Disposables.create()
        }
    }
}
