//
//  DBError.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
    case invalidatedType
}
