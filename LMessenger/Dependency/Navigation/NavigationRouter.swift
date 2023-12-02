//
//  NavigationRouter.swift
//  LMessenger
//
//  Created by dodor on 11/30/23.
//

import Foundation
import Combine

protocol NavigationRoutable {
    var destinations: [NavigationDestination] { get set }
    
    func push(to view: NavigationDestination)
    func pop()
    func popToRootView()
}

class NavigationRouter: NavigationRoutable, ObservableObjectSettable {
    
    var objectWillChange: ObservableObjectPublisher?
    var destinations: [NavigationDestination] = [] {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    func pop() {
        destinations.removeLast()
    }
    
    func popToRootView() {
        destinations = []
    }
}
