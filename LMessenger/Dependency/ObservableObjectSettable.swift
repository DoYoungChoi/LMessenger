//
//  ObservableObjectSettable.swift
//  LMessenger
//
//  Created by dodor on 12/1/23.
//

import Foundation
import Combine

protocol ObservableObjectSettable: AnyObject {
    var objectWillChange: ObservableObjectPublisher? { get set }
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher)
}

extension ObservableObjectSettable {
    
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher) {
        self.objectWillChange = objectWillChange
    }
}
