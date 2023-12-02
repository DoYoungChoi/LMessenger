//
//  DBReference.swift
//  LMessenger
//
//  Created by dodor on 12/1/23.
//

import Foundation
import Combine
import FirebaseDatabase

protocol DBReferenceType {
    func setValue(key: String, path: String?, value: Any) async throws
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError>
    func setValues(_ values: [String: Any]) -> AnyPublisher<Void, DBError>
    func getValue(key: String, path: String?) async throws -> Any?
    func getValue(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func filter(key: String, path: String?, orderedValue: String, queryString: String) -> AnyPublisher<Any?, DBError>
}

class DBReference: DBReferenceType {
    
    var db: DatabaseReference = Database.database(url: "https://lmessenger-81a2e-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }
    
    func setValue(key: String, path: String?, value: Any) async throws {
        try await db.child(getPath(key: key, path: path)).setValue(value)
    }
    
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Void, DBError> { [weak self] promise in
            self?.db.child(path).setValue(value) { error, _ in
                if let error {
                    promise(.failure(.error(error)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func setValues(_ values: [String : Any]) -> AnyPublisher<Void, DBError> {
        Future<Void, DBError> { [weak self] promise in
            self?.db.updateChildValues(values) { error, _ in
                if let error {
                    promise(.failure(.error(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getValue(key: String, path: String?) async throws -> Any? {
        let path = getPath(key: key, path: path)
        return try await self.db.child(path).getData().value
    }
    
    func getValue(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Any?, DBError> { [weak self] promise in
            self?.db.child(path).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func filter(key: String, path: String?, orderedValue: String, queryString: String) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future { [weak self] promise in
            self?.db.child(path)
                .queryOrdered(byChild: orderedValue)
                .queryStarting(atValue: queryString)
                .queryEnding(atValue: queryString + "\u{f8ff}")
                .observeSingleEvent(of: .value) {snapshot in
                    promise(.success(snapshot.value))
                }
        }
        .eraseToAnyPublisher()
    }
    
}
